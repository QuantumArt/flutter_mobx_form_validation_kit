import 'package:mobx/mobx.dart';

import 'abstract-control.dart';
import 'control-types.dart';
import 'form-abstract-group.dart';
import 'validation-event.dart';

// Include generated file
part 'form-array.g.dart';

class OptionsFormArray<TAbstractControl extends AbstractControl> {
  /// Validations
  /// Валидациии
  List<ValidatorsFunction<FormArray<TAbstractControl>>> validators;

  /// Function enable validation by condition (always enabled by default)
  /// Функция включение валидаций по условию (по умолчанию включено всегда)
  bool Function() activate;

  /// Additional information
  /// Блок с дополнительной информацией
  dynamic additionalData;

  OptionsFormArray({this.validators, this.activate, this.additionalData});
}

class FormArray<TAbstractControl extends AbstractControl> = _FormArray<
    TAbstractControl> with _$FormArray;

abstract class _FormArray<TAbstractControl extends AbstractControl>
    extends FormAbstractGroup with Store {
  ReactionDisposer _reactionOnIsActiveDisposer;

  @observable
  ObservableList<TAbstractControl> controls;

  @computed
  int get length {
    return this.controls.length;
  }

  final List<ValidatorsFunction<FormArray<TAbstractControl>>> _validators;

  _FormArray(

      /// Сontrols
      /// Контролы
      this.controls,

      /// Options
      /// Опции
      {OptionsFormArray<TAbstractControl> options})
      : _validators = options?.validators ?? [],
        super(
            activate: options?.activate,
            additionalData: options?.additionalData,
            type: ControlTypes.Array) {
    this._reactionOnIsActiveDisposer = reaction(
      (_) => this.active,
      (_) {
        this._checkArrayValidations();
        this.onChange.add(this);
      },
    );

    for (final control in this.controls) {
      control.onChange.stream.listen((_) {
        this.serverErrors = [];
        this._checkArrayValidations();
        this.onChange.add(this);
      });
    }

    this._checkArrayValidations();
  }

  TAbstractControl operator [](int index) {
    return this.controls[index];
  }

  void dispose() {
    super.dispose();
    this._reactionOnIsActiveDisposer();
    for (final control in this.getControls()) {
      control.dispose();
    }
  }

  @override
  Future<List<ValidationEvent>> executeAsyncValidation(
          ValidatorsFunction<FormArray<TAbstractControl>> validator) =>
      this.baseExecuteAsyncValidation(
          validator, () => this._checkArrayValidations());

  @action
  _checkArrayValidations() {
    this.inProcessing = true;
    this.serverErrors = [];
    this.onValidation(this._validators, this._checkArrayValidations,
        () => this.inProcessing = false);
  }

  void runInAction(Function action) {
    this
        .reactionOnValidatorDisposers
        .add(reaction((_) => action(), (_) => this._checkArrayValidations()));
  }

  @action
  void add(TAbstractControl element) {
    this.controls.add(element);
    this.onChange.add(this);
  }

  @action
  void addAll(Iterable<TAbstractControl> iterable) {
    this.controls.addAll(iterable);
    this.onChange.add(this);
  }

  @action
  void clear() {
    this.controls.clear();
    this.onChange.add(this);
  }

  @action
  TAbstractControl lastWhere(bool Function(TAbstractControl element) test,
      {TAbstractControl Function() orElse}) {
    final result = this.controls.lastWhere(test, orElse: orElse);
    this.onChange.add(this);
    return result;
  }

  @action
  bool remove(Object element) {
    final result = this.controls.remove(element);
    this.onChange.add(this);
    return result;
  }

  @action
  TAbstractControl removeAt(int index) {
    final result = this.controls.removeAt(index);
    this.onChange.add(this);
    return result;
  }

  @action
  TAbstractControl removeLast() {
    final result = this.controls.removeLast();
    this.onChange.add(this);
    return result;
  }

  @action
  void removeRange(int start, int end) {
    this.controls.removeRange(start, end);
    this.onChange.add(this);
  }

  @action
  void removeWhere(bool Function(TAbstractControl element) test) {
    this.controls.removeWhere(test);
    this.onChange.add(this);
  }

  bool any(bool test(TAbstractControl element)) {
    final result = this.controls.any(test);
    this.onChange.add(this);
    return result;
  }

  bool contains(Object element) {
    final result = this.controls.contains(element);
    this.onChange.add(this);
    return result;
  }

  bool every(bool test(TAbstractControl element)) {
    final result = this.controls.every(test);
    this.onChange.add(this);
    return result;
  }

  TAbstractControl firstWhere(bool Function(TAbstractControl element) test,
      {TAbstractControl Function() orElse}) {
    final result = this.controls.firstWhere(test, orElse: orElse);
    this.onChange.add(this);
    return result;
  }

  @action
  Iterable<TAbstractControl> skip(int count) {
    final result = this.controls.skip(count);
    this.onChange.add(this);
    return result;
  }

  Iterable<TAbstractControl> skipWhile(bool test(TAbstractControl element)) {
    final result = this.controls.skipWhile(test);
    this.onChange.add(this);
    return result;
  }

  Iterable<TAbstractControl> take(int count) {
    final result = this.controls.take(count);
    this.onChange.add(this);
    return result;
  }

  Iterable<TAbstractControl> takeWhile(bool test(TAbstractControl element)) {
    final result = this.controls.takeWhile(test);
    this.onChange.add(this);
    return result;
  }

  Iterable<TAbstractControl> where(bool test(TAbstractControl element)) {
    final result = this.controls.where(test);
    this.onChange.add(this);
    return result;
  }

  @override
  Iterable<AbstractControl> getControls() => this.controls;
}

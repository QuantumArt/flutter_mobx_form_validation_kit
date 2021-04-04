import 'package:mobx/mobx.dart';

import 'abstract-control.dart';
import 'control-types.dart';
import 'form-abstract-group.dart';
import 'validation-event.dart';

// Include generated file
part 'form-group.g.dart';

class OptionsFormGroup<TControls extends ControlsCollection> {
  /// Validations
  /// Валидациии
  List<ValidatorsFunction<FormGroup<TControls>>>? validators;

  /// Function enable validation by condition (always enabled by default)
  /// Функция включение валидаций по условию (по умолчанию включено всегда)
  bool Function()? activate;

  /// Additional information
  /// Блок с дополнительной информацией
  dynamic? additionalData;

  OptionsFormGroup({this.validators, this.activate, this.additionalData});
}

class FormGroup<TControls extends ControlsCollection> = _FormGroup<TControls>
    with _$FormGroup;

abstract class _FormGroup<TControls extends ControlsCollection>
    extends FormAbstractGroup with Store {
  late ReactionDisposer _reactionOnIsActiveDisposer;
  final List<ValidatorsFunction<FormGroup<TControls>>> _validators;

  final TControls controls;

  _FormGroup(

      /// Сontrols
      /// Контролы
      this.controls,

      /// Options
      /// Опции
      {OptionsFormGroup<TControls>? options})
      : _validators = options?.validators ?? [],
        super(
            activate: options?.activate,
            additionalData: options?.additionalData,
            type: ControlTypes.Group) {
    this._reactionOnIsActiveDisposer = reaction(
      (_) => this.active,
      (_) {
        this.serverErrors = [];
        this._checkGroupValidations();
        this.onChange.add(this);
      },
    );

    for (final control in this.getControls()) {
      control.onChange.stream.listen((_) {
        this.serverErrors = [];
        this._checkGroupValidations();
        this.onChange.add(this);
      });
    }

    this._checkGroupValidations();
  }

  @override
  void dispose() {
    super.dispose();
    this._reactionOnIsActiveDisposer();
    for (final control in this.getControls()) {
      control.dispose();
    }
  }

  @override
  Future<List<ValidationEvent>>
      executeAsyncValidation<TAbstractControl extends AbstractControl>(
              ValidatorsFunction<TAbstractControl> validator) =>
          this.baseExecuteAsyncValidation(validator, () {
            this.serverErrors = [];
            this._checkGroupValidations();
          });

  @override
  Iterable<AbstractControl> getControls() => this.controls.allFields();

  @action
  _checkGroupValidations() {
    this.inProcessing = true;
    this.onValidation(this._validators, this._checkGroupValidations,
        () => this.inProcessing = false);
  }

  void runInAction(Function action) {
    this
        .reactionOnValidatorDisposers
        .add(reaction((_) => action(), (_) => this._checkGroupValidations()));
  }
}

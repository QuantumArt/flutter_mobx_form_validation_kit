import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:mobx/mobx.dart';

import 'utilites.dart';
import 'validation-event-types.dart';
import 'validation-event.dart';
import 'control-types.dart';

// Include generated file
part 'abstract-control.g.dart';

typedef UpdateValidValueHandler<TEntity> = void Function(TEntity value);
typedef ValidatorsFunction<TAbstractControl extends AbstractControl>
    = Future<List<ValidationEvent>> Function(TAbstractControl control);

abstract class AbstractControl = _AbstractControl with _$AbstractControl;

abstract class _AbstractControl with Store {
  /// Type
  /// Тип контрола
  final ControlTypes type;

  @protected
  @observable
  bool inProcessing;

  /// Validation in progress
  /// В процессе анализа
  bool get processing;

  bool Function() _isActiveFunc;

  /// Error checking is disabled (control is always valid)
  /// Проверка ошибок отключена (контрол всегда валиден)
  @computed
  bool get disabled {
    return !this.active;
  }

  /// Error checking enabled
  ///  Проверка ошибок включена
  @computed
  bool get active {
    return this._isActiveFunc();
  }

  /// Valid
  /// Валидные данные
  @computed
  bool get valid {
    return !this.invalid;
  }

  /// Invalid
  /// Невалидные данные
  bool get invalid;

  /// The value has not changed
  /// Значение не изменялось
  @computed
  bool get pristine {
    return !this.dirty;
  }

  /// Value changed
  /// Значение изменялось
  bool get dirty;

  /// The field was out of focus
  /// Поле не было в фокусе
  @computed
  bool get untouched {
    return !this.touched;
  }

  /// The field was in focus
  /// Поле было в фокусе
  bool get touched;

  /// The field is now in focus
  /// Поле сейчас в фокусе
  bool get focused;

  @observable
  ObservableList<String> _serverErrors = ObservableList<String>();

  /// Additional (server) errors
  /// Дополнительтные (серверные) ошибки
  @computed
  ObservableList<String> get serverErrors {
    return this._serverErrors;
  }

  /// Additional (server) errors
  /// Дополнительтные (серверные) ошибки
  set serverErrors(List<String> value) {
    this._serverErrors = ObservableList.of(value ?? []);
  }

  @observable
  List<ValidationEvent> _errors = [];

  /// Errors list
  /// Список ошибок
  @computed
  List<ValidationEvent> get errors {
    return this._errors;
  }

  /// The field contains errors
  /// Присутствуют ошибки
  bool hasErrors() {
    return this.errors.length > 0 || this._serverErrors.length > 0;
  }

  @observable
  List<ValidationEvent> _warnings = [];

  /// Warnings messages list
  /// Список сообщений с типом "Внимание"
  @computed
  List<ValidationEvent> get warnings {
    return this._warnings;
  }

  /// The field contains warnings messages
  /// Присутствуют сообщения с типом "Внимание"
  bool hasWarnings() {
    return this.warnings.length > 0;
  }

  @observable
  List<ValidationEvent> _informationMessages = [];

  /// Informations messages list
  /// Сообщения с типом "Информационные сообщения"
  @computed
  List<ValidationEvent> get informationMessages {
    return this._informationMessages;
  }

  /// The field contains informations messages
  /// Присутствуют сообщения с типом "Информационные сообщения"
  bool hasInformationMessages() {
    return this.informationMessages.length > 0;
  }

  @observable
  List<ValidationEvent> _successes = [];

  /// Successes messages list
  /// Сообщения с типом "успешная валидация"
  @computed
  List<ValidationEvent> get successes {
    return this._successes;
  }

  /// The field contains successes
  /// Присутствуют сообщения с типом "успешная валидация"
  bool hasSuccesses() {
    return this.successes.length > 0;
  }

  /// Max message level
  /// Максимальный уровень сообщения
  @computed
  ValidationEventTypes get maxEventLevel {
    if (this.hasErrors()) return ValidationEventTypes.Error;
    if (this.hasWarnings()) return ValidationEventTypes.Warning;
    if (this.hasInformationMessages()) return ValidationEventTypes.Info;
    return ValidationEventTypes.Success;
  }

  /// Set marker "value changed"
  /// Изменяет состояния маркета "данные изменены"
  AbstractControl setDirty(bool dirty);

  /// Set marker "field was out of focus"
  /// Изменяет состояния маркета "значение было в фокусе"
  AbstractControl setTouched(bool touched);

  /// Field for transferring additional information
  /// Поле для передачи дополнительной информации (в логике не участвует)
  @observable
  dynamic additionalData;

  /// Callback function of on change
  /// Сообщает факт изменения данных
  StreamController<AbstractControl> onChange =
      StreamController<AbstractControl>.broadcast();

  _AbstractControl(
      {
      // Function enable validation by condition (always enabled by default)
      // Функция включение валидаций по условию (по умолчанию включено всегда)
      bool Function() activate,
      this.additionalData,
      this.type}) {
    this.inProcessing = false;
    this._isActiveFunc = activate ?? () => true;
  }

  /// Dispose (call in unmount react control)
  /// Вызвать при удалении контрола
  void dispose() {
    this.onChange.close();
  }

  /// Get error by key
  /// Получить ошибку по ключу
  ValidationEvent error(String key) {
    return this.errors.firstWhere((err) => err.key == key, orElse: () => null);
  }

  int _newRequestValidation = 0;
  List<ValidatorsFunction<AbstractControl>> _lastValidators = [];
  Function lastValidationFunction = (() {});
  
  @protected
  List<ReactionDisposer> reactionOnValidatorDisposers = [];
  
  @protected
  @action
  Future onValidation<TAbstractControl extends AbstractControl>(
      List<ValidatorsFunction<TAbstractControl>> validators,
      Function onValidationFunction,
      Function afterCheck) async {
    final haveRequestValidation = this._newRequestValidation != 0;
    this._newRequestValidation++;
    this._lastValidators = validators
        .map((validator) => (AbstractControl control) => validator(control))
        .toList();
    this.lastValidationFunction = onValidationFunction;
    if (haveRequestValidation) {
      return;
    }
    List<List<ValidationEvent>> groupErrors;
    int oldRequestValidation = 0;
    do {
      oldRequestValidation = this._newRequestValidation;
      this.reactionOnValidatorDisposers.forEach((r) => r());
      this.reactionOnValidatorDisposers = [];
      if (this.active) {
        final errorsPromises = this._lastValidators.map((validator) {
          bool isFirstReaction = true;
          final completer = Completer<List<ValidationEvent>>();
          this.reactionOnValidatorDisposers.add(
                reaction((_) {
                  dynamic result;
                  if (isFirstReaction) {
                    result = validator(this).then(completer.complete);
                  }
                  isFirstReaction = false;
                  return result;
                }, (_) => this.lastValidationFunction()),
              );
          return completer.future;
        });

        groupErrors = await Future.wait(errorsPromises);
      } else {
        groupErrors = [];
      }
    } while (oldRequestValidation != this._newRequestValidation);
    this._newRequestValidation = 0;
    final List<ValidationEvent> events =
        groupErrors.length > 0 ? combineErrors(groupErrors) : [];

    runInAction(() {
      this._errors =
          events.where((e) => e.type == ValidationEventTypes.Error).toList();
      this._warnings =
          events.where((e) => e.type == ValidationEventTypes.Warning).toList();
      this._informationMessages =
          events.where((e) => e.type == ValidationEventTypes.Info).toList();
      this._successes =
          events.where((e) => e.type == ValidationEventTypes.Success).toList();

      afterCheck();
    });
  }

  Future<List<ValidationEvent>> executeAsyncValidation(
      ValidatorsFunction<dynamic> validator);

  void runInAction(Function action);

  @protected
  Future<List<ValidationEvent>>
      baseExecuteAsyncValidation<TAbstractControl extends AbstractControl>(
    ValidatorsFunction<TAbstractControl> validator,
    Function onValidationFunction,
  ) {
    bool isFirstReaction = true;
    final completer = Completer<List<ValidationEvent>>();
    this.reactionOnValidatorDisposers.add(
          reaction((_) {
            dynamic result;
            if (isFirstReaction) {
              result = validator(this).then(completer.complete);
            }
            isFirstReaction = false;
            return result;
          }, (_) => onValidationFunction()),
        );
    return completer.future;
  }
}

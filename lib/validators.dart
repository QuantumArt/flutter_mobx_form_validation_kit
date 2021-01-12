import 'abstract-control.dart';
import 'form-control.dart';
import 'utilites.dart';
import 'validation-event-types.dart';
import 'validation-event.dart';

const requiredValidatorKey = 'required';
ValidatorsFunction<FormControl<TEntity>> requiredValidator<TEntity>(
        {String message = 'Поле обязательно',
        eventType = ValidationEventTypes.Error}) =>
    (FormControl<TEntity> control) async {
      if (control.value == null ||
          (TEntity == String && (control.value as String)?.isEmpty == true)) {
        return [
          ValidationEvent(
            key: requiredValidatorKey,
            message: message,
            type: eventType,
          )
        ];
      }
      return [];
    };

const notEmptyOrSpacesValidatorKey = 'notEmptyOrSpaces';
ValidatorsFunction<FormControl<String>> notEmptyOrSpacesValidator(
        {String message = 'Отсутствует значение',
        eventType = ValidationEventTypes.Error}) =>
    (FormControl<String> control) async {
      if (control.value != null && control.value.trim() != '') {
        return [];
      }
      return [
        ValidationEvent(
          key: notEmptyOrSpacesValidatorKey,
          message: message,
          type: eventType,
        )
      ];
    };

const notContainSpacesValidatorKey = 'notContainSpaces';

/// Not contain spaces
/// Не содержит проблелов
ValidatorsFunction<FormControl<String>> notContainSpacesValidator(
        {String message = 'Не должен содержать пробелы',
        eventType = ValidationEventTypes.Error}) =>
    (FormControl<String> control) async {
      if (control.value == null ||
          RegExp(r"\s").allMatches(control.value).isEmpty) {
        return [];
      }
      return [
        ValidationEvent(
          key: notContainSpacesValidatorKey,
          message: message,
          type: eventType,
        )
      ];
    };

const patternValidatorKey = 'pattern';

/// Error if there is no pattern matching
/// Ошибка, если нет соответствия паттерну
ValidatorsFunction<FormControl<String>> patternValidator(
  RegExp regExp, {
  String message = 'Присутствуют недопустимые символы',
  eventType = ValidationEventTypes.Error,
}) =>
    (FormControl<String> control) async {
      if (control.value != null &&
          regExp.allMatches(control.value).isNotEmpty) {
        return [];
      }
      return [
        ValidationEvent(
          key: patternValidatorKey,
          message: message,
          type: eventType,
        )
      ];
    };

///  Error if there is a pattern match
///  Ошибка, если есть соответствие паттерну
ValidatorsFunction<FormControl<String>> invertPatternValidator({
  RegExp regExp,
  String message = 'Присутствуют недопустимые символы',
  eventType = ValidationEventTypes.Error,
}) =>
    (FormControl<String> control) async {
      if (control.value != null &&
          regExp.allMatches(control.value).isNotEmpty) {
        return [
          ValidationEvent(
            key: patternValidatorKey,
            message: message,
            type: eventType,
          )
        ];
      }
      return [];
    };

const minLengthValidatorKey = 'minlength';
ValidatorsFunction<FormControl<String>> minLengthValidator(int minlength,
    {String message, eventType = ValidationEventTypes.Error}) {
  message = message ?? "Минимальная длина $minlength";
  return (FormControl<String> control) async {
    if (control.value == null ||
        minlength <= control.value.length ||
        control.value == '') {
      return [];
    }
    return [
      ValidationEvent(
        key: minLengthValidatorKey,
        message: message,
        type: eventType,
      )
    ];
  };
}

const maxLengthValidatorKey = 'maxlength';
ValidatorsFunction<FormControl<String>> maxLengthValidator(int maxlength,
    {String message, eventType = ValidationEventTypes.Error}) {
  message = message ?? "Максимальная длина $maxlength";
  return (FormControl<String> control) async {
    if (control.value == null || control.value.length <= maxlength) {
      return [];
    }
    return [
      ValidationEvent(
        key: maxLengthValidatorKey,
        message: message,
        type: eventType,
      )
    ];
  };
}

const absoluteLengthValidatorKey = 'absoluteLength';
ValidatorsFunction<FormControl<String>> absoluteLengthValidator(int length,
    {String message, eventType = ValidationEventTypes.Error}) {
  message = message ?? "Длина отлична от $length";
  return (FormControl<String> control) async {
    if (control.value == null || control.value.length == length) {
      return [];
    }
    return [
      ValidationEvent(
        key: absoluteLengthValidatorKey,
        message: message,
        type: eventType,
      )
    ];
  };
}

const minValueValidatorKey = 'minValue';
ValidatorsFunction<FormControl<TEntity>>
    minValueValidator<TEntity extends num>({
  TEntity min,
  TEntity Function() getterMin,
  String message = 'Значение слишком маленькое',
  eventType = ValidationEventTypes.Error,
}) {
  assert(
      !(min != null && getterMin != null), "use \"value\" or \"getterValue\"");
  assert(
      !(min == null && getterMin == null), "use \"value\" or \"getterValue\"");
  final getMin = getterMin ?? () => min;
  return (FormControl<TEntity> control) async {
    if (control.value == null) {
      return [];
    }
    final minValue = getMin();
    final value = control.value;
    // if (typeof value === 'string') {
    //   if (typeof minValue === 'number') {
    //     value = +value;
    //   } else if (minValue instanceof Date) {
    //     value = new Date(value);
    //   }
    // }
    if (value < minValue) {
      return [
        ValidationEvent(
          key: minValueValidatorKey,
          message: message,
          type: eventType,
        )
      ];
    }
    return [];
  };
}

const maxValueValidatorKey = 'minValue';
ValidatorsFunction<FormControl<TEntity>>
    maxValueValidator<TEntity extends num>({
  TEntity max,
  TEntity Function() getterMax,
  String message = 'Значение слишком большое',
  eventType = ValidationEventTypes.Error,
}) {
  assert(
      !(max != null && getterMax != null), "use \"value\" or \"getterValue\"");
  assert(
      !(max == null && getterMax == null), "use \"value\" or \"getterValue\"");
  final getMax = getterMax ?? () => max;
  return (FormControl<TEntity> control) async {
    if (control.value == null) {
      return [];
    }
    final maxValue = getMax();
    final value = control.value;
    // if (typeof value === 'string') {
    //   if (typeof maxValue === 'number') {
    //     value = +value;
    //   } else if (maxValue instanceof Date) {
    //     value = new Date(value);
    //   }
    // }
    if (maxValue < value) {
      return [
        ValidationEvent(
          key: maxValueValidatorKey,
          message: message,
          type: eventType,
        )
      ];
    }
    return [];
  };
}

const compairValidatorKey = 'compair';

/// Wrapper for complex validation (error if validation returns false)
/// Обёртка для сложной проверки (ошибка, если проверка вернула false)
ValidatorsFunction<FormControl<TEntity>> compareValidator<TEntity>(
  bool Function(TEntity value) expression, {
  String message = 'Поле не валидно',
  eventType = ValidationEventTypes.Error,
}) =>
    (FormControl<TEntity> control) async {
      if (expression(control.value)) {
        return [];
      }
      return [
        ValidationEvent(
          key: compairValidatorKey,
          message: message,
          type: eventType,
        )
      ];
    };

const isEqualValidatorKey = 'isEqual';

/// Equals to {value}
/// Равно значению {value}
ValidatorsFunction<FormControl<TEntity>> isEqualValidator<TEntity>(
        TEntity value,
        {String message = 'Поля не совпадают',
        eventType = ValidationEventTypes.Error}) =>
    (FormControl<TEntity> control) async {
      if (control.value == null || control.value != value) {
        return [];
      }
      return [
        ValidationEvent(
          key: isEqualValidatorKey,
          message: message,
          type: eventType,
        )
      ];
    };

///  Runs validations only if activation conditions are met
///  Запускает валидации только если условие активации выполнено
ValidatorsFunction<TAbstractControl> wrapperActivateValidation<
        TAbstractControl extends AbstractControl>(
  bool Function(TAbstractControl control) activate,
  List<ValidatorsFunction<TAbstractControl>> validators, {
  List<ValidatorsFunction<TAbstractControl>> elseValidators,
}) =>
    (TAbstractControl control) async {
      if (activate(control)) {
        final validations = await Future.wait((validators ?? []).map(
            (validator) => control
                .executeAsyncValidation((control) => validator(control))));
        return combineErrors(validations);
      }
      if (elseValidators != null && elseValidators.length > 0) {
        final validations = await Future.wait(elseValidators.map((validator) =>
            control.executeAsyncValidation((control) => validator(control))));
        return combineErrors(validations);
      }
      return [];
    };

/// Wrapper for sequential validations (The next validation is launched only after the previous one passed without errors)
/// Обертка для последовательных валидаций (Следующая валидация запускается, только после того, что предыдущая прошла без ошибок)
ValidatorsFunction<TAbstractControl>
    wrapperSequentialCheck<TAbstractControl extends AbstractControl>(
        List<ValidatorsFunction<TAbstractControl>> validators) {
  return (TAbstractControl control) async {
    for (final validator in validators) {
      final validationResult =
          await control.executeAsyncValidation((control) => validator(control));
      if (validationResult.length > 0) {
        return validationResult;
      }
    }
    return [];
  };
}

import 'package:flutter/widgets.dart';
import 'package:flutter_mobx_form_validation_kit/control-types.dart';
import 'package:mobx/mobx.dart';

import 'abstract-control.dart';
import 'text-editing-controller.dart';
import 'validation-event.dart';

// Include generated file
part 'form-control.g.dart';

class OptionsFormControl<TEntity> {
  final List<ValidatorsFunction<FormControl<TEntity>>> validators;

  /// Function enable validation by condition (always enabled by default)
  /// Функция включение валидаций по условию (по умолчанию включено всегда)
  final bool Function() activate;

  /// Additional information
  /// Блок с дополнительной информацией
  final dynamic additionalData;

  /// Callback always when value changes
  /// Срабатывает всегда при изменении значения
  final UpdateValidValueHandler<TEntity> onChangeValue;

  /// Callback get last valid value
  /// Передает последние валидное значение
  final UpdateValidValueHandler<TEntity> onChangeValidValue;

  /// Invoke [onChangeValidValue] when [FormControl] is created.
  /// Вызвать [onChangeValidValue] при создании [FormControl].
  /// ```
  /// const model = observable({ value: 123 });
  /// new FormControl(
  ///   () => model.value,
  ///   [],
  ///   value => { console.log({ value }); },
  ///   { callSetterOnInitialize: true }
  /// ); // then we see { value: 123 } in console immediately
  /// ```
  final bool callSetterOnInitialize;

  /// Invoke `onChangeValidValue` when value-getter that passed as first argument changes its underlying value.
  /// Вызывать `onChangeValidValue` при каждом изменении результата функции-геттера из первого аргумента.
  /// ```
  /// const model = observable({ value: 123 });
  /// new FormControl(
  ///   () => model.value,
  ///   [],
  ///   value => { console.log({ value }); },
  ///   { callSetterOnReinitialize: true }
  /// );
  /// model.value = 456; // then we see { value: 456 } in console
  /// ```
  final bool callSetterOnReinitialize;

  OptionsFormControl({
    this.validators,
    this.activate,
    this.additionalData,
    this.onChangeValue,
    this.onChangeValidValue,
    this.callSetterOnInitialize = true,
    this.callSetterOnReinitialize = false,
  });
}

class FormControl<TEntity> = _FormControl<TEntity> with _$FormControl;

abstract class _FormControl<TEntity> extends AbstractControl with Store {
  @observable
  TEntity _internalValue;

  FormControlTextEditingController _controller;

  FormControlTextEditingController get controller {
    return this._controller;
  }

  FocusNode _focusNode;
  FocusNode get focusNode {
    return this._focusNode;
  }

  ReactionDisposer _reactionOnValueGetterDisposer;
  ReactionDisposer _reactionOnInternalValueDisposer;

  ReactionDisposer _reactionOnInternalValue;
  ReactionDisposer _reactionOnIsActiveDisposer;
  ReactionDisposer _reactionOnIsDirtyDisposer;
  ReactionDisposer _reactionOnIsFocusedDisposer;
  final List<ValidatorsFunction<FormControl<TEntity>>> _validators;
  final UpdateValidValueHandler<TEntity> _setValidValue;
  final UpdateValidValueHandler<TEntity> _onChangeValue;
  final bool _callSetterOnInitialize;
  final bool _callSetterOnReinitialize;
  bool _isInitialized = false;

  @observable
  bool _isDirty = false;

  @override
  @computed
  bool get dirty {
    return this._isDirty;
  }

  @observable
  bool _isTouched = false;

  @override
  @computed
  bool get touched {
    return this._isTouched;
  }

  @observable
  bool _isFocused = false;

  @override
  @computed
  bool get focused {
    return this._isFocused;
  }

  @override
  @computed
  bool get processing {
    return this.inProcessing;
  }

  _FormControl(
      {TEntity value,
      TEntity Function() getterValue,
      OptionsFormControl<TEntity> options})
      : _validators = options?.validators ?? [],
        _setValidValue = options?.onChangeValidValue ?? ((_) {}),
        _onChangeValue = options?.onChangeValue ?? ((_) {}),
        _callSetterOnInitialize = options?.callSetterOnInitialize ?? true,
        _callSetterOnReinitialize = options?.callSetterOnReinitialize ?? false,
        assert(!(value != null && getterValue != null),
            "use \"value\" or \"getterValue\""),
        super(
            activate: options?.activate,
            additionalData: options?.additionalData,
            type: ControlTypes.Control) {
    if (TEntity == String) {
      this._controller = FormControlTextEditingController();
      this._reactionOnInternalValue = reaction(
        (_) => this._internalValue,
        (value) => this.controller.text = value,
      );
    }
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        this.setTouched(true);
      }
      this.setFocused(_focusNode.hasFocus);
    });

    this._reactionOnIsActiveDisposer = reaction(
      (_) => this.active,
      (_) {
        this.serverErrors = [];
        this._checkInternalValue(
            this._isInitialized || this._callSetterOnInitialize);
        this._isInitialized = true;
      },
    );

    this._reactionOnIsDirtyDisposer = reaction(
      (_) => this.dirty,
      (bool isDirty) {
        if (isDirty) {
          this.serverErrors = [];
        }
      },
    );

    this._reactionOnIsFocusedDisposer = reaction(
      (_) => this.focused,
      (bool isFocused) {
        if (!isFocused) {
          this.serverErrors = [];
        }
      },
    );

    this.setInitialValue(value: value, getterValue: getterValue);
  }

  /// Set marker "Value has changed"
  /// Установить маркер "Значение изменилось"
  @override
  @action
  FormControl<TEntity> setDirty(bool dirty) {
    this._isDirty = dirty;
    return this;
  }

  /// Set marker "field was in focus"
  /// Установить маркер "Поле было в фокусе"
  @override
  @action
  FormControl<TEntity> setTouched(bool touched) {
    this._isTouched = touched;
    return this;
  }

  @action
  FormControl<TEntity> setFocused(bool focused) {
    this._isFocused = focused;
    return this;
  }

  @computed
  TEntity get value {
    return this._internalValue;
  }

  set value(TEntity value) {
    this._internalValue = value;
  }

  @override
  @computed
  bool get invalid {
    return this.active &&
        (this.errors.length > 0 || this.serverErrors.length > 0);
  }

  FormControl<TEntity> setInitialValue({
    TEntity value,
    TEntity Function() getterValue,
  }) {
    assert(!(value != null && getterValue != null),
        "use \"value\" or \"getterValue\"");
    final getter = getterValue ?? () => value;
    if (this._reactionOnValueGetterDisposer != null) {
      this._reactionOnValueGetterDisposer();
    }

    this._reactionOnValueGetterDisposer = reaction(
      (_) => getter(),
      (TEntity initialValue) {
        this.inProcessing = true;
        if (this._reactionOnInternalValueDisposer != null) {
          this._reactionOnInternalValueDisposer();
        }

        this._internalValue = initialValue;
        this.serverErrors = [];
        this._reactionOnInternalValueDisposer = reaction(
          (_) => this._internalValue,
          (_) {
            runInAction(() => this._onChangeValue(this._internalValue));
            this._isDirty = true;
            this.serverErrors = [];
            this._checkInternalValue(true);
          },
        );

        this._checkInternalValue(this._isInitialized
            ? this._callSetterOnReinitialize
            : this._callSetterOnInitialize);
        this._isInitialized = true;
      },
      fireImmediately: true,
    );

    return this;
  }

  @override
  void dispose() {
    super.dispose();
    if (this._reactionOnInternalValue != null) {
      this._reactionOnInternalValue();
    }
    this.controller?.dispose();
    this.focusNode.dispose();
    if (this._reactionOnValueGetterDisposer != null) {
      this._reactionOnValueGetterDisposer();
    }
    if (this._reactionOnInternalValueDisposer != null) {
      this._reactionOnInternalValueDisposer();
    }
    this._reactionOnIsActiveDisposer();
    this._reactionOnIsDirtyDisposer();
    this._reactionOnIsFocusedDisposer();
  }

  @action
  void _checkInternalValue(bool shouldCallSetter) {
    this.inProcessing = true;
    this.onValidation<FormControl<TEntity>>(
        this._validators, () => this._checkInternalValue(true), () {
      if (shouldCallSetter && this.errors.length == 0) {
        this._setValidValue(this._internalValue);
      }
      this.inProcessing = false;
    });
  }

  @override
  Future<List<ValidationEvent>> executeAsyncValidation(
          ValidatorsFunction<FormControl<TEntity>> validator) =>
      this.baseExecuteAsyncValidation(validator, () {
        this.serverErrors = [];
        this._checkInternalValue(true);
      });
}

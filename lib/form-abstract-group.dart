import 'package:flutter/widgets.dart';
import 'package:mobx/mobx.dart';

import 'abstract-control.dart';
import 'control-types.dart';

// Include generated file
part 'form-abstract-group.g.dart';

abstract class ControlsCollection {
  Iterable<AbstractControl> allFields();
}

abstract class FormAbstractGroup = _FormAbstractGroup with _$FormAbstractGroup;

abstract class _FormAbstractGroup extends AbstractControl with Store {
  @computed
  bool get processing {
    return this.inProcessing ||
        this._abbreviatedOR((control) => control.processing);
  }

  @computed
  bool get invalid {
    return this.active &&
        (this.errors.length > 0 ||
            this.serverErrors.length > 0 ||
            this._abbreviatedOR((control) => control.invalid));
  }

  @computed
  bool get dirty {
    return this._abbreviatedOR((control) => control.dirty);
  }

  @computed
  bool get touched {
    return this._abbreviatedOR((control) => control.touched);
  }

  @computed
  bool get focused {
    return this._abbreviatedOR((control) => control.focused);
  }

  _FormAbstractGroup(
      {bool Function() activate, dynamic additionalData, ControlTypes type})
      : super(activate: activate, additionalData: additionalData, type: type);

  /// Set marker "Value has changed"
  /// Установить маркер "Значение изменилось"
  @override
  @action
  setDirty(bool dirty) {
    for (final control in this.getControls()) {
      control.setDirty(dirty);
    }
    return this;
  }

  /// Set marker "field was in focus"
  /// Установить маркер "Поле было в фокусе"
  @override
  @action
  setTouched(bool touched) {
    for (final control in this.getControls()) {
      control.setTouched(touched);
    }
    return this;
  }

  /// Waiting for end of validation
  /// Ожидание окончания проверки
  Future wait() => asyncWhen((_) => !this.processing);

  /// Returns a complete list of FormControls without subgroups (terminal elements)
  /// Возвращает полный список FormControl-ов без вложений (терминальные элементы)
  List<AbstractControl> allControls() {
    List<AbstractControl> controls = [];
    for (final control in this.getControls()) {
      if (control.type == ControlTypes.Control) {
        controls.add(control);
      } else if (control.type == ControlTypes.Group ||
          control.type == ControlTypes.Array) {
        controls.addAll((control as FormAbstractGroup).allControls());
      }
    }
    return controls;
  }

  @protected
  Iterable<AbstractControl> getControls();
  bool _abbreviatedOR(bool Function(AbstractControl control) getData) {
    for (final control in this.getControls()) {
      if (getData(control)) {
        return true;
      }
    }
    return false;
  }
}

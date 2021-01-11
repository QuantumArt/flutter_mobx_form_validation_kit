// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form-control.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$FormControl<TEntity> on _FormControl<TEntity>, Store {
  Computed<bool> _$dirtyComputed;

  @override
  bool get dirty => (_$dirtyComputed ??=
          Computed<bool>(() => super.dirty, name: '_FormControl.dirty'))
      .value;
  Computed<bool> _$touchedComputed;

  @override
  bool get touched => (_$touchedComputed ??=
          Computed<bool>(() => super.touched, name: '_FormControl.touched'))
      .value;
  Computed<bool> _$focusedComputed;

  @override
  bool get focused => (_$focusedComputed ??=
          Computed<bool>(() => super.focused, name: '_FormControl.focused'))
      .value;
  Computed<bool> _$processingComputed;

  @override
  bool get processing =>
      (_$processingComputed ??= Computed<bool>(() => super.processing,
              name: '_FormControl.processing'))
          .value;
  Computed<TEntity> _$valueComputed;

  @override
  TEntity get value => (_$valueComputed ??=
          Computed<TEntity>(() => super.value, name: '_FormControl.value'))
      .value;
  Computed<bool> _$invalidComputed;

  @override
  bool get invalid => (_$invalidComputed ??=
          Computed<bool>(() => super.invalid, name: '_FormControl.invalid'))
      .value;

  final _$_internalValueAtom = Atom(name: '_FormControl._internalValue');

  @override
  TEntity get _internalValue {
    _$_internalValueAtom.reportRead();
    return super._internalValue;
  }

  @override
  set _internalValue(TEntity value) {
    _$_internalValueAtom.reportWrite(value, super._internalValue, () {
      super._internalValue = value;
    });
  }

  final _$_isDirtyAtom = Atom(name: '_FormControl._isDirty');

  @override
  bool get _isDirty {
    _$_isDirtyAtom.reportRead();
    return super._isDirty;
  }

  @override
  set _isDirty(bool value) {
    _$_isDirtyAtom.reportWrite(value, super._isDirty, () {
      super._isDirty = value;
    });
  }

  final _$_isTouchedAtom = Atom(name: '_FormControl._isTouched');

  @override
  bool get _isTouched {
    _$_isTouchedAtom.reportRead();
    return super._isTouched;
  }

  @override
  set _isTouched(bool value) {
    _$_isTouchedAtom.reportWrite(value, super._isTouched, () {
      super._isTouched = value;
    });
  }

  final _$_isFocusedAtom = Atom(name: '_FormControl._isFocused');

  @override
  bool get _isFocused {
    _$_isFocusedAtom.reportRead();
    return super._isFocused;
  }

  @override
  set _isFocused(bool value) {
    _$_isFocusedAtom.reportWrite(value, super._isFocused, () {
      super._isFocused = value;
    });
  }

  final _$_FormControlActionController = ActionController(name: '_FormControl');

  @override
  FormControl<TEntity> setDirty(bool dirty) {
    final _$actionInfo = _$_FormControlActionController.startAction(
        name: '_FormControl.setDirty');
    try {
      return super.setDirty(dirty);
    } finally {
      _$_FormControlActionController.endAction(_$actionInfo);
    }
  }

  @override
  FormControl<TEntity> setTouched(bool touched) {
    final _$actionInfo = _$_FormControlActionController.startAction(
        name: '_FormControl.setTouched');
    try {
      return super.setTouched(touched);
    } finally {
      _$_FormControlActionController.endAction(_$actionInfo);
    }
  }

  @override
  FormControl<TEntity> setFocused(bool focused) {
    final _$actionInfo = _$_FormControlActionController.startAction(
        name: '_FormControl.setFocused');
    try {
      return super.setFocused(focused);
    } finally {
      _$_FormControlActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _checkInternalValue(bool shouldCallSetter) {
    final _$actionInfo = _$_FormControlActionController.startAction(
        name: '_FormControl._checkInternalValue');
    try {
      return super._checkInternalValue(shouldCallSetter);
    } finally {
      _$_FormControlActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
dirty: ${dirty},
touched: ${touched},
focused: ${focused},
processing: ${processing},
value: ${value},
invalid: ${invalid}
    ''';
  }
}

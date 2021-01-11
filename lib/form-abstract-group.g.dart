// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form-abstract-group.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$FormAbstractGroup on _FormAbstractGroup, Store {
  Computed<bool> _$processingComputed;

  @override
  bool get processing =>
      (_$processingComputed ??= Computed<bool>(() => super.processing,
              name: '_FormAbstractGroup.processing'))
          .value;
  Computed<bool> _$invalidComputed;

  @override
  bool get invalid => (_$invalidComputed ??= Computed<bool>(() => super.invalid,
          name: '_FormAbstractGroup.invalid'))
      .value;
  Computed<bool> _$dirtyComputed;

  @override
  bool get dirty => (_$dirtyComputed ??=
          Computed<bool>(() => super.dirty, name: '_FormAbstractGroup.dirty'))
      .value;
  Computed<bool> _$touchedComputed;

  @override
  bool get touched => (_$touchedComputed ??= Computed<bool>(() => super.touched,
          name: '_FormAbstractGroup.touched'))
      .value;
  Computed<bool> _$focusedComputed;

  @override
  bool get focused => (_$focusedComputed ??= Computed<bool>(() => super.focused,
          name: '_FormAbstractGroup.focused'))
      .value;

  final _$_FormAbstractGroupActionController =
      ActionController(name: '_FormAbstractGroup');

  @override
  AbstractControl setDirty(bool dirty) {
    final _$actionInfo = _$_FormAbstractGroupActionController.startAction(
        name: '_FormAbstractGroup.setDirty');
    try {
      return super.setDirty(dirty);
    } finally {
      _$_FormAbstractGroupActionController.endAction(_$actionInfo);
    }
  }

  @override
  AbstractControl setTouched(bool touched) {
    final _$actionInfo = _$_FormAbstractGroupActionController.startAction(
        name: '_FormAbstractGroup.setTouched');
    try {
      return super.setTouched(touched);
    } finally {
      _$_FormAbstractGroupActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
processing: ${processing},
invalid: ${invalid},
dirty: ${dirty},
touched: ${touched},
focused: ${focused}
    ''';
  }
}

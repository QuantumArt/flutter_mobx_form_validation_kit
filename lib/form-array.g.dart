// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form-array.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$FormArray<TAbstractControl extends AbstractControl>
    on _FormArray<TAbstractControl>, Store {
  Computed<int>? _$lengthComputed;

  @override
  int get length => (_$lengthComputed ??=
          Computed<int>(() => super.length, name: '_FormArray.length'))
      .value;

  final _$controlsAtom = Atom(name: '_FormArray.controls');

  @override
  ObservableList<TAbstractControl> get controls {
    _$controlsAtom.reportRead();
    return super.controls;
  }

  @override
  set controls(ObservableList<TAbstractControl> value) {
    _$controlsAtom.reportWrite(value, super.controls, () {
      super.controls = value;
    });
  }

  final _$_FormArrayActionController = ActionController(name: '_FormArray');

  @override
  void add(TAbstractControl element) {
    final _$actionInfo =
        _$_FormArrayActionController.startAction(name: '_FormArray.add');
    try {
      return super.add(element);
    } finally {
      _$_FormArrayActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addAll(Iterable<TAbstractControl> iterable) {
    final _$actionInfo =
        _$_FormArrayActionController.startAction(name: '_FormArray.addAll');
    try {
      return super.addAll(iterable);
    } finally {
      _$_FormArrayActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clear() {
    final _$actionInfo =
        _$_FormArrayActionController.startAction(name: '_FormArray.clear');
    try {
      return super.clear();
    } finally {
      _$_FormArrayActionController.endAction(_$actionInfo);
    }
  }

  @override
  bool remove(Object element) {
    final _$actionInfo =
        _$_FormArrayActionController.startAction(name: '_FormArray.remove');
    try {
      return super.remove(element);
    } finally {
      _$_FormArrayActionController.endAction(_$actionInfo);
    }
  }

  @override
  TAbstractControl removeAt(int index) {
    final _$actionInfo =
        _$_FormArrayActionController.startAction(name: '_FormArray.removeAt');
    try {
      return super.removeAt(index);
    } finally {
      _$_FormArrayActionController.endAction(_$actionInfo);
    }
  }

  @override
  TAbstractControl removeLast() {
    final _$actionInfo =
        _$_FormArrayActionController.startAction(name: '_FormArray.removeLast');
    try {
      return super.removeLast();
    } finally {
      _$_FormArrayActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeRange(int start, int end) {
    final _$actionInfo = _$_FormArrayActionController.startAction(
        name: '_FormArray.removeRange');
    try {
      return super.removeRange(start, end);
    } finally {
      _$_FormArrayActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeWhere(bool Function(TAbstractControl) test) {
    final _$actionInfo = _$_FormArrayActionController.startAction(
        name: '_FormArray.removeWhere');
    try {
      return super.removeWhere(test);
    } finally {
      _$_FormArrayActionController.endAction(_$actionInfo);
    }
  }

  @override
  Iterable<TAbstractControl> skip(int count) {
    final _$actionInfo =
        _$_FormArrayActionController.startAction(name: '_FormArray.skip');
    try {
      return super.skip(count);
    } finally {
      _$_FormArrayActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
controls: ${controls},
length: ${length}
    ''';
  }
}

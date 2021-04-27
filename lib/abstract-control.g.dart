// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'abstract-control.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AbstractControl on _AbstractControl, Store {
  Computed<bool>? _$disabledComputed;

  @override
  bool get disabled =>
      (_$disabledComputed ??= Computed<bool>(() => super.disabled,
              name: '_AbstractControl.disabled'))
          .value;
  Computed<bool>? _$activeComputed;

  @override
  bool get active => (_$activeComputed ??=
          Computed<bool>(() => super.active, name: '_AbstractControl.active'))
      .value;
  Computed<bool>? _$validComputed;

  @override
  bool get valid => (_$validComputed ??=
          Computed<bool>(() => super.valid, name: '_AbstractControl.valid'))
      .value;
  Computed<bool>? _$pristineComputed;

  @override
  bool get pristine =>
      (_$pristineComputed ??= Computed<bool>(() => super.pristine,
              name: '_AbstractControl.pristine'))
          .value;
  Computed<bool>? _$untouchedComputed;

  @override
  bool get untouched =>
      (_$untouchedComputed ??= Computed<bool>(() => super.untouched,
              name: '_AbstractControl.untouched'))
          .value;
  Computed<ObservableList<String>>? _$serverErrorsComputed;

  @override
  ObservableList<String> get serverErrors => (_$serverErrorsComputed ??=
          Computed<ObservableList<String>>(() => super.serverErrors,
              name: '_AbstractControl.serverErrors'))
      .value;
  Computed<List<ValidationEvent>>? _$errorsComputed;

  @override
  List<ValidationEvent> get errors =>
      (_$errorsComputed ??= Computed<List<ValidationEvent>>(() => super.errors,
              name: '_AbstractControl.errors'))
          .value;
  Computed<List<ValidationEvent>>? _$warningsComputed;

  @override
  List<ValidationEvent> get warnings => (_$warningsComputed ??=
          Computed<List<ValidationEvent>>(() => super.warnings,
              name: '_AbstractControl.warnings'))
      .value;
  Computed<List<ValidationEvent>>? _$informationMessagesComputed;

  @override
  List<ValidationEvent> get informationMessages =>
      (_$informationMessagesComputed ??= Computed<List<ValidationEvent>>(
              () => super.informationMessages,
              name: '_AbstractControl.informationMessages'))
          .value;
  Computed<List<ValidationEvent>>? _$successesComputed;

  @override
  List<ValidationEvent> get successes => (_$successesComputed ??=
          Computed<List<ValidationEvent>>(() => super.successes,
              name: '_AbstractControl.successes'))
      .value;
  Computed<ValidationEventTypes>? _$maxEventLevelComputed;

  @override
  ValidationEventTypes get maxEventLevel => (_$maxEventLevelComputed ??=
          Computed<ValidationEventTypes>(() => super.maxEventLevel,
              name: '_AbstractControl.maxEventLevel'))
      .value;

  final _$inProcessingAtom = Atom(name: '_AbstractControl.inProcessing');

  @override
  bool get inProcessing {
    _$inProcessingAtom.reportRead();
    return super.inProcessing;
  }

  @override
  set inProcessing(bool value) {
    _$inProcessingAtom.reportWrite(value, super.inProcessing, () {
      super.inProcessing = value;
    });
  }

  final _$_serverErrorsAtom = Atom(name: '_AbstractControl._serverErrors');

  @override
  ObservableList<String> get _serverErrors {
    _$_serverErrorsAtom.reportRead();
    return super._serverErrors;
  }

  @override
  set _serverErrors(ObservableList<String> value) {
    _$_serverErrorsAtom.reportWrite(value, super._serverErrors, () {
      super._serverErrors = value;
    });
  }

  final _$_errorsAtom = Atom(name: '_AbstractControl._errors');

  @override
  List<ValidationEvent> get _errors {
    _$_errorsAtom.reportRead();
    return super._errors;
  }

  @override
  set _errors(List<ValidationEvent> value) {
    _$_errorsAtom.reportWrite(value, super._errors, () {
      super._errors = value;
    });
  }

  final _$_warningsAtom = Atom(name: '_AbstractControl._warnings');

  @override
  List<ValidationEvent> get _warnings {
    _$_warningsAtom.reportRead();
    return super._warnings;
  }

  @override
  set _warnings(List<ValidationEvent> value) {
    _$_warningsAtom.reportWrite(value, super._warnings, () {
      super._warnings = value;
    });
  }

  final _$_informationMessagesAtom =
      Atom(name: '_AbstractControl._informationMessages');

  @override
  List<ValidationEvent> get _informationMessages {
    _$_informationMessagesAtom.reportRead();
    return super._informationMessages;
  }

  @override
  set _informationMessages(List<ValidationEvent> value) {
    _$_informationMessagesAtom.reportWrite(value, super._informationMessages,
        () {
      super._informationMessages = value;
    });
  }

  final _$_successesAtom = Atom(name: '_AbstractControl._successes');

  @override
  List<ValidationEvent> get _successes {
    _$_successesAtom.reportRead();
    return super._successes;
  }

  @override
  set _successes(List<ValidationEvent> value) {
    _$_successesAtom.reportWrite(value, super._successes, () {
      super._successes = value;
    });
  }

  final _$additionalDataAtom = Atom(name: '_AbstractControl.additionalData');

  @override
  dynamic get additionalData {
    _$additionalDataAtom.reportRead();
    return super.additionalData;
  }

  @override
  set additionalData(dynamic value) {
    _$additionalDataAtom.reportWrite(value, super.additionalData, () {
      super.additionalData = value;
    });
  }

  @override
  String toString() {
    return '''
inProcessing: ${inProcessing},
additionalData: ${additionalData},
disabled: ${disabled},
active: ${active},
valid: ${valid},
pristine: ${pristine},
untouched: ${untouched},
serverErrors: ${serverErrors},
errors: ${errors},
warnings: ${warnings},
informationMessages: ${informationMessages},
successes: ${successes},
maxEventLevel: ${maxEventLevel}
    ''';
  }
}

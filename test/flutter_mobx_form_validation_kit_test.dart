import 'package:flutter_mobx_form_validation_kit/form-array.dart';
import 'package:flutter_mobx_form_validation_kit/validation-event-types.dart';
import 'package:flutter_mobx_form_validation_kit/validation-event.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_mobx_form_validation_kit/abstract-control.dart';
import 'package:flutter_mobx_form_validation_kit/form-control.dart';
import 'package:flutter_mobx_form_validation_kit/form-abstract-group.dart';
import 'package:flutter_mobx_form_validation_kit/form-group.dart';
import 'package:flutter_mobx_form_validation_kit/validators.dart';

class FormFieldString extends ControlsCollection {
  final FormControl<String> field;
  FormFieldString({required this.field});

  @override
  Iterable<AbstractControl> allFields() => [this.field];
}

class FormDoubleFieldString extends ControlsCollection {
  FormControl<String> primaryField;
  FormControl<String> dependentField;
  FormDoubleFieldString(
      {required this.primaryField, required this.dependentField});

  @override
  Iterable<AbstractControl> allFields() =>
      [this.primaryField, this.dependentField];
}

class FormDoubleField extends ControlsCollection {
  FormControl<int> primaryField;
  FormControl<String> dependentField;
  FormDoubleField({required this.primaryField, required this.dependentField});

  @override
  Iterable<AbstractControl> allFields() =>
      [this.primaryField, this.dependentField];
}

void main() {
  test("should not call setter when initialized by default", () async {
    int countCallSetter = 0;
    final setter = (_) {
      countCallSetter++;
    };
    final form = FormGroup(FormFieldString(
        field: FormControl<String>(
            value: "test",
            options: OptionsFormControl(
              validators: [requiredValidator()],
              onChangeValidValue: setter,
              callSetterOnInitialize: false,
            ))));
    
    await form.wait();
    expect(countCallSetter, 0);
    form.dispose();
  });

  test("should call setter once when value is changed", () async {
    int countCallSetter = 0;
    String? valueSetter;
    final setter = (String value) {
      valueSetter = value;
      countCallSetter++;
    };

    final form = FormGroup(FormFieldString(
      field: FormControl<String>(
          value: "test",
          options: OptionsFormControl(
            validators: [requiredValidator()],
            onChangeValidValue: setter,
            callSetterOnInitialize: false,
          )),
    ));
    await form.wait();

    form.controls.field.value = "qwerty";
    await form.wait();

    expect(countCallSetter, 1);
    expect(valueSetter, "qwerty");
    expect(form.controls.field.value, "qwerty");
    form.dispose();
  });

  test("should reflect initial value getter changes", () async {
    final field = Observable("test");

    String? valueSetter;
    final setter = (String value) {
      valueSetter = value;
    };

    final form = FormGroup(FormFieldString(
        field: FormControl<String>(
            getterValue: () => field.value,
            options: OptionsFormControl(
                onChangeValidValue: setter, callSetterOnReinitialize: true))));
    await form.wait();

    expect(form.controls.field.value, "test");
    expect(valueSetter, "test");

    runInAction(() => field.value = "qwerty");
    await form.wait();

    expect(form.controls.field.value, "qwerty");
    expect(valueSetter, "qwerty");
    form.dispose();
  });

  test("should not call setter when reinitialized by default", () async {
    final field = Observable("test");
    int countCallSetter = 0;
    final setter = (String value) {
      countCallSetter++;
    };

    final form = FormGroup(FormFieldString(
        field: FormControl<String>(
            getterValue: () => field.value,
            options: OptionsFormControl(
                validators: [requiredValidator()],
                onChangeValidValue: setter,
                callSetterOnInitialize: false))));
    await form.wait();

    runInAction(() => field.value = 'qwerty');
    await form.wait();

    expect(countCallSetter, 0);

    form.dispose();
  });

  test("should not call setter when reinitialized by default", () async {
    int primaryCountCallSetter = 0;
    int dependentCountCallSetter = 0;
    final primarySetter = (_) => primaryCountCallSetter++;
    final dependentSetter = (_) => dependentCountCallSetter++;

    var form = Observable<FormGroup<FormDoubleFieldString>?>(null);

    runInAction(() => form.value = FormGroup(FormDoubleFieldString(
          primaryField: FormControl<String>(
              value: "foo",
              options: OptionsFormControl(
                validators: [requiredValidator()],
                onChangeValidValue: primarySetter,
                callSetterOnInitialize: false,
              )),
          dependentField: FormControl<String>(
              value: "bar",
              options: OptionsFormControl(
                validators: [requiredValidator()],
                onChangeValidValue: dependentSetter,
                activate: () =>
                    form.value?.controls.primaryField.value == "foo",
                callSetterOnInitialize: false,
              )),
        )));

    await form.value!.wait();

    expect(primaryCountCallSetter, 0);
    expect(dependentCountCallSetter, 0);

    form.value!.dispose();
  });

  test("should call setter once when activated after initialization", () async {
    int primaryCountCallSetter = 0;
    int? primaryValueSetter;
    final primarySetter = (int value) {
      primaryValueSetter = value;
      primaryCountCallSetter++;
    };
    int dependentCountCallSetter = 0;
    String? dependentValueSetter;
    final dependentSetter = (String value) {
      dependentValueSetter = value;
      dependentCountCallSetter++;
    };

    var form = Observable<FormGroup<FormDoubleField>?>(null);

    runInAction(() => form.value = FormGroup(FormDoubleField(
        primaryField: FormControl<int>(
            value: 123,
            options: OptionsFormControl<int>(
              validators: [requiredValidator()],
              onChangeValidValue: primarySetter,
              callSetterOnInitialize: false,
            )),
        dependentField: FormControl<String>(
            value: 'bar',
            options: OptionsFormControl<String>(
              validators: [requiredValidator()],
              onChangeValidValue: dependentSetter,
              activate: () => form.value?.controls.primaryField.value == 456,
              callSetterOnInitialize: false,
            )))));

    await form.value!.wait();

    expect(primaryCountCallSetter, 0);
    expect(form.value!.controls.primaryField.value, 123);

    expect(dependentCountCallSetter, 0);
    expect(form.value!.controls.dependentField.value, "bar");

    form.value!.controls.primaryField.value = 456;
    await form.value!.wait();

    expect(primaryCountCallSetter, 1);
    expect(primaryValueSetter, 456);
    expect(form.value!.controls.primaryField.value, 456);

    expect(dependentCountCallSetter, 1);
    expect(dependentValueSetter, "bar");
    expect(form.value!.controls.dependentField.value, "bar");

    form.value!.dispose();
  });

  test('test array', () async {
    final form = FormArray(
        ObservableList<FormControl<String>>.of([
          new FormControl<String>(value: ""),
          new FormControl<String>(value: "")
        ]),
        options: OptionsFormArray(validators: [
          (FormArray<FormControl<String>> array) async {
            if (array.every((i) => i.value == null || i.value.isEmpty)) {
              return [
                ValidationEvent(
                  type: ValidationEventTypes.Error,
                  message: '',
                )
              ];
            }
            return [];
          }
        ]));

    await form.wait();
    expect(form.valid, false);

    form[1].value = 'test';
    await form.wait();

    expect(form.valid, true);

    form.dispose();
  });

  test('wrapper on array', () async {
    final form = FormArray(
      ObservableList<FormControl<String>>.of(
          [FormControl<String>(value: ''), FormControl<String>(value: '')]),
      options: OptionsFormArray<FormControl<String>>(validators: [
        wrapperSequentialCheck([wrapperActivateValidation((_) => true, [])])
      ]),
    );

    await form.wait();

    expect(form.valid, true);

    form.dispose();
  });

//   it('minValue and maxValue', async () => {
//     const form = new FormGroup({
//       count: new FormControl<number>(0, [minValueValidator<number>(1, 'Должна быть оценка'), maxValueValidator<number>(5, 'Должна быть оценка')]),
//     });

//     await form.wait();
//     expect(form.valid).toBe(false);

//     form.controls.count.value = 3;

//     await form.wait();
//     expect(form.valid).toBe(true);
//   });

  test("activate validation", () async {
    final activateValidation = Observable(false);

    final form = FormGroup(FormFieldString(
        field: new FormControl<String>(
            value: '',
            options: OptionsFormControl(validators: [
              wrapperActivateValidation(
                  (_) => activateValidation.value, [requiredValidator()])
            ]))));

    await form.wait();
    expect(form.valid, true);

    runInAction(() => activateValidation.value = true);

    await form.wait();
    expect(form.valid, false);

    form.dispose();
  });

  test("wrapper sequential check", () async {
    final form = FormGroup(FormFieldString(
      field: FormControl<String>(
          value: "10.10.1010",
          options: OptionsFormControl(validators: [
            wrapperSequentialCheck([
              requiredValidator(message: "пустое значение"),
              patternValidator(RegExp(r"^\d\d.\d\d.\d\d\d\d$"),
                  message: "не дата")
            ]),
          ])),
    ));

    await form.wait();
    expect(form.valid, true);
    expect(form.controls.field.errors.length, 0);

    form.controls.field.value = '';
    await form.wait();
    expect(form.valid, false);
    expect(form.controls.field.errors.length, 1);
    expect(form.controls.field.errors[0].message, 'пустое значение');

    form.controls.field.value = '10101010';
    await form.wait();
    expect(form.valid, false);
    expect(form.controls.field.errors.length, 1);
    expect(form.controls.field.errors[0].message, "не дата");

    form.dispose();
  });
}

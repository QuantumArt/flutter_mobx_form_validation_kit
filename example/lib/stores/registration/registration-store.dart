import 'package:flutter_mobx_form_validation_kit/abstract-control.dart';
import 'package:flutter_mobx_form_validation_kit/form-abstract-group.dart';
import 'package:flutter_mobx_form_validation_kit/form-control.dart';
import 'package:flutter_mobx_form_validation_kit/form-group.dart';
import 'package:flutter_mobx_form_validation_kit/validation-event-types.dart';
import 'package:flutter_mobx_form_validation_kit/validation-event.dart';
import 'package:flutter_mobx_form_validation_kit/validators.dart';

class FormRange extends ControlsCollection {
  final FormControl<DateTime> min;
  final FormControl<DateTime> max;
  FormRange({required this.min, required this.max});
  @override
  Iterable<AbstractControl> allFields() => [this.min, this.max];
}

class RegistrationForm extends ControlsCollection {
  final FormControl<String> firstName;
  final FormControl<String> lastName;
  final FormControl<String> email;
  final FormControl<String> age;
  final FormGroup<FormRange> dateRange;
  RegistrationForm(
      {required this.firstName,
      required this.lastName,
      required this.email,
      required this.age,
      required this.dateRange});

  @override
  Iterable<AbstractControl> allFields() =>
      [this.firstName, this.lastName, this.email, this.age, this.dateRange];
}

class RegistrationStore {
  late FormGroup<RegistrationForm> form;

  RegistrationStore() {
    this.form = FormGroup(RegistrationForm(
      firstName: FormControl(
          value: "",
          options: OptionsFormControl(validators: [
            wrapperSequentialCheck([
              requiredValidator(),
              minLengthValidator(2),
              maxLengthValidator(5),
              notContainSpacesValidator()
            ])
          ])),
      lastName: FormControl(
          value: "",
          options: OptionsFormControl(validators: [requiredValidator()])),
      email: FormControl(
          value: "",
          options: OptionsFormControl(validators: [requiredValidator()])),
      age: FormControl(
          value: "",
          options: OptionsFormControl(validators: [requiredValidator()])),
      dateRange: FormGroup<FormRange>(
          FormRange(
              min: FormControl<DateTime>(value: DateTime.now()),
              max: FormControl<DateTime>(value: DateTime.now())),
          options: OptionsFormGroup<FormRange>(validators: [
            (FormGroup<FormRange> group) async {
              if (group.controls.max.value.isBefore(group.controls.min.value)) {
                return [
                  ValidationEvent(
                    message: 'Дата "от" больше даты "до"',
                    type: ValidationEventTypes.Error,
                  )
                ];
              }
              return [];
            },
          ])),
    ));
  }

  void dispose() {
    this.form.dispose();
  }

  Future send() async {
    await this.form.wait();
    if (this.form.invalid) {
      this.form.setTouched(true);
      final firstError = this.form.allControls().firstWhere((c) => c.invalid);
      firstError.focusNode?.requestFocus();
    }
  }
}

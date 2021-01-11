import 'package:flutter_mobx_form_validation_kit/abstract-control.dart';
import 'package:flutter_mobx_form_validation_kit/form-abstract-group.dart';
import 'package:flutter_mobx_form_validation_kit/form-control.dart';

class RegistrationForm extends ControlsCollection {
  final FormControl<String> name;
  RegistrationForm({this.name});

  @override
  Iterable<AbstractControl> allFields() => [this.name];
}

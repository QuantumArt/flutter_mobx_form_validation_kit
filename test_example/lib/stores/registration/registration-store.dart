import 'package:flutter_mobx_form_validation_kit/form-control.dart';
import 'package:flutter_mobx_form_validation_kit/form-group.dart';
import 'package:mfvkte/stores/registration/registration-form.dart';
import 'package:mobx/mobx.dart';

// Include generated file
part 'registration-store.g.dart';

class RegistrationStore = _RegistrationStore with _$RegistrationStore;

abstract class _RegistrationStore with Store {
  @observable
  int counter = 0;

  FormGroup<RegistrationForm> form;

  _RegistrationStore() {
    this.form =
        FormGroup(RegistrationForm(name: FormControl(value: "Виталий")));
  }

  void dispose() {
    this.form.dispose();
  }
}

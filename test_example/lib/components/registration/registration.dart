import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mfvkte/components/input/input-component.dart';
import 'package:mfvkte/stores/registration/registration-store.dart';

class Registration extends StatefulWidget {
  const Registration({Key key}) : super(key: key);

  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  RegistrationStore store = RegistrationStore();

  @override
  void dispose() {
    store.dispose();
    super.dispose();
  }

  @override
  Widget build(_) => Observer(builder: (BuildContext context) {
        return InkWell(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InputComponent(
                    title: "Имя",
                    control: store.form.controls.firstName,
                  ),
                  InputComponent(
                    title: "Фамилия",
                    control: store.form.controls.lastName,
                  ),
                  InputComponent(
                    title: "Email",
                    control: store.form.controls.email,
                  ),
                  InputComponent(
                    title: "Возраст",
                    control: store.form.controls.age,
                  ),
                  InkWell(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Text("Отправить"),
                    ),
                    onTap: this.store.send,
                  )
                ]));
      });
}

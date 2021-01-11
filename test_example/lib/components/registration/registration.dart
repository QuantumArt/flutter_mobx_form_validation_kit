import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
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
        return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(store.counter.toString(), style: TextStyle(fontSize: 20)),
              Text(store.form.controls.name.value,
                  style: TextStyle(fontSize: 20)),
              TextField(
                controller: store.form.controls.name.controller,
                onChanged: (String text) =>
                    store.form.controls.name.value = text,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Имя",
                ),
              ),
              SizedBox(height: 100, width: double.infinity),
              InkWell(
                onTap: () {
                  store.counter++;
                  store.form.controls.name.value = "Виталий";
                  // debugPrint(_controller.value.selection.toString());
                  // debugPrint(_controller.value.composing.toString());
                },
                child: Text("Тыкни", style: TextStyle(fontSize: 20)),
              )
            ]);
      });
}

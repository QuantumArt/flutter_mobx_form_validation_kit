import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_mobx_form_validation_kit/form-control.dart';

class InputComponent extends StatefulWidget {
  final String title;
  final FormControl<String> control;
  const InputComponent({Key? key, required this.title, required this.control})
      : super(key: key);

  @override
  _InputComponent createState() => _InputComponent();
}

class _InputComponent extends State<InputComponent> {
  @override
  Widget build(_) => Observer(builder: (BuildContext context) {
        return Padding(
            padding: EdgeInsets.all(10),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                      focusNode: widget.control.focusNode,
                      //controller: widget.control.controller,
                      onChanged: (String text) => widget.control.value = text,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: widget.title,
                      )),
                  if (widget.control.touched)
                    ...widget.control.errors.map((error) => Text(error.message,
                        style: TextStyle(color: Colors.red, fontSize: 15)))
                ]));
      });
}

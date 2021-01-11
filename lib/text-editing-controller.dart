import 'package:flutter/widgets.dart';

class FormControlTextEditingController extends TextEditingController {
  @override
  set text(String newText) {
    value = value.copyWith(
      text: newText,
      selection: newText.length < value.selection.extentOffset
          ? const TextSelection.collapsed(offset: 0)
          : value.selection,
      composing: TextRange.empty,
    );
  }
}

import 'package:flutter/cupertino.dart';

import 'validation-event-types.dart';

class ValidationEvent {
  String key;
  final String message;
  final ValidationEventTypes type;
  dynamic additionalData;
  ValidationEvent(
      {this.key,
      @required this.message,
      this.type = ValidationEventTypes.Error,
      this.additionalData});
}

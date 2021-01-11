import 'validation-event.dart';

List<ValidationEvent> combineErrors(List<List<ValidationEvent>> groupErrors) =>
    groupErrors.length > 0
        ? groupErrors
            .reduce((acumulator, value) => [...acumulator, ...value])
            .where((err) => err != null)
            .toList()
        : [];

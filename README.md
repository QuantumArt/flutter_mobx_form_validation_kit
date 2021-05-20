# flutter_mobx_form_validation_kit

[Документация на русском](#doc_rus)

### Benefits of the kit<a name="pluses_eng">
  - Compatible with Android, iOS, Web, Desktop, etc.
  - Compatible with Mobx.
  - Designed for asynchronous validation.
  - Easy to embed into an existing project.

Version for [TypeSript](https://www.npmjs.com/package/@quantumart/mobx-form-validation-kit)

- Compatible with Flutter:
flutter_mobx_form_validation_kit ^1.0.0 | 2.0.0 - Flutter 1
flutter_mobx_form_validation_kit ^2.1.0 - Flutter 2

- [Getting Started](#get_started_eng)
- [Control's State](#state_control_eng)
- [Validation](#validation_eng)
- [Final Check Before Submission](#submit_eng)
- [Conclusion](#final_eng)


### Getting Started<a name="get_started_eng">
The library can be used in various approaches to the code structure, but I will describe it in terms of the MVC (Model-View-Controller) pattern.
In other words, data display is implemented using "dumb" components, while the business logic (including validation) is embedded in Stores.
The components will be built with React hooks just because it is a more advanced way, but the library also works well with the class-based approach.

```
class RegistrationForm extends ControlsCollection {
  final FormControl<String> name;
  RegistrationForm({this.name});
  @override
  Iterable<AbstractControl> allFields() => [this.name];
}
class RegistrationStore {
  FormGroup<RegistrationForm> form;

  RegistrationStore() {
    this.form = FormGroup(RegistrationForm(
        name: FormControl(
            value: "",
            options: OptionsFormControl(validators: [requiredValidator()]))));
  }

  void dispose() {
    this.form.dispose();
  }
}
```
```
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
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(store.form.controls.name.value,
                  style: TextStyle(fontSize: 20)),
              TextField(
                controller: store.form.controls.name.controller,
                onChanged: (String text) =>
                    store.form.controls.name.value = text,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Name",
                ),
              ),
            ]);
      });
}
```

If you start typing, the error message will immediately disappear.
In its natural and familiar display format, a validation error message appears either after entering a character or after losing the field focus; mobx-form-validation-kit possesses all the necessary tools to achieve this.

| Name | Description |
| ------ | ------ |
| `pristine: boolean` | the value in FormControl has not been changed after the initialization with a default value. |
| `dirty: boolean` | the value in FormControl has been changed after the initialization with a default value. |
| `untouched: boolean` | for FormControl, this means that the field has not been in focus. For FormGroup and FormArray, this means that none of the nested FormControls has been in focus. The value "false" in this field means that the focus has not only been set to, but also removed from the field. |
| `touched: boolean` | For FormControl, this means that the field has been in focus. For FormGroup and FormArray, this means that one of the nested FormControls has been in focus. The value "true" in this field means that the focus has not only been set to, but also removed from the field. |
| `focused: boolean` | For FormControl, this means that the field is currently in focus. For FormGroup and FormArray, this means that one of the nested FormControls is currently in focus. |

```
TextField(
        focusNode: store.form.controls.name.focusNode,
        controller: store.form.controls.name.controller,
        onChanged: (String text) =>
            store.form.controls.name.value = text,
        decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: "Name",
        )),
    if (store.form.controls.name.touched)
    ...store.form.controls.name.errors.map((error) => Text(
        error.message,
        style: TextStyle(color: Colors.red, fontSize: 15)))

```
In this case, we display the error after the field has been "touched" (i.e., it has lost focus for the first time).

### Control's State<a name="state_control_eng">

Now, let's discuss the structure of controller nesting and the capabilities of such controllers.
The library of mobx-form-validation-kit has three main types of nodes.

| Name | Description |
| ------ | ------ |
| `FormGroup` | allows you to bring validation components together. It is a typed class, which allows you to redesign the interface with a list of fields as a generic parameter. |
| `FormControl` | is used to validate a specific field. It is the most commonly used class. It is a typed class, which accepts the type of the variable it must store as a generic parameter. |
| `FormArray` | allows you to create and manage an array of validation components. |

The nodes can be assembled in a tree-like structure. Any nesting level is supported, but everything usually starts in FormGroup.
```
FormGroup
-- FormControl
-- FormControl
-- -- FormGroup
-- -- FormArray
-- -- -- FormGroup
-- -- --  -- FormControl
-- -- FormArray
-- -- --  FormControl
```

When being defined, each object of the class acquires the following set of options:

| Name | Description |
| ------ | ------ |
| `validators: ValidatorsFunction[]` | set of validators. |
| `activate: (() => boolean)` | the function allows you to enable/disable validations by condition (by default, it is always enabled). For example, validity of the service's end date should not be verified if the "Unlimited" checkbox is unchecked. As a result, just by entering here a function to check the observable state of the field responsible for the "Unlimited" checkbox, you can automatically disable all the validations associated with the field to verify the date rather than specify this logic for each validation of the date field. |
| `additionalData: any` | is a block with additional information that allows you to add more information to a specific FormControl and use it later, e.g., for visualization purposes. This is convenient if there are builders for FormControl in which you want to hardcode certain information, and this allows you to avoid sending this information through a complex bundle of data to the controls for visualization purposes. Although we could not find an exact and indisputable application scenario for additionalData, it is better to have such option than to suffer without it. |

Aside from that, there is an additional set of options for FormControl

| Name | Description |
| ------ | ------ |
| `onChangeValue: UpdateValidValueHandler<TEntity>` | is always triggered when the value changes |
| `onChangeValidValue: UpdateValidValueHandler<TEntity>` | sends the last valid value  |
| `callSetterOnInitialize</b>: boolean` | allows you to call 'onChangeValidValue' when creating `FormControl` |
| `callSetterOnReinitialize: boolean` | allows you to call `onChangeValidValue` each time the result of the getter function from the first argument changes |

Each tree element supports the following set of fields:

| Name | Description |
| ------ | ------ |
| `processing: boolean` | during the analysis, mobx-form-validation-kit supports asynchronous validations, such as those that require a request to the server. You can find the current status of the check in this field.
In addition, there is support for the wait method, which allows you to wait until the check is completed. For example, you may want to write the following construct for the "submit data" button.
```
await this.form.wait();
if (this.form.invalid) {
...
```

| Name | Description |
| ------ | ------ |
| `disabled: boolean` | error checking is disabled (control is always valid) |
| `active: boolean` | error checking is enabled. This depends on the result of running the activation function. Such value is very convenient to use when you want to hide a group of fields on the form and avoid writing additional and duplicate business logic functions. |
| `invalid: boolean` | for FormControl, this means that the field contains validation errors. For FormGroup and FormArray, this means that either the group control contains errors or one of the nested fields (at any of the nesting levels) contains validation errors. In other words, to check the validity of the entire form, you can perform just one check of whether the upper FormGroup is valid or invalid. |
| `valid: boolean` | for FormControl, this means that the field does not contain validation errors. For FormGroup and FormArray, this means that either the group control does not contain errors or none of the nested fields (at any of the nesting levels) contains validation errors. |
| `pristine: boolean` | value in the field was not changed after the initialization with a default value. |
| `dirty: boolean` |  value in the field was changed after the initialization with a default value. |
| `untouched: boolean` |  For FormControl, this means that the field (for example, input) has not been in focus. For FormGroup and FormArray, this means that none of the nested FormControls has been in focus. The value "false" in this field means that the focus has not only been set to, but also removed from the field. |
| `touched: boolean` |  For FormControl, this means that the field (for example, input) has been in focus. For FormGroup and FormArray, this means that one of the nested FormControls has been in focus. The value "true" in this field means that the focus has not only been set to, but also removed from the field. |
| `focused: boolean` |  For FormControl, this means that the field (for example, input) is currently in focus. For FormGroup and FormArray, this means that one of the nested FormControls is currently in focus. |
| `errors: ValidationEvent[]` | this field contains validation errors. Unlike the listed fields, this array contains errors of either FormControl or FormGroup or FormArray, i.e., the errors of that control rather than all the nested ones. This affects valid / invalid field |
| `warnings: ValidationEvent[]` | field contains "Attention" messages. Unlike the listed fields, this array contains errors of either FormControl or FormGroup or FormArray i.e., the messages of that control rather than all the nested ones. This does not affect valid / invalid field |
| `informationMessages: ValidationEvent[]` |  field contains "information messages." Unlike the listed fields, this array contains errors of either FormControl or FormGroup or FormArray i.e., the messages of that control rather than all the nested ones. This does not affect valid / invalid field |
| `successes: ValidationEvent` |  field contains additional validity messages. Unlike the listed fields, this array contains errors of either FormControl or FormGroup or FormArray i.e., the messages of that control rather than all the nested ones. This does not affect valid / invalid field |
| `maxEventLevel()` | maximum level of validation messages currently contained in the field. |
This method will return one of enum values in the following priority.
        1.  ValidationEventTypes.Error;
        2.  ValidationEventTypes.Warning;
        3.  ValidationEventTypes.Info;
        4.  ValidationEventTypes.Success;

| Name | Description |
| ------ | ------ |
| `serverErrors: string[]` |  after sending the message to the server, it would be a good practice to check the validity of the form on the server as well. As a result, the server may return errors of the final validation of the form, and it is for this kind of errors that the serverErrors array is designed. The key feature of serverErrors is an automatic clearing of validation messages when the field to which the server errors were assigned is out of focus, and the server errors are also cleared if the field has been changed. |
| `setDirty(dirty: boolean)` |  method allows you to change the value of pristine / dirty fields |
| `setTouched(touched: boolean)` |  method allows you to change the value of untouched / touched fields |
| `setFocused()` |  method allows you to change the value of focused field (available only for FormControl) |
| `dispose()` | is required to call in componentWillUnmount of the control responsible for the page. |

Note:
In FormGroup and FormArray, the fields "valid" and "invalid" are focused on nested elements.
By checking the top element, you can find out the validity of all the lower-level elements in the form.
BUT! The FormGroup and FormArray nodes have `their own` set of validations and list of errors (errors, warnings, informationMessages, successes). In other words, if you ask FormGroup about the errors, it will return only its own errors, but not the errors in the nested FormControl.

### Validation<a name="validation_eng">

The library of mobx-form-validation-kit allows you to write custom validations, but it also includes its own set.
| Name | Description |
| ------ | ------ |
| `requiredValidator` | checks that the value is not null, and for strings it checks whether the string is empty |
| `notEmptyOrSpacesValidator` | checks that the value is not null, and for strings it checks whether the string is empty or that it doesn't consist of just spaces |
| `notContainSpacesValidator` | checks that the string does not contain spaces |
| `patternValidator` | returns an error if the pattern is not matched |
| `invertPatternValidator` | returns an error if the pattern is matched |
| `minLengthValidator` | checks the string for the minimum length  |
| `maxLengthValidator` | checks the string for the maximum length |
| `absoluteLengthValidator` | checks the string for a specific length |
| `isEqualValidator` | checks for the exact value |
| `compareValidator` |is a wrapper for complex validation (error if validation returned false) |

```
firstName: FormControl(
    value: "",
    options: OptionsFormControl(validators: [
    requiredValidator(),
    minLengthValidator(2),
    maxLengthValidator(5),
    notContainSpacesValidator()
])),

```

As you can see, all the validations in the list have been completed, this issue is addressed by using <b>wrapperSequentialCheck</b>. The way it is called and used is not different from a common validator function, but it accepts an array of validators that will be run sequentially, i.e., the next validation will start only after the previous one is completed without errors.
The second wrapper function is the function of validation flow control. As its first parameter, <b>wrapperActivateValidation</b> accepts a function in which you want to specify the conditions for activating validations. Unlike the activate function that is sent to FormControl, this check is designed for a more complex logic. Let's assume that we have a common builder for the entire FormGroup of payments, and moreover, the server has only one method server that accepts a common set of fields. But the problem is that even though the form is one, we have to display a different set of fields to the user depending on the "payment type." So, <b>wrapperActivateValidation</b> allows you to write a logic that will perform various checks depending on the payment type.

```
firstName: FormControl(
          value: "",
          options: OptionsFormControl(validators: [
            wrapperSequentialCheck([
              requiredValidator(),
              minLengthValidator(2),
              maxLengthValidator(5),
              notContainSpacesValidator()
            ])
          ]))

```

Custom validation of the group.

```
class FormRange extends ControlsCollection {
  final FormControl<DateTime> min;
  final FormControl<DateTime> max;
  FormRange({this.min, this.max});
  @override
  Iterable<AbstractControl> allFields() => [this.min, this.max];
}

class RegistrationForm extends ControlsCollection {
…
  RegistrationForm(
      {this.firstName, this.lastName, this.email, this.age, this.dateRange});

  @override
  Iterable<AbstractControl> allFields() =>
      [this.firstName, this.lastName, this.email, this.age, this.dateRange];
}

```

```
this.form = FormGroup(RegistrationForm(
...
      dateRange: FormGroup<FormRange>(
          FormRange(
              min: FormControl<DateTime>(value: DateTime.now()),
              max: FormControl<DateTime>(value: DateTime.now())),
          options: OptionsFormGroup<FormRange>(validators: [
            (FormGroup<FormRange> group) async {
              if (group.controls.max.value.isBefore(group.controls.min.value)) {
                return [
                  ValidationEvent(
                    message: 'Date in the "from" field is later than the date in the "to" field,'
                    type: ValidationEventTypes.Error,
                  )
                ];
              }
              return [];
            },
          ])),    
));

```

As you can see in the example, the validation is not assigned to something specific [although this is also possible], but to the entire group. All that remains is to display the errors of the group in the interface.

### Final Check before Submission <a name="submit_eng">

```
await this.form.wait();
    if (this.form.invalid) {
      this.form.setTouched(true);
      final firstError = this.form.allControls().firstWhere((c) => c.invalid);
      firstError.focusNode.requestFocus();
    }

```

### Conslusion <a name="final_eng">
It is clear that the library's capabilities are not limited to the described use cases. We can present more of them and provide other examples.
• Such as that the validations will work not only when the value changes, but also when an observable variable is changed within the validation.
• The way the "active" method works.
• The FormControl can be initialized not only by a specific variable but also by a function that returns a value. The changes within this function will also be tracked.
• How to use FormArray.
• How to make complex validation with requests to the server and still ensure that the variables in this validation will be tracked.

And much more, which allows you to use the mobx-form-validation-kit out of the box.

PS
If you find any error, please contact us and we will fix it :)








//-----------------------------------------------------------------------------------------------------------------------

### Документация<a name="doc_rus">

### Плюсы пакета<a name="pluses_rus">
  - Совместимость c Android, iOS, Web, Desktop и т.д.
  - Совместимость с Mobx
  - Рассчитан на асинхронные валидации
  - Легко встроить в существующий проект.

Версия для [TypeSript](https://www.npmjs.com/package/@quantumart/mobx-form-validation-kit)

- Совместимость с Flutter:
flutter_mobx_form_validation_kit ^1.0.0 | 2.0.0 - Flutter 1
flutter_mobx_form_validation_kit ^2.1.0 - Flutter 2

- [Getting Started](#get_started2)
- [Состояние контрола](#state_control_rus2)
- [Валидация](#validation_rus2)
- [Проверка перед отправкой](#submit_rus2)
- [Заключение](#final_rus2)


### Getting Started<a name="get_started2">
Библиотеку можно применять при разных подходах к структуре кода, но я буду рассматривать библиотеку в концепции MVC (Model-View-Controller).
Т.е. отображение происходит через «глупые» компоненты, а бизнес логика (в том числе и валидация) зашита в Stor-ах.
Компоненты будут строятся на react-хуках, просто по причине, что он более современный, но библиотека хорошо работает и в «классовом подходе».

```
class RegistrationForm extends ControlsCollection {
  final FormControl<String> name;
  RegistrationForm({this.name});
  @override
  Iterable<AbstractControl> allFields() => [this.name];
}
class RegistrationStore {
  FormGroup<RegistrationForm> form;

  RegistrationStore() {
    this.form = FormGroup(RegistrationForm(
        name: FormControl(
            value: "",
            options: OptionsFormControl(validators: [requiredValidator()]))));
  }

  void dispose() {
    this.form.dispose();
  }
}
```
```
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
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
            ]);
      });
}
```

Если начать что-то вводить, то ошибка тут же пропадет.
Но естественный и привычный нам формат отображения ошибки валидации подразумевает отображение этой самой ошибки или после ввода символа, либо после того как фокус у поля будет потерян. mobx-form-validation-kit имеется весь необходимый набор для этого.

| Имя | Описание |
| ------ | ------ |
| `pristine: boolean` | значение в FormControl, после инициализации дефолтным значением, не изменялось. |
| `dirty: boolean` | значение в FormControl, после инициализации дефолтным значением, менялось. |
| `untouched: boolean` | для FormControl – означает, что поле не было в фокусе. Для FormGroup и FormArray означает, что ни один из вложенных FormControl-ов не был в фокусе. Значение false в этом поле означает, что фокус был не только был поставлен, но и снят с поля. |
| `touched: boolean` | Для FormControl – означает, что поле было в фокусе. Для FormGroup и FormArray означает, что один из вложенных FormControl-ов был в фокусе. Значение true в этом поле означает, что фокус был не только был поставлен, но и снят с поля. |
| `focused: boolean` | для FormControl – означает, что поле сейчас в фокусе. Для FormGroup и FormArray означает, что один из вложенных FormControl-ов сейчас в фокусе. |

```
TextField(
        focusNode: store.form.controls.name.focusNode,
        controller: store.form.controls.name.controller,
        onChanged: (String text) =>
            store.form.controls.name.value = text,
        decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: "Имя",
        )),
    if (store.form.controls.name.touched)
    ...store.form.controls.name.errors.map((error) => Text(
        error.message,
        style: TextStyle(color: Colors.red, fontSize: 15)))

```
В данном случае мы отображаем ошибку после того как поле «потрогали» (т.е. оно потеряло фокус в первый раз).

### Состояние контрола<a name="state_control_rus2">

Разберем структуру вложенности контроллеров и их возможности.
Библиотека mobx-form-validation-kit имеет три основных типа узлов

| Имя | Описание |
| ------ | ------ |
| `FormGroup` | позволяет объединять валидационные компоненты вместе. Класс типизированный, и позволяет переделать в качестве generic параметра интерфейс со списком полей. |
| `FormControl` | используется для валидации конкретного поля, наиболее часто используемый класс. Класс типизированный, и в качестве generic параметра принимает тип переменной которой должен хранить. |
| `FormArray` | позволяет создавать и управлять массивом валидационных компонентов. |

Сами узлы можно складывать в древовидном стиле. Поддерживается любой уровень вложенности, но обычно все начинается в FormGroup.
```
FormGroup
-- FormControl
-- FormControl
-- -- FormGroup
-- -- FormArray
-- -- -- FormGroup
-- -- --  -- FormControl
-- -- FormArray
-- -- --  FormControl
```

Каждый объект класса поддерживает следующий набор опций при определении

| Имя | Описание |
| ------ | ------ |
| `validators: ValidatorsFunction[]` | набор валидаторов. |
| `activate: (() => boolean)` | функция позволят включать/отключать валидаций по условию (по умолчанию включено всегда). Например, валидность даты окончания услуги не нужно проверять, если не стоит галочка «Безлимитный». Как следствие, просто вписав сюда функцию которая проверив состояние observable поля отвечающего за чекбокс «Безлимитный», можно автоматически отключить все валидации привязанные к полю на проверку даты, а не прописывать эту логику в каждую из валидаций поля дата. |
| `additionalData: any` | блок с дополнительной информацией который позволяет добавить дополнительную информацию к конкретному FormControl и использовать их в дальнейшем, например, для визуализации. Это удобно, если есть билдеры для FormControl в которых нужно захаркодить определённую информацию, а не передавать эту информацию через сложную связку данных в контролы для визуализации. Хотя точного и неоспоримого сценария применения для additionalData мы так и не смогли найти, но лучше иметь такую возможность, чем страдать без нее. |

Кроме этого для FormControl есть дополнительный набор опций

| Имя | Описание |
| ------ | ------ |
| `onChangeValue: UpdateValidValueHandler<TEntity>` | срабатывает всегда при изменении значения |
| `onChangeValidValue: UpdateValidValueHandler<TEntity>` | передает последнее валидное значение  |
| `callSetterOnInitialize</b>: boolean` | позволяет вызвать 'onChangeValidValue' при создании `FormControl` |
| `callSetterOnReinitialize: boolean` | позволяет вызывать `onChangeValidValue` при каждом изменении результата функции-геттера из первого аргумента |

Каждый элемент дерева поддерживает следующий набор полей

| Имя | Описание |
| ------ | ------ |
| `processing: boolean` |	в процессе анализа. mobx-form-validation-kit поддерживает асинхронные валидации, например те, что требуют запроса на сервер. Текущее состояние проверки можно узнать по данному полю.
Кроме этого поддерживается метод wait, который позволяет дождаться окончания проверки. Например, при нажатии на кнопку «отправить данные» нужно прописать следующую конструкцию.
```
await this.form.wait();
if (this.form.invalid) {
...
```

| Имя | Описание |
| ------ | ------ |
| `disabled: boolean` |	проверка ошибок отключена (контрол всегда валиден) |
| `active: boolean` |	проверка ошибок включена. Зависит от результата выполнения функции активации. Данное значение очень удобно использовать для скрытия группы полей на форме и не писать дополнительные и дублирующие функции бизнес логики. |
| `invalid: boolean` | для FormControl – означает, что поле содержит валидационные ошибки. Для FormGroup и FormArray означает, либо сам групповой контрол содержит ошибки, либо одно из вложенных полей (на любом из уровней вложенности) содержит ошибки валидации. Т.е. для проверки валидности всей формы достаточно выполнить одну проверку invalid или valid верхнего FormGroup. |
| `valid: boolean` | для FormControl – означает, что поле не содержит валидационные ошибки. Для FormGroup и FormArray означает, либо сам групповой контрол не содержит ошибки, и ни одно из вложенных полей (на любом из уровней вложенности) не содержит ошибки валидации. |
| `pristine: boolean` | значение в поле, после инициализации дефолтным значением, не изменялось. |
| `dirty: boolean` |  значение в поле, после инициализации дефолтным значением, менялось. |
| `untouched: boolean` |	для FormControl – означает, что поле (например input) не было в фокусе. Для FormGroup и FormArray означает, что ни один из вложенных FormControl-ов не был в фокусе. Значение false в этом поле означает, что фокус был не только был поставлен, но и снят с поля. |
| `touched: boolean` |	Для FormControl – означает, что поле (например input) было в фокусе. Для FormGroup и FormArray означает, что один из вложенных FormControl-ов был в фокусе. Значение true в этом поле означает, что фокус был не только был поставлен, но и снят с поля. |
| `focused: boolean` |	для FormControl – означает, что поле (например input) сейчас в фокусе. Для FormGroup и FormArray означает, что один из вложенных FormControl-ов сейчас в фокусе. |
| `errors: ValidationEvent[]` |	поле содержит ошибки валидации. В отличии от перечисленных полей, данный массив содержит именно ошибки либо FormControl, либо FormGroup, либо FormArray, т.е. ошибки данного контрола, а не все вложенные. Влияет на поле valid / invalid |
| `warnings: ValidationEvent[]` |	поле содержит сообщения «Внимание». В отличии от перечисленных полей, данный массив содержит именно ошибки либо FormControl, либо FormGroup, либо FormArray, т.е. сообщения данного контрола, а не все вложенные. Не влияет на поле valid / invalid |
| `informationMessages: ValidationEvent[]` |	поле содержит сообщения «информационные сообщения». В отличии от перечисленных полей, данный массив содержит именно ошибки либо FormControl, либо FormGroup, либо FormArray, т.е. сообщения данного контрола, а не все вложенные. Не влияет на поле valid / invalid |
| `successes: ValidationEvent` |	поле содержит дополнительные сообщения о валидности. В отличии от перечисленных полей, данный массив содержит именно ошибки либо FormControl, либо FormGroup, либо FormArray, т.е. сообщения данного контрола, а не все вложенные. Не влияет на поле valid / invalid |
| `maxEventLevel()` |	максимальный уровень валидационных сообщении содержащих в поле в текущий момент. |
Метод вернет одно из значений enum, в следящем приоритете.
        1.	ValidationEventTypes.Error;
        2.	ValidationEventTypes.Warning;
        3.	ValidationEventTypes.Info;
        4.	ValidationEventTypes.Success;

| Имя | Описание |
| ------ | ------ |
| `serverErrors: string[]` |	после отправки сообщения на сервер, хорошим тоном является проверка валидности формы и на сервере. Как следствие сервер может вернуть ошибки финальной проверки формы, и именно для таких этих ошибок предназначается массив serverErrors. Ключевой особенностью serverErrors – является автоматическая очистка валидационных сообщений при потере фокуса с поля к которому были присвоены серверные ошибки, а также очистка серверных ошибок осуществляется если поле было изменено. |
| `setDirty(dirty: boolean)` |	метод позволяет изменить значение полей pristine / dirty |
| `setTouched(touched: boolean)` |	метод позволяет изменить значение полей untouched / touched |
| `setFocused()` |	метод позволяет изменить значение поля focused (доступно только для FormControl) |
| `dispose()` |	обязателен к вызову в componentWillUnmount контрола отвечающего за страницу. |

Примечание.
Поля valid и invalid в FormGroup и FormArray ориентируется на вложенные элементы.
И проверив самый верхний можно узнать валидность всех нижестоящих элементов формы.
НО! Узлы FormGroup и FormArray имеют `cвой` набор валидаций и список ошибок (errors, warnings, informationMessages, successes). Т.е. если спросить у FormGroup errors – она выдаст только свои ошибки, но не ошибки на вложенном FormControl.

### Валидация<a name="validation_rus2">

Библиотека mobx-form-validation-kit позволяет писать пользовательские валидации, но в ней присутствует и собственный набор.
| Имя | Описание |
| ------ | ------ |
| `requiredValidator` |	проверяет, что значение не равно null, а для строк проверяет строку на пустоту |
| `notEmptyOrSpacesValidator` | проверяет, что значение не равно null, а для строк проверяет строку на пустоту или что она не состоит из одних пробелов |
| `notContainSpacesValidator` | проверяет, что строка не содержит пробелов |
| `patternValidator` | выдает ошибку, если нет соответствия паттерну |
| `invertPatternValidator` | выдает ошибку, если есть соответствие паттерну |
| `minLengthValidator` | проверяет строку на длину минимальную  |
| `maxLengthValidator` | проверяет строку на максимальную длину |
| `absoluteLengthValidator` | проверяет строку на конкретную длину |
| `isEqualValidator` | проверяет на точное значение |
| `compareValidator` |обёртка для сложной проверки (ошибка, если проверка вернула false) |

```
firstName: FormControl(
    value: "",
    options: OptionsFormControl(validators: [
    requiredValidator(),
    minLengthValidator(2),
    maxLengthValidator(5),
    notContainSpacesValidator()
])),

```

Как можно заметить отработали все валидации в списке, для решения данной проблемы применяется обертка <b>wrapperSequentialCheck</b>. Её вызов и её применение ничем не отличается от обычной функции-валидатора, но на вход она принимает массив из валидаторов которые будут запускаться последовательно, т.е. следующая валидация запустится только после того, как предыдущая прошла без ошибок.
Второй функций оберткой является функция управления потоком валидаций. <b>wrapperActivateValidation</b> первым параметром принимает функцию в которой нужно прописать условия активаций валидаций. В отличии от функции activate которая передается в FormControl данная проверка рассчитана на более сложную логику. Предположим, что у нас общий билдер для целой формы FormGroup платежей, и более того на сервере есть только один метод который и принимает общий набор полей. Но вот загвоздка в том, что хоть форма и одна, в зависимости от «типа платежа» мы показываем различный набор полей пользователю. Так вот <b>wrapperActivateValidation</b> позволяет написать логику при которой будут осуществляться различные проверки в зависимости от типа платежа.

```
firstName: FormControl(
          value: "",
          options: OptionsFormControl(validators: [
            wrapperSequentialCheck([
              requiredValidator(),
              minLengthValidator(2),
              maxLengthValidator(5),
              notContainSpacesValidator()
            ])
          ]))

```

Пользовательсяка валидация группы.

```
class FormRange extends ControlsCollection {
  final FormControl<DateTime> min;
  final FormControl<DateTime> max;
  FormRange({this.min, this.max});
  @override
  Iterable<AbstractControl> allFields() => [this.min, this.max];
}

class RegistrationForm extends ControlsCollection {
…
  RegistrationForm(
      {this.firstName, this.lastName, this.email, this.age, this.dateRange});

  @override
  Iterable<AbstractControl> allFields() =>
      [this.firstName, this.lastName, this.email, this.age, this.dateRange];
}

```

```
this.form = FormGroup(RegistrationForm(
...
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

```

Как видно из примера валидация вешается не на конкретное [хотя так тоже можно], а вешается на всю группу целиком. Остается лишь вывести ошибки группы в интерфейсе.

### Проверка перед отправкой<a name="submit_rus2">

```
await this.form.wait();
    if (this.form.invalid) {
      this.form.setTouched(true);
      final firstError = this.form.allControls().firstWhere((c) => c.invalid);
      firstError.focusNode.requestFocus();
    }

```

### Заключение<a name="final_rus2">
Понятное дело, что описанным набор возможности библиотеки не ограничиваются. Еще можно рассказать и показать примеры.
•	Что валидаци отработают не только когда меняется само значение, но и когда поменялась observable переменная внутри валидации.
•	Как работает метод active
•	Что FormControl можно инициализовать не только конкретной переменной, но и функцией которая возвращает значение. И изменения внутри этой функции будут также отслеживаться.
•	Как работать с FormArray
•	Как делать сложную валидацию с запросами на сервер и при этом всё равно переменные в этой валидации будут отслеживаемыми.

И еще кучу всего, что позволяет из коробки пакет mobx-form-validation-kit.

П.с.
Найдете ошибки – пишите, исправим :)

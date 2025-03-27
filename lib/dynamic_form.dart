import 'package:dynamic_form/dynamic_form_field.dart';
import 'package:dynamic_form/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DynamicForm<T> extends StatefulWidget {
  final List<DynamicFormField> fields;
  final bool cancelButton;
  final Function(Map<String, dynamic> values)? onSubmit;
  final VoidCallback? onCancel;

  const DynamicForm({super.key, required this.fields, this.cancelButton = true, this.onSubmit, this.onCancel});

  @override
  State<DynamicForm> createState() => _DynamicFormState();
}

class _DynamicFormState<T> extends State<DynamicForm> {
  final _formKey = GlobalKey<FormState>();
  List<TextEditingController> _controllers = [];

  @override
  void initState() {
    super.initState();
    _setInitial();
  }

  void _setInitial() {
    _controllers =
        widget.fields.map((e) {
          return TextEditingController(text: e.initialValue);
        }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Form(
          key: _formKey,
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              ...widget.fields.map((e) {
                final index = widget.fields.indexOf(e);
                return SizedBox(
                  width:
                      e.size == FormFieldSize.half
                          ? constraints.maxWidth / 2 - 16
                          : e.size == FormFieldSize.third
                          ? constraints.maxWidth / 3 - 16
                          : constraints.maxWidth - 16,
                  child: fieldByType(index, e),
                );
              }),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.primary),
                    onPressed: () => _submit(),
                    icon: const Icon(Icons.save),
                    label: const Text('Guardar'),
                  ),
                  const SizedBox(width: 16),
                  Visibility(
                    visible: widget.cancelButton,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.tertiary),
                      onPressed: () {
                        _formKey.currentState!.reset();
                        _setInitial();
                        widget.onCancel!();
                      },
                      icon: const Icon(Icons.cancel),
                      label: const Text('Cancelar'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget fieldByType(int index, DynamicFormField field) {
    switch (field.type) {
      case DynamicFormFieldType.text:
        return _TextField(
          controller: _controllers[index],
          label: field.label,
          isRequired: field.isRequired,
          validator: field.validator,
        );
      case DynamicFormFieldType.phone:
        return _PhoneField(
          controller: _controllers[index],
          label: field.label,
          isRequired: field.isRequired,
          validator: field.validator,
        );
      case DynamicFormFieldType.password:
        return _PasswordField(
          controller: _controllers[index],
          label: field.label,
          isRequired: field.isRequired,
          validator: field.validator,
        );
      case DynamicFormFieldType.email:
        return _EmailField(
          controller: _controllers[index],
          label: field.label,
          isRequired: field.isRequired,
          validator: field.validator,
        );
      case DynamicFormFieldType.date:
        return _DateField(
          controller: _controllers[index],
          label: field.label,
          isRequired: field.isRequired,
          validator: field.validator,
        );
      case DynamicFormFieldType.dropdown:
        return _DropdownField(
          controller: _controllers[index],
          label: field.label,
          items: field.items as List<String>,
          isRequired: field.isRequired,
          validator: field.validator,
          onChanged: (value) {
            field.onChanged!(value);
          },
        );
      case DynamicFormFieldType.radio:
        return _RadioField(
          controller: _controllers[index],
          label: field.label,
          items: field.items as List<String>,
          isRequired: field.isRequired,
          validator: field.validator,
        );
      case DynamicFormFieldType.textarea:
        return _TextAreaField(
          controller: _controllers[index],
          label: field.label,
          isRequired: field.isRequired,
          validator: field.validator,
        );
      case DynamicFormFieldType.creditCard:
        return _CreditCardField(
          controller: _controllers[index],
          label: field.label,
          isRequired: field.isRequired,
          validator: field.validator,
        );
      case DynamicFormFieldType.time:
        return _TimeField(
          controller: _controllers[index],
          label: field.label,
          isRequired: field.isRequired,
          validator: field.validator,
        );
      case DynamicFormFieldType.number:
        return _NumberField(
          controller: _controllers[index],
          label: field.label,
          isRequired: field.isRequired,
          validator: field.validator,
        );
      case DynamicFormFieldType.currency:
        return _CurrencyField(
          controller: _controllers[index],
          label: field.label,
          isRequired: field.isRequired,
          validator: field.validator,
        );
      case DynamicFormFieldType.custom:
        return field.childBuilder!(_controllers[index].text);
      default:
        return Container();
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> values = {};
      for (int i = 0; i < widget.fields.length; i++) {
        if (widget.fields[i].type == DynamicFormFieldType.currency) {
          values[widget.fields[i].name] = _controllers[i].text.replaceAll('\$', '').replaceAll(',', '');
          continue;
        }

        values[widget.fields[i].name] = _controllers[i].text;
      }
      widget.onSubmit!(values);
    }
  }
}

class _TextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final FormFieldValidator? validator;
  final bool isRequired;

  const _TextField({required this.controller, required this.label, this.validator, this.isRequired = false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(hintText: label, labelText: label),
      validator:
          isRequired
              ? validator ??
                  (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, ingrese un texto';
                    }
                    return null;
                  }
              : null,
    );
  }
}

class _NumberField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final FormFieldValidator? validator;
  final bool isRequired;

  const _NumberField({required this.controller, required this.label, this.validator, this.isRequired = false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(hintText: label, labelText: label),
      validator:
          isRequired
              ? validator ??
                  (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, ingrese un número';
                    }

                    return null;
                  }
              : null,
      keyboardType: TextInputType.number,
    );
  }
}

class _CurrencyField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final FormFieldValidator? validator;
  final bool isRequired;

  const _CurrencyField({required this.controller, required this.label, this.validator, this.isRequired = false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
      decoration: InputDecoration(hintText: label, labelText: label, prefix: Text('\$')),
      validator:
          isRequired
              ? validator ??
                  (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, ingrese un número';
                    }

                    if (value.isNumericOnly) {
                      return 'Por favor, ingrese un número válido';
                    }

                    return null;
                  }
              : null,
      keyboardType: TextInputType.number,
    );
  }
}

class _PhoneField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final FormFieldValidator? validator;
  final bool isRequired;

  const _PhoneField({required this.controller, required this.label, this.validator, this.isRequired = false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(hintText: label, labelText: label),
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator:
          isRequired
              ? validator ??
                  (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, ingrese un número de teléfono';
                    }

                    if (value.isPhoneNumber) {
                      return 'Por favor, ingrese un número de teléfono válido';
                    }

                    return null;
                  }
              : null,
      keyboardType: TextInputType.phone,
    );
  }
}

class _PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final FormFieldValidator? validator;
  final bool isRequired;

  const _PasswordField({required this.controller, required this.label, this.validator, this.isRequired = false});

  @override
  State<_PasswordField> createState() => __PasswordFieldState();
}

class __PasswordFieldState extends State<_PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
        hintText: widget.label,
        suffixIcon: IconButton(
          icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
      ),
      validator:
          widget.isRequired
              ? widget.validator ??
                  (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, ingrese una contraseña';
                    }
                    return null;
                  }
              : null,
      obscureText: _obscureText,
    );
  }
}

class _EmailField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final FormFieldValidator? validator;
  final bool isRequired;

  const _EmailField({required this.controller, required this.label, this.validator, this.isRequired = false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(hintText: label, labelText: label),
      validator:
          isRequired
              ? validator ??
                  (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, ingrese un correo';
                    }
                    return null;
                  }
              : null,
      keyboardType: TextInputType.emailAddress,
    );
  }
}

class _DateField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final FormFieldValidator? validator;
  final bool isRequired;

  const _DateField({required this.controller, required this.label, this.validator, this.isRequired = false});

  @override
  State<_DateField> createState() => _DateFieldState();
}

class _DateFieldState extends State<_DateField> {
  DateTime? _date;

  @override
  void initState() {
    super.initState();
    if (widget.controller.text.isNotEmpty) {
      _date = DateTime.parse(widget.controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.calendar_today),
          onPressed: () async {
            final DateTime? date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(Duration(days: 365)),
            );
            if (date != null) {
              widget.controller.text = date.toString();
              setState(() {
                _date = date;
              });
            }
          },
        ),
        SizedBox(width: 12),
        Expanded(
          child: InputDatePickerFormField(
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(Duration(days: 365)),
            onDateSubmitted: (DateTime value) {
              widget.controller.text = value.toString();
            },
            initialDate: _date ?? DateTime.now(),
            fieldHintText: widget.label,
            fieldLabelText: widget.label,
          ),
        ),
      ],
    );
  }
}

class _TimeField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final FormFieldValidator? validator;
  final bool isRequired;

  const _TimeField({required this.controller, required this.label, this.validator, this.isRequired = false});

  @override
  State<_TimeField> createState() => _TimeFieldState();
}

class _TimeFieldState extends State<_TimeField> {
  TimeOfDay? time0;

  @override
  void initState() {
    super.initState();
    if (widget.controller.text.isNotEmpty) {
      time0 = TimeOfDay.fromDateTime(DateTime.parse(widget.controller.text));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.access_time),
          onPressed: () async {
            final TimeOfDay? time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
            if (time != null) {
              widget.controller.text = time.toString();
              setState(() {
                time0 = time;
              });
            }
          },
        ),
        SizedBox(width: 12),
        // Expanded(
        //   child: InputDatePickerFormField(
        //     onDateSubmitted: (DateTime value) {
        //       widget.controller.text = value.toString();
        //     },
        //     initialDate: time0 ?? TimeOfDay.now(),
        //     fieldHintText: widget.label,
        //     fieldhintText: widget.label,
        //     firstDate: null,
        //     lastDate: null,
        //   ),
        // ),
      ],
    );
  }
}

class _DropdownField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final List<String> items;
  final FormFieldValidator? validator;
  final bool isRequired;
  final Function(String)? onChanged;

  const _DropdownField({
    required this.controller,
    required this.label,
    required this.items,
    this.validator,
    this.isRequired = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String?>(
      value: controller.text == '' ? null : controller.text,
      onChanged: (String? value) {
        controller.text = value!;
        onChanged!(value);
      },
      validator:
          isRequired
              ? validator ??
                  (value) {
                    if (isRequired && value == null) {
                      return 'Por favor, seleccione una opción';
                    }
                    return null;
                  }
              : null,
      items:
          items.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
            );
          }).toList(),
      decoration: InputDecoration(hintText: label, labelText: label, hintStyle: Theme.of(context).textTheme.bodyMedium),
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
}

class _RadioField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final List<String> items;
  final FormFieldValidator? validator;
  final bool isRequired;

  const _RadioField({
    required this.controller,
    required this.label,
    required this.items,
    this.validator,
    this.isRequired = false,
  });

  @override
  State<_RadioField> createState() => _RadioFieldState();
}

class _RadioFieldState extends State<_RadioField> {
  String _value = '';

  @override
  void initState() {
    super.initState();
    _value = widget.controller.text;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.grey),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.label),
          SizedBox(width: 8),
          Wrap(
            runAlignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.start,
            alignment: WrapAlignment.start,
            spacing: 8,
            runSpacing: 8,
            children:
                widget.items.map((String item) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _value = item;
                        widget.controller.text = item;
                      });
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Radio(
                          value: item,
                          groupValue: _value,
                          onChanged: (String? value) {
                            setState(() {
                              _value = value!;
                              widget.controller.text = value;
                            });
                          },
                        ),
                        Text(item),
                      ],
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }
}

class _TextAreaField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final FormFieldValidator? validator;
  final bool isRequired;

  const _TextAreaField({required this.controller, required this.label, this.validator, this.isRequired = false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(hintText: label, labelText: label),
      maxLines: 5,
    );
  }
}

class _CreditCardField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final FormFieldValidator? validator;
  final bool isRequired;

  const _CreditCardField({required this.controller, required this.label, this.validator, this.isRequired = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.credit_card),
            SizedBox(width: 12),
            Expanded(
              flex: 3,
              child: TextFormField(
                controller: controller,
                decoration: InputDecoration(hintText: '0000 0000 0000 0000'),
                validator:
                    isRequired
                        ? validator ??
                            (value) {
                              if (value!.isEmpty) {
                                return 'Por favor, ingrese un número de tarjeta';
                              }

                              if (value.isCreditCard) {
                                return 'Por favor, ingrese un número de tarjeta válido';
                              }

                              return null;
                            }
                        : null,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ),
            SizedBox(width: 12),
            Icon(Icons.lock),
            SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                decoration: InputDecoration(hintText: 'CVV'),
                validator:
                    isRequired
                        ? validator ??
                            (value) {
                              if (value!.isEmpty) {
                                return 'Por favor, ingrese un CVV';
                              }

                              if (value.isCVV) {
                                return 'Por favor, ingrese un CVV válido';
                              }

                              return null;
                            }
                        : null,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

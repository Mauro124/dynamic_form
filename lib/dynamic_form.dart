import 'package:dynamic_form/dynamic_form_field.dart';
import 'package:dynamic_form/inputs/dynamic_credit_card_field.dart';
import 'package:dynamic_form/inputs/dynamic_currency_field.dart';
import 'package:dynamic_form/inputs/dynamic_date_field.dart';
import 'package:dynamic_form/inputs/dynamic_dropdown_field.dart';
import 'package:dynamic_form/inputs/dynamic_email_field.dart';
import 'package:dynamic_form/inputs/dynamic_number_field.dart';
import 'package:dynamic_form/inputs/dynamic_password_field.dart';
import 'package:dynamic_form/inputs/dynamic_phone_field.dart';
import 'package:dynamic_form/inputs/dynamic_radio_field.dart';
import 'package:dynamic_form/inputs/dynamic_text_area_field.dart';
import 'package:dynamic_form/inputs/dynamic_text_field.dart';
import 'package:dynamic_form/inputs/dynamic_time_field.dart';
import 'package:flutter/material.dart';

class DynamicForm<T> extends StatefulWidget {
  final List<DynamicFormField> fields;
  final bool cancelButton;
  final Function(Map<String, dynamic> values)? onSubmit;
  final VoidCallback? onCancel;
  final bool isLoading;

  const DynamicForm({
    super.key,
    required this.fields,
    this.cancelButton = true,
    this.onSubmit,
    this.onCancel,
    this.isLoading = false,
  });

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
          if (e.initialValue is bool || e.initialValue is int || e.initialValue is double || e.initialValue is num) {
            return TextEditingController(text: e.initialValue.toString());
          }

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
                    onPressed: widget.isLoading ? null : () => _submit(),
                    icon: widget.isLoading ? null : const Icon(Icons.save),
                    label: widget.isLoading ? CircularProgressIndicator() : Text('Guardar'),
                  ),
                  const SizedBox(width: 16),
                  Visibility(
                    visible: widget.cancelButton,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.tertiary),
                      onPressed:
                          widget.isLoading || widget.onCancel == null
                              ? null
                              : () {
                                widget.onCancel!.call();
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
    if (field.isHidden) {
      return const SizedBox();
    }

    switch (field.type) {
      case DynamicFormFieldType.text:
        return DynamicTextField(
          controller: _controllers[index],
          label: field.label,
          isRequired: field.isRequired,
          validator: field.validator,
          isEnabled: field.isEnabled,
        );
      case DynamicFormFieldType.phone:
        return DynamicPhoneField(
          controller: _controllers[index],
          label: field.label,
          isRequired: field.isRequired,
          validator: field.validator,
          isEnabled: field.isEnabled,
        );
      case DynamicFormFieldType.password:
        return DynamicPasswordField(
          controller: _controllers[index],
          label: field.label,
          isRequired: field.isRequired,
          validator: field.validator,
          isEnabled: field.isEnabled,
        );
      case DynamicFormFieldType.email:
        return DynamicEmailField(
          controller: _controllers[index],
          label: field.label,
          isRequired: field.isRequired,
          validator: field.validator,
          isEnabled: field.isEnabled,
        );
      case DynamicFormFieldType.date:
        return DynamicDateField(
          controller: _controllers[index],
          label: field.label,
          isRequired: field.isRequired,
          validator: field.validator,
          minDate: field.minDate,
          maxDate: field.maxDate,
          isEnabled: field.isEnabled,
        );
      case DynamicFormFieldType.dropdown:
        return DynamicDropdownField(
          controller: _controllers[index],
          label: field.label,
          items: field.items as List<String>,
          isRequired: field.isRequired,
          validator: field.validator,
          isEnabled: field.isEnabled,
          onChanged: (value) {
            field.onChanged!(value);
          },
        );
      case DynamicFormFieldType.radio:
        return DynamicRadioField(
          controller: _controllers[index],
          label: field.label,
          items: field.items as List<String>,
          isRequired: field.isRequired,
          validator: field.validator,
        );
      case DynamicFormFieldType.textarea:
        return DynamicTextAreaField(
          controller: _controllers[index],
          label: field.label,
          isRequired: field.isRequired,
          validator: field.validator,
        );
      case DynamicFormFieldType.creditCard:
        return DynamicCreditCardField(
          controller: _controllers[index],
          label: field.label,
          isRequired: field.isRequired,
          validator: field.validator,
        );
      case DynamicFormFieldType.time:
        return DynamicTimeField(
          controller: _controllers[index],
          label: field.label,
          isRequired: field.isRequired,
          validator: field.validator,
        );
      case DynamicFormFieldType.number:
        return DynamicNumberField(
          controller: _controllers[index],
          label: field.label,
          isRequired: field.isRequired,
          validator: field.validator,
          isEnabled: field.isEnabled,
        );
      case DynamicFormFieldType.currency:
        return DynamicCurrencyField(
          controller: _controllers[index],
          label: field.label,
          isRequired: field.isRequired,
          validator: field.validator,
          isEnabled: field.isEnabled,
        );
      case DynamicFormFieldType.checkbox:
        return SizedBox(
          height: field.style?.height ?? 40,
          child: CheckboxListTile(
            title: Text(field.label),
            value: field.initialValue ?? false,
            enableFeedback: true,
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(field.style?.borderRadius ?? 0),
              side: BorderSide(color: field.style?.border?.color ?? Colors.transparent),
            ),
            dense: false,
            visualDensity: VisualDensity.compact,
            onChanged:
                field.isEnabled
                    ? (value) {
                      setState(() {
                        field.onChanged!(value);
                      });
                    }
                    : null,
          ),
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

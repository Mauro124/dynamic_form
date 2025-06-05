import 'package:dynamic_form/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DynamicCurrencyField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final FormFieldValidator? validator;
  final bool isRequired;
  final bool? isEnabled;

  const DynamicCurrencyField({
    super.key,
    required this.controller,
    required this.label,
    this.validator,
    this.isRequired = false,
    this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: isEnabled,
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

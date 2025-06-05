import 'package:dynamic_form/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DynamicPhoneField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final FormFieldValidator? validator;
  final bool isRequired;
  final bool isEnabled;

  const DynamicPhoneField({
    super.key,
    required this.controller,
    required this.label,
    this.validator,
    this.isRequired = false,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: isEnabled,
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

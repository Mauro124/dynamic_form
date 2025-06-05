import 'package:flutter/material.dart';

class DynamicEmailField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final FormFieldValidator? validator;
  final bool isRequired;
  final bool isEnabled;

  const DynamicEmailField({
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

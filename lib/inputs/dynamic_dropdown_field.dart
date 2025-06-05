import 'package:flutter/material.dart';

class DynamicDropdownField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final List<String> items;
  final FormFieldValidator? validator;
  final bool isRequired;
  final Function(String)? onChanged;
  final bool isEnabled;

  const DynamicDropdownField({
    super.key,
    required this.controller,
    required this.label,
    required this.items,
    this.validator,
    this.isRequired = false,
    this.onChanged,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String?>(
      value: controller.text == '' ? null : controller.text,
      onChanged:
          isEnabled
              ? (String? value) {
                controller.text = value!;
                onChanged!(value);
              }
              : null,
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
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
      decoration: InputDecoration(hintText: label, labelText: label),
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
}

import 'package:flutter/material.dart';

class DynamicTextAreaField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final FormFieldValidator? validator;
  final bool isRequired;

  const DynamicTextAreaField({
    super.key,
    required this.controller,
    required this.label,
    this.validator,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(hintText: label, labelText: label),
        maxLines: 5,
      ),
    );
  }
}

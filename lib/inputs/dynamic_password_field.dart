import 'package:flutter/material.dart';

class DynamicPasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final FormFieldValidator? validator;
  final bool isRequired;
  final bool? isEnabled;

  const DynamicPasswordField({
    required this.controller,
    required this.label,
    this.validator,
    this.isRequired = false,
    this.isEnabled,
  });

  @override
  State<DynamicPasswordField> createState() => _DynamicPasswordFieldState();
}

class _DynamicPasswordFieldState extends State<DynamicPasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: widget.isEnabled,
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

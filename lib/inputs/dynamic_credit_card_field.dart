import 'package:dynamic_form/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DynamicCreditCardField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final FormFieldValidator? validator;
  final bool isRequired;

  const DynamicCreditCardField({
    super.key,
    required this.controller,
    required this.label,
    this.validator,
    this.isRequired = false,
  });

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

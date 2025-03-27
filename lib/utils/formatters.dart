import 'package:flutter/services.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    final int selectionIndex = newValue.selection.end;
    final String digitsOnly = newValue.text.replaceAll(RegExp(r'[^\d.]'), '');
    final String formatted = _formatCurrency(digitsOnly);

    return TextEditingValue(text: formatted, selection: TextSelection.collapsed(offset: selectionIndex));
  }

  String _formatCurrency(String digits) {
    final buffer = StringBuffer();
    int decimalIndex = digits.length - 2;

    for (int i = 0; i < digits.length; i++) {
      if (i == decimalIndex) {
        buffer.write(',');
      } else if ((digits.length - i - 3) % 3 == 0 && i != 0 && i < decimalIndex) {
        buffer.write('.');
      }
      buffer.write(digits[i]);
    }

    return buffer.toString();
  }
}

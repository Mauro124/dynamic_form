import 'package:flutter/material.dart';

class DynamicDateField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final bool isRequired;
  final FormFieldValidator? validator;
  final DateTime? minDate;
  final DateTime? maxDate;
  final bool isEnabled;

  const DynamicDateField({
    super.key,
    required this.controller,
    required this.label,
    this.isEnabled = true,
    this.validator,
    this.isRequired = false,
    this.minDate,
    this.maxDate,
  });

  @override
  State<DynamicDateField> createState() => _DynamicDateFieldState();
}

class _DynamicDateFieldState extends State<DynamicDateField> {
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
          color: Theme.of(context).colorScheme.primary,
          iconSize: 18,
          icon: Icon(Icons.calendar_today),
          onPressed:
              widget.isEnabled
                  ? () async {
                    final DateTime? date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: widget.minDate ?? DateTime.now(),
                      lastDate: widget.maxDate ?? DateTime.now().add(Duration(days: 365 * 5)),
                      confirmText: 'Seleccionar',
                      cancelText: 'Cancelar',
                    );
                    if (date != null) {
                      widget.controller.text = date.toString();
                      setState(() {
                        _date = date;
                      });
                    }
                  }
                  : null,
        ),
        SizedBox(width: 12),
        Expanded(
          child: InkWell(
            mouseCursor: widget.isEnabled ? SystemMouseCursors.click : SystemMouseCursors.forbidden,
            borderRadius: BorderRadius.circular(8),
            onTap:
                widget.isEnabled
                    ? () async {
                      final DateTime? date = await showDatePicker(
                        context: context,
                        initialDate: _date ?? DateTime.now(),
                        firstDate: widget.minDate ?? DateTime.now(),
                        lastDate: widget.maxDate ?? DateTime.now().add(Duration(days: 365 * 5)),
                        confirmText: 'Seleccionar',
                        cancelText: 'Cancelar',
                      );
                      if (date != null) {
                        widget.controller.text = date.toString();
                        setState(() {
                          _date = date;
                        });
                      }
                    }
                    : null,
            child: AbsorbPointer(
              absorbing: true,
              child: InputDatePickerFormField(
                initialDate: _date ?? DateTime.now(),
                firstDate: widget.minDate ?? DateTime.now(),
                lastDate: widget.maxDate ?? DateTime.now().add(Duration(days: 365 * 5)),
                autofocus: false,
                onDateSubmitted:
                    widget.isEnabled
                        ? (DateTime value) {
                          widget.controller.text = value.toString();
                        }
                        : null,
                fieldHintText: widget.label,
                fieldLabelText: widget.label,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

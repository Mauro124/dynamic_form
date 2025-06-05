import 'package:flutter/material.dart';

class DynamicRadioField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final List<String> items;
  final FormFieldValidator? validator;
  final bool isRequired;

  const DynamicRadioField({
    super.key,
    required this.controller,
    required this.label,
    required this.items,
    this.validator,
    this.isRequired = false,
  });

  @override
  State<DynamicRadioField> createState() => _DynamicRadioFieldState();
}

class _DynamicRadioFieldState extends State<DynamicRadioField> {
  String _value = '';

  @override
  void initState() {
    super.initState();
    _value = widget.controller.text;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.grey),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.label),
          SizedBox(width: 8),
          Wrap(
            runAlignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.start,
            alignment: WrapAlignment.start,
            spacing: 8,
            runSpacing: 8,
            children:
                widget.items.map((String item) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _value = item;
                        widget.controller.text = item;
                      });
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Radio(
                          value: item,
                          groupValue: _value,
                          onChanged: (String? value) {
                            setState(() {
                              _value = value!;
                              widget.controller.text = value;
                            });
                          },
                        ),
                        Text(item),
                      ],
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }
}

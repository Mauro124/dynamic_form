import 'package:flutter/material.dart';

class DynamicTimeField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final FormFieldValidator? validator;
  final bool isRequired;

  const DynamicTimeField({
    super.key,
    required this.controller,
    required this.label,
    this.validator,
    this.isRequired = false,
  });

  @override
  State<DynamicTimeField> createState() => _DynamicTimeFieldState();
}

class _DynamicTimeFieldState extends State<DynamicTimeField> {
  TimeOfDay? time0;

  @override
  void initState() {
    super.initState();
    if (widget.controller.text.isNotEmpty) {
      time0 = TimeOfDay.fromDateTime(DateTime.parse(widget.controller.text));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.access_time),
          onPressed: () async {
            final TimeOfDay? time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
            if (time != null) {
              widget.controller.text = time.toString();
              setState(() {
                time0 = time;
              });
            }
          },
        ),
        SizedBox(width: 12),
        // Expanded(
        //   child: InputDatePickerFormField(
        //     onDateSubmitted: (DateTime value) {
        //       widget.controller.text = value.toString();
        //     },
        //     initialDate: time0 ?? TimeOfDay.now(),
        //     fieldHintText: widget.label,
        //     fieldhintText: widget.label,
        //     firstDate: null,
        //     lastDate: null,
        //   ),
        // ),
      ],
    );
  }
}

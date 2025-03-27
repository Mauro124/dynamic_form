import 'package:flutter/material.dart';

enum DynamicFormFieldType {
  text,
  textarea,
  email,
  password,
  number,
  phone,
  date,
  time,
  dropdown,
  radio,
  checkbox,
  file,
  image,
  video,
  audio,
  map,
  slider,
  range,
  rating,
  color,
  creditCard,
  currency,
  searchMenu,
  custom,
}

enum FormFieldSize { full, half, third }

class DynamicFormField {
  final String name;
  final String label;
  final DynamicFormFieldType type;
  final bool isRequired;
  final FormFieldValidator? validator;
  final dynamic initialValue;
  final List<String>? items;
  final FormFieldSize size;
  final Widget Function(dynamic value)? childBuilder;
  final Function(dynamic value)? onChanged;

  DynamicFormField({
    required this.name,
    required this.label,
    required this.type,
    this.isRequired = false,
    this.validator,
    this.initialValue,
    this.items,
    this.size = FormFieldSize.full,
    this.childBuilder,
    this.onChanged,
  }) {
    if ((type == DynamicFormFieldType.dropdown || type == DynamicFormFieldType.radio) &&
        (items == null || items!.isEmpty)) {
      if (initialValue == null) {
        throw ArgumentError('Items cannot be null or empty for dropdown or radio fields');
      }
      throw ArgumentError('Items cannot be null or empty for dropdown or radio fields');
    }

    if (type == DynamicFormFieldType.custom) {
      if (childBuilder == null) {
        throw ArgumentError('Child builder cannot be null for custom fields');
      }
    }
  }
}

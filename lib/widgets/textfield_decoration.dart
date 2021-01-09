import 'package:flutter/material.dart';

InputDecoration textFieldDecoration(String label, {String hintText}) {
  return InputDecoration(
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      labelText: label,
      errorMaxLines: 3,
      hintText: hintText ?? null,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)));
}

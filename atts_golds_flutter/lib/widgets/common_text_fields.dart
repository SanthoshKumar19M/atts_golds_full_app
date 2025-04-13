import 'package:flutter/material.dart';

class CommonInputFields {
  static InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.amber, width: 2),
      ),
    );
  }

  static Widget textField({
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: _inputDecoration(label),
      validator: validator,
    );
  }

  static Widget numberField({
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: _inputDecoration(label),
      keyboardType: TextInputType.number,
      validator: validator,
    );
  }
}

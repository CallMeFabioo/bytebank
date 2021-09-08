import 'package:flutter/material.dart';

class Input extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final IconData? icon;

  Input({
    this.controller,
    this.labelText,
    this.hintText,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: controller,
        style: TextStyle(fontSize: 24),
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          icon: icon != null ? Icon(icon) : null,
          labelText: labelText,
          hintText: hintText,
        ),
      ),
    );
  }
}

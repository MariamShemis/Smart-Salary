import 'package:flutter/material.dart';

class MiniTextField extends StatelessWidget {
  const MiniTextField({
    super.key,
    required this.controller,
    required this.hint,
    required this.onChanged,
    this.primaryColor = const Color(0xff004D40),
  });

  final TextEditingController controller;
  final String hint;
  final VoidCallback onChanged;
  final Color primaryColor;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      onChanged: (_) => onChanged(),
      style: const TextStyle(fontSize: 13),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: Colors.black38,
          fontSize: 12,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 4,
        ),
        filled: true,
        fillColor: const Color(0xFFFAFAFA),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: primaryColor,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: primaryColor,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}
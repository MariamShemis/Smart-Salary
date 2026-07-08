import 'package:flutter/material.dart';

class ResultBox extends StatelessWidget {
  const ResultBox({
    super.key,
    required this.value,
    this.width = 65,
    this.height = 40,
    this.backgroundColor = const Color(0xFFF5F5F5),
    this.textColor = Colors.black87,
    this.borderColor = Colors.black12,
  });

  final double value;
  final double width;
  final double height;
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: Center(
        child: Text(
          value.toStringAsFixed(1),
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

class TotalSalaryCard extends StatelessWidget {
  const TotalSalaryCard({
    super.key,
    required this.title,
    required this.formula,
    required this.value,
  });

  final String title;
  final String formula;
  final double value;

  static const primaryColor = Color(0xff004D40);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 110,
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFE0F2F1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: primaryColor,
                width: 1.2,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "$formula =",
                  style: const TextStyle(
                    fontSize: 12,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
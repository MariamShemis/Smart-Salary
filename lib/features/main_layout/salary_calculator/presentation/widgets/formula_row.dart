import 'package:flutter/material.dart';
import 'package:smart_salary/features/main_layout/salary_calculator/presentation/widgets/summary_item.dart';

class FormulaRow extends StatelessWidget {
  const FormulaRow({
    super.key,
    required this.label,
    required this.prefixText,
    this.controller,
    this.fixedValue,
    required this.hint,
    required this.resultValue,
    required this.onChanged,
    this.suffixText,
    this.primaryColor = const Color(0xff004D40),
    this.isVacation = false,
  });

  final String label;
  final String prefixText;
  final TextEditingController? controller;
  final String? fixedValue;
  final String hint;
  final String? suffixText;
  final double resultValue;
  final VoidCallback onChanged;
  final Color primaryColor;
  final bool isVacation;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 110,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Text(
                prefixText,
                style: const TextStyle(fontSize: 13, color: Colors.black54),
              ),
              const SizedBox(width: 8),
              isVacation
                  ? SummaryItem(value: fixedValue ?? "30", isTitle: false)
                  : Expanded(
                      child: TextField(
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
                      ),
                    ),
              if (suffixText != null) ...[
                const SizedBox(width: 8),
                Text(
                  suffixText!,
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ],
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text("="),
              ),
              Container(
                width: 65,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.black12),
                ),
                child: Center(
                  child: Text(
                    resultValue.toStringAsFixed(1),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

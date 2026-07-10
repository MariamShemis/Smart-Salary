import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    return LayoutBuilder(
      builder: (context, constraints) {
        return Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          runSpacing: 10.h,
          children: [
            SizedBox(
              width: 105.w,
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            SizedBox(
              width: constraints.maxWidth - 120.w,
              child: Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    prefixText,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.black54,
                    ),
                  ),

                  if (isVacation)
                    SummaryItem(
                      value: fixedValue ?? "30",
                      isTitle: false,
                    )
                  else
                    SizedBox(
                      width: 55.w,
                      height: 42.h,
                      child: TextField(
                        controller: controller,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        onChanged: (_) => onChanged(),
                        style: TextStyle(fontSize: 13.sp),
                        decoration: InputDecoration(
                          hintText: hint,
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 10.h,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: BorderSide(color: primaryColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: BorderSide(
                              color: primaryColor,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),

                  if (suffixText != null)
                    Text(
                      suffixText!,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.black54,
                      ),
                    ),

                  Text(
                    "=",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Container(
                    width: 70.w,
                    height: 40.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xffF5F5F5),
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(color: Colors.black12),
                    ),
                    child: Text(
                      resultValue.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
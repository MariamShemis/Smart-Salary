import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_salary/core/costants/color_manager.dart';

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
    final screenWidth = MediaQuery.sizeOf(context).width;
    final bool isSmallScreen = screenWidth < 360;

    final displayController = isVacation
        ? TextEditingController(text: fixedValue ?? "30")
        : controller;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 3,
          child: Text(
            label,
            style: TextStyle(
              fontSize: isSmallScreen ? 13.sp : 14.sp,
              fontWeight: FontWeight.w600,
              color: ColorManager.black,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(width: 4.w),
        Expanded(
          flex: 8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                fit: FlexFit.loose,
                child: Text(
                  prefixText,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: ColorManager.greyDark,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 4.w),
              SizedBox(
                width: 52.w,
                height: 40.h,
                child: TextField(
                  controller: displayController,
                  readOnly: isVacation,
                  enabled: !isVacation,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  onChanged: (_) => onChanged(),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: isVacation ? Colors.black87 : Colors.black,
                  ),
                  decoration: InputDecoration(
                    hintText: hint,
                    isDense: true,
                    filled: isVacation,
                    fillColor: isVacation
                        ? const Color(0xffF5F5F5)
                        : Colors.transparent,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 8.h,
                      horizontal: 2.w,
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: const BorderSide(color: Colors.black12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide(color: primaryColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide(color: primaryColor, width: 1.5),
                    ),
                  ),
                ),
              ),
              if (suffixText != null) ...[
                SizedBox(width: 4.w),
                Flexible(
                  fit: FlexFit.loose,
                  child: Text(
                    suffixText!,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: ColorManager.greyDark,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Text(
                  "=",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              /// مربع النتيجة النهائية
              Container(
                width: 58.w,
                height: 40.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xffF5F5F5),
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: Colors.black12),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    resultValue.toStringAsFixed(1),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
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

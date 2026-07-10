import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:smart_salary/core/costants/color_manager.dart';
import 'package:smart_salary/l10n/app_localizations.dart';

class AddDailyInput extends StatefulWidget {
  final DateTime selectedDay;
  final TextEditingController overtimeController;
  final TextEditingController bonusController;
  final TextEditingController absentController;
  final TextEditingController reportController;
  final VoidCallback onSave;

  const AddDailyInput({
    super.key,
    required this.selectedDay,
    required this.overtimeController,
    required this.bonusController,
    required this.absentController,
    required this.reportController,
    required this.onSave,
  });

  @override
  State<AddDailyInput> createState() => _AddDailyInputState();
}

class _AddDailyInputState extends State<AddDailyInput> {
  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    const primaryColor = ColorManager.primaryColor;
    const overTimeColor = Color(0xff00695C);
    const bonusColor = ColorManager.secondary;
    const absentColor = ColorManager.red;
    const reportsColor = Color(0xffFFB300);

    return Container(
      width: double.infinity,
      padding: REdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 20,
            spreadRadius: 5,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('MMMM dd, yyyy').format(widget.selectedDay),
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: REdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2F1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  DateFormat('EEEE').format(widget.selectedDay),
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          _buildInputField(
            controller: widget.overtimeController,
            label: appLocalizations.over_time,
            color: overTimeColor,
            hint: appLocalizations.enter_days,
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 16.h),
          _buildInputField(
            controller: widget.bonusController,
            label: appLocalizations.bonus,
            color: bonusColor,
            hint: appLocalizations.enter_unit,
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 16.h),
          _buildInputField(
            controller: widget.absentController,
            label: appLocalizations.absent,
            color: absentColor,
            hint: appLocalizations.enter_days,
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 16.h),
          _buildInputField(
            controller: widget.reportController,
            label: appLocalizations.reports,
            color: reportsColor,
            hint: '${appLocalizations.enter_report}...',
            keyboardType: TextInputType.text,
            isReport: true,
            maxLines: 4,
          ),
          SizedBox(height: 28.h),
          SizedBox(
            width: double.infinity,
            height: 54.h,
            child: ElevatedButton(
              onPressed: widget.onSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorManager.primaryColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.r),
                ),
              ),
              child: Text(
                appLocalizations.save,
                style: TextStyle(
                  color: ColorManager.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required Color color,
    required String hint,
    required TextInputType keyboardType,
    bool isReport = false,
    int maxLines = 1,
  }) {
    final decoration = InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.black38, fontSize: 13.sp),
      contentPadding: REdgeInsets.symmetric(horizontal: 16, vertical: 12),
      filled: true,
      fillColor: const Color(0xFFFAFAFA),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: ColorManager.primaryColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: ColorManager.primaryColor, width: 1.8.w),
      ),
    );

    final labelWidget = SizedBox(
      width: 110.w,
      child: Row(
        children: [
          Container(
            width: 16.w,
            height: 16.h,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );

    if (isReport) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          labelWidget,
          SizedBox(height: 12.h),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            decoration: decoration,
          ),
        ],
      );
    }
    return Row(
      children: [
        labelWidget,
        Expanded(
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            decoration: decoration,
          ),
        ),
      ],
    );
  }
}

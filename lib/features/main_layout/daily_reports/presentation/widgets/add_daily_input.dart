import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:smart_salary/core/costants/color_manager.dart';

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
    const primaryColor = Color(0xff004D40);
    const overTimeColor = Color(0xff00695C);
    const bonusColor = ColorManager.secondary;
    const absentColor = ColorManager.red;
    const reportsColor = Color(0xffFFB300);
    const vacationColor = Color(0xffB45309);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
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
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2F1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  DateFormat('EEEE').format(widget.selectedDay),
                  style: const TextStyle(
                    color: primaryColor,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          _buildInputField(
            controller: widget.overtimeController,
            label: 'Over time',
            color: overTimeColor,
            hint: 'Enter hours (number)',
            keyboardType: TextInputType.number,
          ),

          const SizedBox(height: 16),

          _buildInputField(
            controller: widget.bonusController,
            label: 'Bonus',
            color: bonusColor,
            hint: 'Enter bonus (number)',
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),

          _buildInputField(
            controller: widget.absentController,
            label: 'Absent',
            color: absentColor,
            hint: 'Enter days (number)',
            keyboardType: TextInputType.number,
          ),

          const SizedBox(height: 16),

          _buildInputField(
            controller: widget.reportController,
            label: 'Reports',
            color: reportsColor,
            hint: 'Type text report...',
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
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Text(
                'Save',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
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
      hintStyle: const TextStyle(color: Colors.black38, fontSize: 13),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      filled: true,
      fillColor: const Color(0xFFFAFAFA),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: ColorManager.primaryColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: ColorManager.primaryColor, width: 1.8),
      ),
    );

    final labelWidget = SizedBox(
      width: 110,
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
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
          const SizedBox(height: 12),
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

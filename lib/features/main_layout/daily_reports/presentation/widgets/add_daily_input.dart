import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_salary/core/costants/color_manager.dart';

class AddDailyInput extends StatefulWidget {
  final DateTime selectedDay;

  const AddDailyInput({super.key, required this.selectedDay});

  @override
  State<AddDailyInput> createState() => _AddDailyInputState();
}

class _AddDailyInputState extends State<AddDailyInput> {
  final TextEditingController _overtimeController = TextEditingController();
  final TextEditingController _bonusController = TextEditingController();
  final TextEditingController _absentController = TextEditingController();
  final TextEditingController _reportController = TextEditingController();

  @override
  void didUpdateWidget(covariant AddDailyInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDay != widget.selectedDay) {
      _overtimeController.clear();
      _bonusController.clear();
      _absentController.clear();
      _reportController.clear();
    }
  }

  @override
  void dispose() {
    _overtimeController.dispose();
    _bonusController.dispose();
    _absentController.dispose();
    _reportController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xff004D40);
    const overTimeColor = Color(0xff00695C);
    const bonusColor = ColorManager.secondary;
    const absentColor = ColorManager.red;
    const reportsColor = Color(0xffFFB300);

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
              // عرض التاريخ المختار ديناميكياً
              Text(
                DateFormat('MMMM dd, yyyy').format(widget.selectedDay),
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // عرض اسم اليوم ديناميكياً
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
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
            controller: _overtimeController,
            label: 'Over time',
            color: overTimeColor,
            hint: 'Enter hours (number)',
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          _buildInputField(
            controller: _bonusController,
            label: 'Bonus',
            color: bonusColor,
            hint: 'Enter bonus (number)',
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          _buildInputField(
            controller: _absentController,
            label: 'Absent',
            color: absentColor,
            hint: 'Enter days (number)',
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          _buildInputField(
            controller: _reportController,
            label: 'Reports',
            color: reportsColor,
            hint: 'Type text report...',
            isReport: true,
            keyboardType: TextInputType.text,
            maxLines: 4,
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: () {
                // هنا تقدري تستخدمي الحقول للحفظ:
                // print(_overtimeController.text);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Save :-)',
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
    final fieldDecoration = InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.black38, fontSize: 13),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      filled: true,
      fillColor: const Color(0xFFFAFAFA),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF004D40), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF004D40), width: 1.8),
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
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    return isReport
        ? Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        labelWidget,
        const SizedBox(height: 12),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: 4,
          style: const TextStyle(fontSize: 14),
          decoration: fieldDecoration,
        ),
      ],
    )
        : Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        labelWidget,
        Expanded(
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            style: const TextStyle(fontSize: 14),
            decoration: fieldDecoration,
          ),
        ),
      ],
    );
  }
}
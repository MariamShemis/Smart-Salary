import 'package:flutter/material.dart';
import 'package:smart_salary/features/main_layout/salary_calculator/presentation/widgets/summary_item.dart';
import 'formula_row.dart';
import 'row_text_field.dart';

class SalaryCard extends StatelessWidget {
  const SalaryCard({
    super.key,
    required this.basicSalaryController,
    required this.dailyCountDivisorController,
    required this.overtimeDaysController,
    required this.overtimeMultiplierController,
    required this.bonusDaysController,
    required this.bonusValueController,
    required this.vacationTotal,
    required this.absentDaysController,
    required this.dailyCountResult,
    required this.overtimeMonthResult,
    required this.bonusMonthResult,
    required this.annualVacationResult,
    required this.onChanged,
  });

  final TextEditingController basicSalaryController;
  final TextEditingController dailyCountDivisorController;
  final TextEditingController overtimeDaysController;
  final TextEditingController overtimeMultiplierController;
  final TextEditingController bonusDaysController;
  final TextEditingController bonusValueController;
  final String vacationTotal;
  final TextEditingController absentDaysController;

  final double dailyCountResult;
  final double overtimeMonthResult;
  final double bonusMonthResult;
  final double annualVacationResult;

  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.02),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          RowTextField(
            label: "Basic Salary",
            hint: "Enter basic salary",
            controller: basicSalaryController,
            onChanged: onChanged,
          ),

          const Divider(height: 30),

          FormulaRow(
            label: "Daily Count",
            prefixText: "Basic /",
            controller: dailyCountDivisorController,
            hint: "30",
            resultValue: dailyCountResult,
            onChanged: onChanged,
          ),

          const SizedBox(height: 16),
          SummaryItem(
            title: "Overtime Days",
            value: overtimeDaysController.text.isEmpty
                ? "0"
                : overtimeDaysController.text,
          ),
          const SizedBox(height: 16),

          FormulaRow(
            label: "Overtime Month",
            prefixText: "OT Days +",
            controller: overtimeMultiplierController,
            hint: "OT Variable",
            resultValue: overtimeMonthResult,
            onChanged: onChanged,
          ),

          const Divider(height: 30),

          SummaryItem(
            title: "Bonus Days",
            value: bonusDaysController.text.isEmpty
                ? "0"
                : bonusDaysController.text,
          ),

          const SizedBox(height: 16),

          FormulaRow(
            label: "Bonus Month",
            prefixText: "Days ×",
            controller: bonusValueController,
            hint: "20",
            resultValue: bonusMonthResult,
            onChanged: onChanged,
          ),

          const Divider(height: 30),

          SummaryItem(
            title: "Absent Days",
            value: absentDaysController.text.isEmpty
                ? "0"
                : absentDaysController.text,
          ),


          const SizedBox(height: 16),
          FormulaRow(
            label: "Vacation",
            prefixText: "Total",
            fixedValue: vacationTotal,
            hint: "",
            suffixText: "- Absent",
            resultValue: annualVacationResult,
            onChanged: onChanged,
            isVacation: true,
          ),
        ],
      ),
    );
  }
}
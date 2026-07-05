import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_salary/core/session_service/session_service.dart';

class SalaryCalculator extends StatefulWidget {
  const SalaryCalculator({super.key});

  @override
  State<SalaryCalculator> createState() => _SalaryCalculatorState();
}

class _SalaryCalculatorState extends State<SalaryCalculator> {
  static const primaryColor = Color(0xff004D40);

  final TextEditingController _basicSalaryController = TextEditingController();
  final TextEditingController _dailyCountDivisorController = TextEditingController(text: "30");

  final TextEditingController _overtimeDaysController = TextEditingController();
  final TextEditingController _overtimeMultiplierController = TextEditingController();

  final TextEditingController _bonusDaysController = TextEditingController();
  final TextEditingController _bonusValueController = TextEditingController(text: "20");

  final TextEditingController _vacationTotalController = TextEditingController(text: "30");
  final TextEditingController _absentDaysController = TextEditingController();

  final TextEditingController _deductionAbsentController = TextEditingController();
  final TextEditingController _deductionCustomController = TextEditingController();
  final TextEditingController _rewardValueController = TextEditingController();
  final TextEditingController _rewardMultiplierController = TextEditingController();

  double _dailyCountResult = 0.0;
  double _overtimeMonthResult = 0.0;
  double _bonusMonthResult = 0.0;
  double _annualVacationResult = 0.0;
  double _deductionResult = 0.0;
  double _totalSalaryResult = 0.0;
  double _totalSalaryWithRewardResult = 0.0;
  double _rewardResult = 0.0;

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    final savedData = await SessionService.loadSalaryInputs();
    setState(() {
      _basicSalaryController.text = savedData['basic']!;
      _dailyCountDivisorController.text = savedData['divisor']!;
      _overtimeDaysController.text = savedData['otDays']!;
      _overtimeMultiplierController.text = savedData['otMultiplier']!;
      _bonusDaysController.text = savedData['bonusDays']!;
      _bonusValueController.text = savedData['bonusValue']!;
      _vacationTotalController.text = savedData['vacationTotal']!;
      _absentDaysController.text = savedData['absentDays']!;
      _deductionAbsentController.text = savedData['deductAbsent']!;
      _deductionCustomController.text = savedData['deductCustom']!;
      _rewardValueController.text = savedData['rewardValue']!;
      _rewardMultiplierController.text = savedData['rewardMultiplier']!;
      _calculateSalary();
    });
  }

  Future<void> _saveData() async {
    await SessionService.saveSalaryInputs(
      basic: _basicSalaryController.text,
      divisor: _dailyCountDivisorController.text,
      otDays: _overtimeDaysController.text,
      otMultiplier: _overtimeMultiplierController.text,
      bonusDays: _bonusDaysController.text,
      bonusValue: _bonusValueController.text,
      vacationTotal: _vacationTotalController.text,
      absentDays: _absentDaysController.text,
      deductAbsent: _deductionAbsentController.text,
      deductCustom: _deductionCustomController.text,
      rewardValue: _rewardValueController.text,
      rewardMultiplier: _rewardMultiplierController.text,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Salary calculations saved successfully!'),
          backgroundColor: primaryColor,
        ),
      );
    }
  }

  void _calculateSalary() {
    setState(() {
      double basic = double.tryParse(_basicSalaryController.text) ?? 0.0;
      double divisor = double.tryParse(_dailyCountDivisorController.text) ?? 30.0;

      _dailyCountResult = divisor != 0 ? basic / divisor : 0.0;

      double otDays = double.tryParse(_overtimeDaysController.text) ?? 0.0;
      double otDaysResult = otDays * _dailyCountResult;
      double otMultiplier = double.tryParse(_overtimeMultiplierController.text) ?? 1.0;
      _overtimeMonthResult = otDaysResult + otMultiplier * _dailyCountResult;

      double bonusDays = double.tryParse(_bonusDaysController.text) ?? 0.0;
      double bonusValue = double.tryParse(_bonusValueController.text) ?? 20.0;
      _bonusMonthResult = bonusDays * bonusValue;

      double vacationTotal = double.tryParse(_vacationTotalController.text) ?? 30.0;
      double absentDays = double.tryParse(_absentDaysController.text) ?? 0.0;
      _annualVacationResult = vacationTotal - absentDays;

      double deductAbsent = double.tryParse(_deductionAbsentController.text) ?? 0.0;
      double deductCustom = double.tryParse(_deductionCustomController.text) ?? 0.0;
      _deductionResult = deductAbsent + deductCustom * _dailyCountResult;

      _totalSalaryResult = basic + _overtimeMonthResult + _bonusMonthResult - _deductionResult;

      double rValue = double.tryParse(_rewardValueController.text) ?? 0.0;
      double rMultiplier = double.tryParse(_rewardMultiplierController.text) ?? 0.0;
      _rewardResult = rValue + basic * rMultiplier;
      _totalSalaryWithRewardResult = _rewardResult + _totalSalaryResult;
    });
  }

  @override
  void dispose() {
    _basicSalaryController.dispose();
    _dailyCountDivisorController.dispose();
    _overtimeDaysController.dispose();
    _overtimeMultiplierController.dispose();
    _bonusDaysController.dispose();
    _bonusValueController.dispose();
    _vacationTotalController.dispose();
    _absentDaysController.dispose();
    _deductionAbsentController.dispose();
    _deductionCustomController.dispose();
    _rewardValueController.dispose();
    _rewardMultiplierController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Salary Calculator',
              style: TextStyle(
                color: primaryColor,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildRowTextField(
                    label: 'Basic Salary',
                    hint: 'Enter basic salary',
                    controller: _basicSalaryController,
                  ),
                  const Divider(height: 30),
                  _buildInteractiveFormulaRow(
                    label: 'Daily Count',
                    prefixText: 'Basic  /',
                    controller: _dailyCountDivisorController,
                    hint: '30',
                    resultValue: _dailyCountResult,
                  ),
                  const SizedBox(height: 16),
                  _buildRowTextField(
                    label: 'Overtime Days',
                    hint: 'Enter overtime days',
                    controller: _overtimeDaysController,
                  ),
                  const SizedBox(height: 16),
                  _buildInteractiveFormulaRow(
                    label: 'Overtime Month',
                    prefixText: 'OT Days  +',
                    controller: _overtimeMultiplierController,
                    hint: 'OT Variable',
                    resultValue: _overtimeMonthResult,
                  ),
                  const Divider(height: 30),
                  _buildRowTextField(
                    label: 'Bonus Days',
                    hint: 'Enter bonus days',
                    controller: _bonusDaysController,
                  ),
                  const SizedBox(height: 16),
                  _buildInteractiveFormulaRow(
                    label: 'Bonus Month',
                    prefixText: 'Days  ×',
                    controller: _bonusValueController,
                    hint: '20',
                    resultValue: _bonusMonthResult,
                  ),
                  const Divider(height: 30),
                  _buildRowTextField(
                    label: 'Absent Days',
                    hint: 'Enter absent days',
                    controller: _absentDaysController,
                  ),
                  const SizedBox(height: 16),
                  _buildInteractiveFormulaRow(
                    label: 'Vacation',
                    prefixText: 'Total',
                    controller: _vacationTotalController,
                    hint: '30',
                    suffixText: '-  Absent',
                    resultValue: _annualVacationResult,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Deductions & Rewards',
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const SizedBox(
                        width: 110,
                        child: Text(
                          'Deduction =',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Expanded(
                        child: _buildMiniTextField(
                          _deductionAbsentController,
                          'number',
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        child: Text('+'),
                      ),
                      Expanded(
                        child: _buildMiniTextField(
                          _deductionCustomController,
                          'absent',
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        child: Text(' ='),
                      ),
                      Container(
                        width: 65,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.black12),
                        ),
                        child: Center(
                          child: Text(
                            _deductionResult.toStringAsFixed(1),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 30),
                  const Text(
                    'Reward Formula:',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildMiniTextField(
                          _rewardValueController,
                          'sum',
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        child: Text('+'),
                      ),
                      Expanded(
                        child: _buildMiniTextField(
                          _rewardMultiplierController,
                          'amount',
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        child: Text('='),
                      ),
                      Container(
                        width: 65,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0F2F1),
                          border: Border.all(
                            color: primaryColor.withOpacity(0.5),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            _rewardResult.toStringAsFixed(1),
                            style: const TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 30),
                  Row(
                    children: [
                      const SizedBox(
                        width: 110,
                        child: Text(
                          'Total Salary',
                          style: TextStyle(
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
                            border: Border.all(color: primaryColor, width: 1.2),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Basic + OT + Bonus - Deduct =',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: primaryColor,
                                ),
                              ),
                              Text(
                                _totalSalaryResult.toStringAsFixed(1),
                                textAlign: TextAlign.end,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30.h),
                  Row(
                    children: [
                      const SizedBox(
                        width: 110,
                        child: Text(
                          'Total Salary with Reward',
                          style: TextStyle(
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
                            border: Border.all(color: primaryColor, width: 1.2),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total Salary + Reward = ',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: primaryColor,
                                ),
                              ),
                              Text(
                                _totalSalaryWithRewardResult.toStringAsFixed(1),
                                textAlign: TextAlign.end,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _saveData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  elevation: 0,
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
      ),
    );
  }

  Widget _buildInteractiveFormulaRow({
    required String label,
    required String prefixText,
    required TextEditingController controller,
    required String hint,
    String? suffixText,
    required double resultValue,
  }) {
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
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  onChanged: (_) => _calculateSalary(),
                  textAlign: TextAlign.center,
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
                      borderSide: const BorderSide(
                        color: primaryColor,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
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
                  suffixText,
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ],
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text('='),
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
                      color: Colors.black87,
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

  Widget _buildRowTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
  }) {
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
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            onChanged: (_) => _calculateSalary(),
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.black38, fontSize: 13),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 10,
              ),
              filled: true,
              fillColor: const Color(0xFFFAFAFA),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: primaryColor, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: primaryColor, width: 1.8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMiniTextField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      onChanged: (_) => _calculateSalary(),
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 13),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black38, fontSize: 12),
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        filled: true,
        fillColor: const Color(0xFFFAFAFA),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryColor, width: 1.5),
        ),
      ),
    );
  }
}
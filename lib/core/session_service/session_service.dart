import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_salary/core/helper/salary_period_helper.dart';

class SessionService {
  static SharedPreferences? _prefs;

  static const String _basicSalaryKey = 'calc_basic_salary';
  static const String _dailyDivisorKey = 'calc_daily_divisor';
  static const String _overtimeMultiplierKey = 'calc_overtime_multiplier';
  static const String _bonusValueKey = 'calc_bonus_value';

  static const String _totalSalaryKey = "total_salary";
  static const String _totalSalaryWithRewardKey = "total_salary_with_reward";
  static const String _overtimeMonthKey = "overtime_month";
  static const String _bonusMonthKey = "bonus_month";
  static const String _deductionKey = "deduction";
  static const String _vacationDaysKey = "vacation_days";

  static const String _selectedMonthKey = "selected_month";

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> _ensureInitialized() async {
    if (_prefs == null) await init();
  }

  static Future<void> recalculateSalary(DateTime month) async {
    await _ensureInitialized();
    final salaryInputs = await loadSalaryInputs();
    final monthlyTotals = await loadMonthlyTotals(month);
    final monthData = await loadMonthlySalaryData(month);
    final yearlyAbsent = await loadYearlyAbsent(month);
    final basic = double.tryParse(salaryInputs["basic"] ?? "0") ?? 0;
    final divisor = double.tryParse(salaryInputs["divisor"] ?? "30") ?? 30;
    final otMultiplier =
        double.tryParse(monthData["overtimeMultiplier"] ?? "0") ?? 0;

    final bonusValue =
        double.tryParse(monthData["bonusValue"] ?? "20") ?? 20;
    final overtimeDays = monthlyTotals["overtime"] ?? 0;
    final bonusDays = monthlyTotals["bonus"] ?? 0;
    final absentDays = monthlyTotals["absent"] ?? 0;
    final dailySalary = divisor == 0 ? 0 : basic / divisor;
    final overtimeMonth =
        (overtimeDays * dailySalary) + (otMultiplier * dailySalary);
    final bonusMonth = bonusDays * bonusValue;
    final deductAbsent = double.tryParse(monthData["deductAbsent"] ?? "0") ?? 0;
    final deductCustom = double.tryParse(monthData["deductCustom"] ?? "0") ?? 0;
    final deduction = deductAbsent + (deductCustom * dailySalary);
    final rewardValue = double.tryParse(monthData["rewardValue"] ?? "0") ?? 0;
    final rewardMultiplier =
        double.tryParse(monthData["rewardMultiplier"] ?? "0") ?? 0;
    final reward = rewardValue + (basic * rewardMultiplier);
    final totalSalary = basic + overtimeMonth + bonusMonth - deduction;
    final totalSalaryWithReward = totalSalary + reward;
    final vacation = 30 - yearlyAbsent;
    await saveSalaryResults(
      totalSalary: totalSalary,
      totalSalaryWithReward: totalSalaryWithReward,
      overtimeMonth: overtimeMonth,
      bonusMonth: bonusMonth,
      deduction: deduction,
      vacationDays: vacation,
      month: month,
    );
  }

  static Future<void> saveSalaryInputs({
    required String basic,
    required String divisor,
  }) async {
    await _ensureInitialized();

    await _prefs!.setString(_basicSalaryKey, basic);
    await _prefs!.setString(_dailyDivisorKey, divisor);
    // await _prefs!.setString(_overtimeMultiplierKey, otMultiplier);
    // await _prefs!.setString(_bonusValueKey, bonusValue);
  }

  static Future<Map<String, String>> loadSalaryInputs() async {
    await _ensureInitialized();

    return {
      'basic': _prefs!.getString(_basicSalaryKey) ?? '',
      'divisor': _prefs!.getString(_dailyDivisorKey) ?? '30',
      'otMultiplier': _prefs!.getString(_overtimeMultiplierKey) ?? '',
      'bonusValue': _prefs!.getString(_bonusValueKey) ?? '20',
    };
  }

  static Future<void> clearSalaryInputs() async {
    await _ensureInitialized();

    await _prefs!.remove(_basicSalaryKey);
    await _prefs!.remove(_dailyDivisorKey);
    await _prefs!.remove(_overtimeMultiplierKey);
    await _prefs!.remove(_bonusValueKey);
  }

  static Future<void> saveDailyInput({
    required DateTime date,
    required String overtime,
    required String bonus,
    required String absent,
    required String report,
  }) async {
    await _ensureInitialized();

    final key = "daily_${date.year}_${date.month}_${date.day}";

    final data = jsonEncode({
      "overtime": overtime,
      "bonus": bonus,
      "absent": absent,
      "report": report,
    });

    await _prefs!.setString(key, data);
  }

  static Future<void> saveSalaryResults({
    required DateTime month,
    required double totalSalary,
    required double totalSalaryWithReward,
    required double overtimeMonth,
    required double bonusMonth,
    required double deduction,
    required double vacationDays,
  }) async {
    await _ensureInitialized();

    final key = "salary_result_${month.year}_${month.month}";

    final data = jsonEncode({
      "totalSalary": totalSalary,
      "totalSalaryWithReward": totalSalaryWithReward,
      "overtimeMonth": overtimeMonth,
      "bonusMonth": bonusMonth,
      "deduction": deduction,
      "vacationDays": vacationDays,
    });

    await _prefs!.setString(key, data);
  }

  static Future<Map<String, double>> loadSalaryResults(DateTime month) async {
    await _ensureInitialized();

    final salary = await loadSalaryInputs();
    final totals = await loadMonthlyTotals(month);

    final key = "salary_result_${month.year}_${month.month}";
    final json = _prefs!.getString(key);

    if (json == null) {
      return {
        "basicSalary": double.tryParse(salary["basic"] ?? "0") ?? 0,
        "overtimeDays": totals["overtime"] ?? 0,
        "bonusDays": totals["bonus"] ?? 0,
        "totalSalary": 0,
        "totalSalaryWithReward": 0,
        "overtimeMonth": 0,
        "bonusMonth": 0,
        "deduction": 0,
        "vacationDays": 30,
      };
    }
    final data = jsonDecode(json);
    return {
      "basicSalary": double.tryParse(salary["basic"] ?? "0") ?? 0,
      "overtimeDays": totals["overtime"] ?? 0,
      "bonusDays": totals["bonus"] ?? 0,
      "totalSalary": (data["totalSalary"] ?? 0).toDouble(),
      "totalSalaryWithReward": (data["totalSalaryWithReward"] ?? 0).toDouble(),
      "overtimeMonth": (data["overtimeMonth"] ?? 0).toDouble(),
      "bonusMonth": (data["bonusMonth"] ?? 0).toDouble(),
      "deduction": (data["deduction"] ?? 0).toDouble(),
      "vacationDays": (data["vacationDays"] ?? 30).toDouble(),
    };
  }

  static Future<void> saveMonthlySalaryData({
    required DateTime month,
    required String deductAbsent,
    required String deductCustom,
    required String rewardValue,
    required String rewardMultiplier,
    required String overtimeMultiplier,
    required String bonusValue,
  }) async {
    await _ensureInitialized();

    final key = "salary_${month.year}_${month.month}";

    final data = jsonEncode({
      "deductAbsent": deductAbsent,
      "deductCustom": deductCustom,
      "rewardValue": rewardValue,
      "rewardMultiplier": rewardMultiplier,
      "overtimeMultiplier": overtimeMultiplier,
      "bonusValue": bonusValue,
    });

    await _prefs!.setString(key, data);
  }

  static Future<Map<String, String>> loadMonthlySalaryData(
    DateTime month,
  ) async {
    await _ensureInitialized();

    final key = "salary_${month.year}_${month.month}";

    final json = _prefs!.getString(key);

    if (json == null) {
      return {
        "deductAbsent": "",
        "deductCustom": "",
        "rewardValue": "",
        "rewardMultiplier": "",
        "overtimeMultiplier": "",
        "bonusValue": "20",
      };
    }

    final data = jsonDecode(json);

    return {
      "deductAbsent": data["deductAbsent"] ?? "",
      "deductCustom": data["deductCustom"] ?? "",
      "rewardValue": data["rewardValue"] ?? "",
      "rewardMultiplier": data["rewardMultiplier"] ?? "",
      "overtimeMultiplier": data["overtimeMultiplier"] ?? "",
      "bonusValue": data["bonusValue"] ?? "20",
    };
  }

  static Future<Map<String, String>> loadDailyInput(DateTime date) async {
    await _ensureInitialized();

    final key = "daily_${date.year}_${date.month}_${date.day}";

    final json = _prefs!.getString(key);

    if (json == null) {
      return {"overtime": "", "bonus": "", "absent": "", "report": ""};
    }

    final data = jsonDecode(json);

    return {
      "overtime": data["overtime"] ?? "",
      "bonus": data["bonus"] ?? "",
      "absent": data["absent"] ?? "",
      "report": data["report"] ?? "",
    };
  }

  static Future<Map<String, double>> loadMonthlyTotals(DateTime month) async {
    await _ensureInitialized();

    double overtime = 0;
    double bonus = 0;
    double absent = 0;

    final days = SalaryPeriodHelper.getAllDays(month);

    for (final date in days) {
      final key = "daily_${date.year}_${date.month}_${date.day}";

      final json = _prefs!.getString(key);

      if (json == null) continue;

      final data = jsonDecode(json);

      overtime += double.tryParse(data["overtime"] ?? "0") ?? 0;
      bonus += double.tryParse(data["bonus"] ?? "0") ?? 0;
      absent += double.tryParse(data["absent"] ?? "0") ?? 0;
    }
    return {"overtime": overtime, "bonus": bonus, "absent": absent};
  }

  static Future<double> loadYearlyAbsent(DateTime date) async {
    await _ensureInitialized();

    double absent = 0;

    for (int month = 1; month <= 12; month++) {
      final days = SalaryPeriodHelper.getAllDays(DateTime(date.year, month));

      for (final day in days) {
        final key = "daily_${day.year}_${day.month}_${day.day}";

        final json = _prefs!.getString(key);

        if (json == null) continue;

        final data = jsonDecode(json);

        absent += double.tryParse(data["absent"] ?? "0") ?? 0;
      }
    }

    return absent;
  }

  static Future<void> saveSelectedMonth(DateTime month) async {
    await _ensureInitialized();

    await _prefs!.setString(_selectedMonthKey, month.toIso8601String());
  }

  static Future<DateTime> loadSelectedMonth() async {
    await _ensureInitialized();

    final value = _prefs!.getString(_selectedMonthKey);

    if (value == null) {
      return DateTime.now();
    }

    return DateTime.parse(value);
  }
}

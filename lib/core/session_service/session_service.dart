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

  static Future<void> saveSalaryInputs({
    required String basic,
    required String divisor,
    required String otMultiplier,
    required String bonusValue,
  }) async {
    await _ensureInitialized();

    await _prefs!.setString(_basicSalaryKey, basic);
    await _prefs!.setString(_dailyDivisorKey, divisor);
    await _prefs!.setString(_overtimeMultiplierKey, otMultiplier);
    await _prefs!.setString(_bonusValueKey, bonusValue);
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
    required double totalSalary,
    required double totalSalaryWithReward,
    required double overtimeMonth,
    required double bonusMonth,
    required double deduction,
    required double vacationDays,
  }) async {
    await _ensureInitialized();

    await _prefs!.setDouble(_totalSalaryKey, totalSalary);
    await _prefs!.setDouble(_totalSalaryWithRewardKey, totalSalaryWithReward);
    await _prefs!.setDouble(_overtimeMonthKey, overtimeMonth);
    await _prefs!.setDouble(_bonusMonthKey, bonusMonth);
    await _prefs!.setDouble(_deductionKey, deduction);
    await _prefs!.setDouble(_vacationDaysKey, vacationDays);
  }

  static Future<Map<String, double>> loadSalaryResults(DateTime month) async {
    await _ensureInitialized();

    final salary = await loadSalaryInputs();
    final totals = await loadMonthlyTotals(month);

    return {
      "basicSalary": double.tryParse(salary["basic"] ?? "0") ?? 0,

      "overtimeDays": totals["overtime"] ?? 0,
      "bonusDays": totals["bonus"] ?? 0,

      "totalSalary": _prefs!.getDouble(_totalSalaryKey) ?? 0,
      "totalSalaryWithReward":
      _prefs!.getDouble(_totalSalaryWithRewardKey) ?? 0,
      "overtimeMonth": _prefs!.getDouble(_overtimeMonthKey) ?? 0,
      "bonusMonth": _prefs!.getDouble(_bonusMonthKey) ?? 0,
      "deduction": _prefs!.getDouble(_deductionKey) ?? 0,
      "vacationDays": _prefs!.getDouble(_vacationDaysKey) ?? 30,
    };
  }

  static Future<void> saveMonthlySalaryData({
    required DateTime month,
    required String deductAbsent,
    required String deductCustom,
    required String rewardValue,
    required String rewardMultiplier,
  }) async {
    await _ensureInitialized();

    final key = "salary_${month.year}_${month.month}";

    final data = jsonEncode({
      "deductAbsent": deductAbsent,
      "deductCustom": deductCustom,
      "rewardValue": rewardValue,
      "rewardMultiplier": rewardMultiplier,
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
      };
    }

    final data = jsonDecode(json);

    return {
      "deductAbsent": data["deductAbsent"] ?? "",
      "deductCustom": data["deductCustom"] ?? "",
      "rewardValue": data["rewardValue"] ?? "",
      "rewardMultiplier": data["rewardMultiplier"] ?? "",
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
      final days = SalaryPeriodHelper.getAllDays(
        DateTime(date.year, month),
      );

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

    await _prefs!.setString(
      _selectedMonthKey,
      month.toIso8601String(),
    );
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

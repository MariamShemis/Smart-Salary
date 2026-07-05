import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static SharedPreferences? _prefs;

  static const String _basicSalaryKey = 'calc_basic_salary';
  static const String _dailyDivisorKey = 'calc_daily_divisor';
  static const String _overtimeDaysKey = 'calc_overtime_days';
  static const String _overtimeMultiplierKey = 'calc_overtime_multiplier';
  static const String _bonusDaysKey = 'calc_bonus_days';
  static const String _bonusValueKey = 'calc_bonus_value';
  static const String _vacationTotalKey = 'calc_vacation_total';
  static const String _absentDaysKey = 'calc_absent_days';
  static const String _deductionAbsentKey = 'calc_deduction_absent';
  static const String _deductionCustomKey = 'calc_deduction_custom';
  static const String _rewardValueKey = 'calc_reward_value';
  static const String _rewardMultiplierKey = 'calc_reward_multiplier';

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> _ensureInitialized() async {
    if (_prefs == null) await init();
  }

  static Future<void> saveSalaryInputs({
    required String basic,
    required String divisor,
    required String otDays,
    required String otMultiplier,
    required String bonusDays,
    required String bonusValue,
    required String vacationTotal,
    required String absentDays,
    required String deductAbsent,
    required String deductCustom,
    required String rewardValue,
    required String rewardMultiplier,
  }) async {
    await _ensureInitialized();
    await _prefs!.setString(_basicSalaryKey, basic);
    await _prefs!.setString(_dailyDivisorKey, divisor);
    await _prefs!.setString(_overtimeDaysKey, otDays);
    await _prefs!.setString(_overtimeMultiplierKey, otMultiplier);
    await _prefs!.setString(_bonusDaysKey, bonusDays);
    await _prefs!.setString(_bonusValueKey, bonusValue);
    await _prefs!.setString(_vacationTotalKey, vacationTotal);
    await _prefs!.setString(_absentDaysKey, absentDays);
    await _prefs!.setString(_deductionAbsentKey, deductAbsent);
    await _prefs!.setString(_deductionCustomKey, deductCustom);
    await _prefs!.setString(_rewardValueKey, rewardValue);
    await _prefs!.setString(_rewardMultiplierKey, rewardMultiplier);
  }

  static Future<Map<String, String>> loadSalaryInputs() async {
    await _ensureInitialized();
    return {
      'basic': _prefs!.getString(_basicSalaryKey) ?? '',
      'divisor': _prefs!.getString(_dailyDivisorKey) ?? '30',
      'otDays': _prefs!.getString(_overtimeDaysKey) ?? '',
      'otMultiplier': _prefs!.getString(_overtimeMultiplierKey) ?? '',
      'bonusDays': _prefs!.getString(_bonusDaysKey) ?? '',
      'bonusValue': _prefs!.getString(_bonusValueKey) ?? '20',
      'vacationTotal': _prefs!.getString(_vacationTotalKey) ?? '30',
      'absentDays': _prefs!.getString(_absentDaysKey) ?? '',
      'deductAbsent': _prefs!.getString(_deductionAbsentKey) ?? '',
      'deductCustom': _prefs!.getString(_deductionCustomKey) ?? '',
      'rewardValue': _prefs!.getString(_rewardValueKey) ?? '',
      'rewardMultiplier': _prefs!.getString(_rewardMultiplierKey) ?? '',
    };
  }

  static Future<void> clearSalaryInputs() async {
    await _ensureInitialized();
    await _prefs!.remove(_basicSalaryKey);
    await _prefs!.remove(_dailyDivisorKey);
    await _prefs!.remove(_overtimeDaysKey);
    await _prefs!.remove(_overtimeMultiplierKey);
    await _prefs!.remove(_bonusDaysKey);
    await _prefs!.remove(_bonusValueKey);
    await _prefs!.remove(_vacationTotalKey);
    await _prefs!.remove(_absentDaysKey);
    await _prefs!.remove(_deductionAbsentKey);
    await _prefs!.remove(_deductionCustomKey);
    await _prefs!.remove(_rewardValueKey);
    await _prefs!.remove(_rewardMultiplierKey);
  }
}

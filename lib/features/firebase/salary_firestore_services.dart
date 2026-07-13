import 'package:cloud_firestore/cloud_firestore.dart';

class SalaryFirestoreServices {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static DocumentReference<Map<String, dynamic>> _userDoc(String uid) {
    return _firestore.collection("users").doc(uid);
  }

  /// =========================
  /// Salary Inputs
  /// =========================

  static Future<void> saveSalaryInputs({
    required String uid,
    required String basic,
    required String divisor,
  }) async {
    await _userDoc(uid).collection("settings").doc("salary").set({
      "basic": basic,
      "divisor": divisor,
    }, SetOptions(merge: true));
  }

  static Future<Map<String, dynamic>> loadSalaryInputs(String uid) async {
    final doc = await _userDoc(uid).collection("settings").doc("salary").get();

    return doc.data() ?? {"basic": "", "divisor": "30"};
  }

  /// =========================
  /// Monthly Salary Data
  /// =========================

  static Future<void> saveMonthlySalaryData({
    required String uid,
    required DateTime month,
    required String deductAbsent,
    required String deductCustom,
    required String rewardValue,
    required String rewardMultiplier,
    required String overtimeMultiplier,
    required String bonusValue,
  }) async {
    await _userDoc(
      uid,
    ).collection("salary_months").doc("${month.year}-${month.month}").set({
      "deductAbsent": deductAbsent,
      "deductCustom": deductCustom,
      "rewardValue": rewardValue,
      "rewardMultiplier": rewardMultiplier,
      "overtimeMultiplier": overtimeMultiplier,
      "bonusValue": bonusValue,
    });
  }

  static Future<Map<String, dynamic>> loadMonthlySalaryData({
    required String uid,
    required DateTime month,
  }) async {
    final doc = await _userDoc(
      uid,
    ).collection("salary_months").doc("${month.year}-${month.month}").get();

    return doc.data() ??
        {
          "deductAbsent": "",
          "deductCustom": "",
          "rewardValue": "",
          "rewardMultiplier": "",
          "overtimeMultiplier": "",
          "bonusValue": "20",
        };
  }

  /// =========================
  /// Daily Report
  /// =========================

  static Future<void> saveDailyInput({
    required String uid,
    required DateTime date,
    required String overtime,
    required String bonus,
    required String absent,
    required String report,
  }) async {
    await _userDoc(uid)
        .collection("daily_reports")
        .doc("${date.year}-${date.month}-${date.day}")
        .set({
          "date": Timestamp.fromDate(date),
          "overtime": overtime,
          "bonus": bonus,
          "absent": absent,
          "report": report,
        });
  }

  static Future<Map<String, dynamic>> loadDailyInput({
    required String uid,
    required DateTime date,
  }) async {
    final doc = await _userDoc(uid)
        .collection("daily_reports")
        .doc("${date.year}-${date.month}-${date.day}")
        .get();

    return doc.data() ??
        {"overtime": "", "bonus": "", "absent": "", "report": ""};
  }

  /// =========================
  /// Salary Results
  /// =========================

  static Future<void> saveSalaryResult({
    required String uid,
    required DateTime month,
    required double totalSalary,
    required double totalSalaryWithReward,
    required double overtimeMonth,
    required double bonusMonth,
    required double deduction,
    required double vacationDays,
  }) async {
    await _userDoc(
      uid,
    ).collection("salary_results").doc("${month.year}-${month.month}").set({
      "totalSalary": totalSalary,
      "totalSalaryWithReward": totalSalaryWithReward,
      "overtimeMonth": overtimeMonth,
      "bonusMonth": bonusMonth,
      "deduction": deduction,
      "vacationDays": vacationDays,
    });
  }

  static Future<Map<String, dynamic>> loadSalaryResult({
    required String uid,
    required DateTime month,
  }) async {
    final doc = await _userDoc(
      uid,
    ).collection("salary_results").doc("${month.year}-${month.month}").get();

    return doc.data() ??
        {
          "totalSalary": 0.0,
          "totalSalaryWithReward": 0.0,
          "overtimeMonth": 0.0,
          "bonusMonth": 0.0,
          "deduction": 0.0,
          "vacationDays": 30.0,
        };
  }

  /// =========================
  /// Selected Month
  /// =========================

  static Future<void> saveSelectedMonth({
    required String uid,
    required DateTime month,
  }) async {
    await _userDoc(uid).collection("settings").doc("selected_month").set({
      "month": month.toIso8601String(),
    });
  }

  static Future<DateTime> loadSelectedMonth(String uid) async {
    final doc = await _userDoc(
      uid,
    ).collection("settings").doc("selected_month").get();

    if (!doc.exists) {
      return DateTime.now();
    }

    return DateTime.parse(doc["month"]);
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> getMonthlyReports({
    required String uid,
    required DateTime month,
  }) async {
    final start = DateTime(month.year, month.month, 1);
    final end = DateTime(month.year, month.month + 1, 1);

    return await _userDoc(uid)
        .collection("daily_reports")
        .where("date", isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where("date", isLessThan: Timestamp.fromDate(end))
        .get();
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> getYearReports({
    required String uid,
    required int year,
  }) async {
    final start = DateTime(year, 1, 1);
    final end = DateTime(year + 1, 1, 1);

    return await _userDoc(uid)
        .collection("daily_reports")
        .where(
      "date",
      isGreaterThanOrEqualTo: Timestamp.fromDate(start),
    )
        .where(
      "date",
      isLessThan: Timestamp.fromDate(end),
    )
        .get();
  }
}

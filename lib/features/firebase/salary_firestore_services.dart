import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_salary/core/utils/helper/salary_period_helper.dart';

class SalaryFirestoreServices {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static DocumentReference<Map<String, dynamic>> _userDoc(String uid) {
    return _firestore.collection("users").doc(uid);
  }

  /// =========================
  /// Salary Inputs
  /// =========================

  static Future<void> saveSalaryHistory({
    required String uid,
    required DateTime month,
    required String basic,
    required String divisor,
  }) async {
    await _userDoc(
      uid,
    ).collection("salary_history").doc("${month.year}-${month.month}").set({
      "basic": basic,
      "divisor": divisor,
      "effectiveMonth": Timestamp.fromDate(DateTime(month.year, month.month)),
    });
  }

  static Future<Map<String, dynamic>> loadSalaryInputs({
    required String uid,
    required DateTime month,
  }) async {
    final target = DateTime(month.year, month.month);

    final snapshot = await _userDoc(
      uid,
    ).collection("salary_history").orderBy("effectiveMonth").get();

    Map<String, dynamic>? salary;

    for (final doc in snapshot.docs) {
      final data = doc.data();
      final effective = (data["effectiveMonth"] as Timestamp).toDate();
      if (!effective.isAfter(target)) {
        salary = data;
      } else {
        break;
      }
    }
    final snapshot1 = await _userDoc(
      uid,
    ).collection("salary_history").orderBy("effectiveMonth").get();

    // print("salary docs = ${snapshot1.docs.length}");
    //
    // for (final doc in snapshot1.docs) {
    //   print(doc.id);
    //   print(doc.data());
    // }
    return salary ?? {"basic": "0", "divisor": "30"};
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

  // static Future<QuerySnapshot<Map<String, dynamic>>> getMonthlyReports({
  //   required String uid,
  //   required DateTime month,
  // }) async {
  //   final start = DateTime(month.year, month.month, 1);
  //   final end = DateTime(month.year, month.month + 1, 1);
  //
  //   return await _userDoc(uid)
  //       .collection("daily_reports")
  //       .where("date", isGreaterThanOrEqualTo: Timestamp.fromDate(start))
  //       .where("date", isLessThan: Timestamp.fromDate(end))
  //       .get();
  // }

  static Future<QuerySnapshot<Map<String, dynamic>>> getYearReports({
    required String uid,
    required int year,
  }) async {
    final start = DateTime(year, 1, 1);
    final end = DateTime(year + 1, 1, 1);

    return await _userDoc(uid)
        .collection("daily_reports")
        .where("date", isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where("date", isLessThan: Timestamp.fromDate(end))
        .get();
  }

  static Future<Map<String, double>> loadMonthlyTotals({
    required String uid,
    required DateTime month,
  }) async {
    final reports = await getMonthlyReports(uid: uid, month: month);

    double overtime = 0;
    double bonus = 0;
    double absent = 0;

    for (final doc in reports.docs) {
      final data = doc.data();
      overtime += double.tryParse(data["overtime"]?.toString() ?? "0") ?? 0;
      bonus += double.tryParse(data["bonus"]?.toString() ?? "0") ?? 0;
      absent += double.tryParse(data["absent"]?.toString() ?? "0") ?? 0;
    }
    return {"overtime": overtime, "bonus": bonus, "absent": absent};
  }

  static Future<double> loadYearlyAbsent({
    required String uid,
    required int year,
  }) async {
    final reports = await getYearReports(uid: uid, year: year);
    double absent = 0;
    for (final doc in reports.docs) {
      final data = doc.data();
      absent += double.tryParse(data["absent"]?.toString() ?? "0") ?? 0;
    }
    return absent;
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> monthlyReportsStream({
    required String uid,
    required DateTime month,
  }) {
    final period = SalaryPeriodHelper.getPeriod(month);

    return _userDoc(uid)
        .collection("daily_reports")
        .where("date", isGreaterThanOrEqualTo: Timestamp.fromDate(period.start))
        .where("date", isLessThan: Timestamp.fromDate(period.end))
        .snapshots();

    // return FirebaseFirestore.instance
    //     .collection("users")
    //     .doc(uid)
    //     .collection("daily_reports")
    //     .where(
    //   "date",
    //   isGreaterThanOrEqualTo: Timestamp.fromDate(start),
    // )
    //     .where(
    //   "date",
    //   isLessThan: Timestamp.fromDate(end),
    // )
    //     .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> calendarReportsStream({
    required String uid,
    required DateTime firstDay,
    required DateTime lastDay,
  }) {
    return _userDoc(uid)
        .collection("daily_reports")
        .where("date", isGreaterThanOrEqualTo: Timestamp.fromDate(firstDay))
        .where("date", isLessThan: Timestamp.fromDate(lastDay))
        .snapshots();
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> getMonthlyReports({
    required String uid,
    required DateTime month,
  }) async {
    final period = SalaryPeriodHelper.getPeriod(month);

    return await _userDoc(uid)
        .collection("daily_reports")
        .where("date", isGreaterThanOrEqualTo: Timestamp.fromDate(period.start))
        .where("date", isLessThan: Timestamp.fromDate(period.end))
        .get();
  }

  static Future<Map<String, double>> loadYearlySalaryResults({
    required String uid,
    required int year,
  }) async {
    double annualOvertime = 0;
    double annualBonus = 0;

    final snapshot = await _userDoc(uid).collection("salary_results").get();

    for (final doc in snapshot.docs) {
      final id = doc.id.split("-");

      if (int.parse(id[0]) != year) continue;

      final data = doc.data();

      annualOvertime += (data["overtimeMonth"] as num?)?.toDouble() ?? 0;

      annualBonus += (data["bonusMonth"] as num?)?.toDouble() ?? 0;
    }

    return {"annualOvertime": annualOvertime, "annualBonus": annualBonus};
  }

  static Stream<Map<String, double>> monthlyTotalsStream({
    required String uid,
    required DateTime month,
  }) {
    final period = SalaryPeriodHelper.getPeriod(month);
    return _userDoc(uid)
        .collection("daily_reports")
        .where(
      "date",
      isGreaterThanOrEqualTo: Timestamp.fromDate(period.start),
    )
        .where(
      "date",
      isLessThan: Timestamp.fromDate(period.end),
    )
        .snapshots()
        .map((snapshot) {
      double overtime = 0;
      double bonus = 0;
      double absent = 0;

      for (final doc in snapshot.docs) {
        final data = doc.data();
        overtime +=
            double.tryParse(data["overtime"]?.toString() ?? "0") ?? 0;
        bonus +=
            double.tryParse(data["bonus"]?.toString() ?? "0") ?? 0;
        absent +=
            double.tryParse(data["absent"]?.toString() ?? "0") ?? 0;
      }

      return {
        "overtime": overtime,
        "bonus": bonus,
        "absent": absent,
      };
    });
  }

  static Future<void> createBackup({required String uid}) async {
    final userDoc = _userDoc(uid);

    final collections = [
      "salary_history",
      "salary_months",
      "daily_reports",
      "salary_results",
      "settings",
    ];

    final backup = <String, dynamic>{};

    for (final collection in collections) {
      final snapshot = await userDoc.collection(collection).get();

      backup[collection] = snapshot.docs.map((doc) {
        return {"id": doc.id, ...doc.data()};
      }).toList();
    }

    await userDoc.collection("backup").doc("latest").set({
      "createdAt": Timestamp.now(),
      "data": backup,
    });
  }

  static Future<Map<String, dynamic>> getBackupData({
    required String uid,
  }) async {
    final user = await _userDoc(uid).get();

    final salaryHistory = await _userDoc(
      uid,
    ).collection("salary_history").get();

    final salaryMonths = await _userDoc(uid).collection("salary_months").get();

    final dailyReports = await _userDoc(uid).collection("daily_reports").get();

    final salaryResults = await _userDoc(
      uid,
    ).collection("salary_results").get();

    return {
      "user": user.data(),
      "salary_history": salaryHistory.docs
          .map((e) => {"id": e.id, ...e.data()})
          .toList(),
      "salary_months": salaryMonths.docs
          .map((e) => {"id": e.id, ...e.data()})
          .toList(),
      "daily_reports": dailyReports.docs
          .map((e) => {"id": e.id, ...e.data()})
          .toList(),
      "salary_results": salaryResults.docs
          .map((e) => {"id": e.id, ...e.data()})
          .toList(),
      "createdAt": DateTime.now().toIso8601String(),
    };
  }

  static Future<void> saveBackupInfo({
    required String uid,
    required String type,
  }) async {
    await _userDoc(
      uid,
    ).collection("backup").doc(type).set({"createdAt": Timestamp.now()});
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>> backupStream({
    required String uid,
    required String type,
  }) {
    return _userDoc(uid).collection("backup").doc(type).snapshots();
  }

  /// =========================
  /// Restore Backup Data to Firestore
  /// =========================
  static Future<void> restoreBackupData({
    required String uid,
    required Map<String, dynamic> backupData,
  }) async {
    final batch = _firestore.batch();

    if (backupData["salary_history"] != null) {
      for (var item in backupData["salary_history"]) {
        final id = item["id"];
        final docRef = _userDoc(uid).collection("salary_history").doc(id);
        final mapData = Map<String, dynamic>.from(item)
          ..remove("id");

        if (mapData["effectiveMonth"] != null) {
          mapData["effectiveMonth"] =
              Timestamp.fromDate(DateTime.parse(mapData["effectiveMonth"]));
        }
        batch.set(docRef, mapData, SetOptions(merge: true));
      }
    }

    if (backupData["salary_months"] != null) {
      for (var item in backupData["salary_months"]) {
        final id = item["id"];
        final docRef = _userDoc(uid).collection("salary_months").doc(id);
        final mapData = Map<String, dynamic>.from(item)
          ..remove("id");
        batch.set(docRef, mapData, SetOptions(merge: true));
      }
    }

    if (backupData["daily_reports"] != null) {
      for (var item in backupData["daily_reports"]) {
        final id = item["id"];
        final docRef = _userDoc(uid).collection("daily_reports").doc(id);
        final mapData = Map<String, dynamic>.from(item)
          ..remove("id");
        if (mapData["date"] != null) {
          mapData["date"] = Timestamp.fromDate(DateTime.parse(mapData["date"]));
        }
        batch.set(docRef, mapData, SetOptions(merge: true));
      }
    }
    if (backupData["salary_results"] != null) {
      for (var item in backupData["salary_results"]) {
        final id = item["id"];
        final docRef = _userDoc(uid).collection("salary_results").doc(id);
        final mapData = Map<String, dynamic>.from(item)
          ..remove("id");
        batch.set(docRef, mapData, SetOptions(merge: true));
      }
    }

    await batch.commit();
  }
}

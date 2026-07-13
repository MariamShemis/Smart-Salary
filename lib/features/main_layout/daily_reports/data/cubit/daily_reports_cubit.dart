import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_salary/features/firebase/salary_firestore_services.dart';
import 'package:smart_salary/features/main_layout/daily_reports/data/cubit/daily_reports_state.dart';

class DailyReportsCubit extends Cubit<DailyReportsState> {
  DailyReportsCubit() : super(DailyReportsInitial());

  final String uid = FirebaseAuth.instance.currentUser!.uid;

  Future<void> loadDaily(DateTime day) async {
    final data = await SalaryFirestoreServices.loadDailyInput(
      uid: uid,
      date: day,
    );

    emit(
      DailyReportsLoaded(
        overtime: data["overtime"] ?? "",
        bonus: data["bonus"] ?? "",
        absent: data["absent"] ?? "",
        report: data["report"] ?? "",
      ),
    );
  }

  Future<void> saveDaily({
    required DateTime day,
    required String overtime,
    required String bonus,
    required String absent,
    required String report,
  }) async {
    await SalaryFirestoreServices.saveDailyInput(
      uid: uid,
      date: day,
      overtime: overtime,
      bonus: bonus,
      absent: absent,
      report: report,
    );

    emit(DailyReportsSaved());

    await loadDaily(day);
  }
}
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_salary/core/session_service/session_service.dart';
import 'package:smart_salary/features/main_layout/daily_reports/data/cubit/daily_reports_state.dart';

class DailyReportsCubit extends Cubit<DailyReportsState> {
  DailyReportsCubit() : super(DailyReportsInitial());

  Future<void> loadDaily(DateTime day) async {
    final data = await SessionService.loadDailyInput(day);

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
    await SessionService.saveDailyInput(
      date: day,
      overtime: overtime,
      bonus: bonus,
      absent: absent,
      report: report,
    );

    final month = await SessionService.loadSelectedMonth();
    await SessionService.recalculateSalary(month);

    emit(DailyReportsSaved());

    await loadDaily(day);
  }
}
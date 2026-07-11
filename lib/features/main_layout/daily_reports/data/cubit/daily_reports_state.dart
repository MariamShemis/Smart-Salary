abstract class DailyReportsState {}

class DailyReportsInitial extends DailyReportsState {}

class DailyReportsLoading extends DailyReportsState {}

class DailyReportsLoaded extends DailyReportsState {
  final String overtime;
  final String bonus;
  final String absent;
  final String report;

  DailyReportsLoaded({
    required this.overtime,
    required this.bonus,
    required this.absent,
    required this.report,
  });
}

class DailyReportsSaved extends DailyReportsState {}

class DailyReportsError extends DailyReportsState {
  final String message;

  DailyReportsError(this.message);
}
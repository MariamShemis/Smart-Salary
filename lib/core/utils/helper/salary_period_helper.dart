class SalaryPeriod {
  final DateTime start;
  final DateTime end;

  const SalaryPeriod({required this.start, required this.end});
}

class SalaryPeriodHelper {
  static SalaryPeriod getPeriod(DateTime month) {
    return SalaryPeriod(
      start: DateTime(month.year, month.month - 1, 27),
      end: DateTime(month.year, month.month, 27),
    );
  }

  static List<DateTime> getAllDays(DateTime month) {
    final period = getPeriod(month);

    final List<DateTime> days = [];

    for (
      DateTime date = period.start;
      !date.isAfter(period.end);
      date = date.add(const Duration(days: 1))
    ) {
      days.add(date);
    }

    return days;
  }

  static int getDaysCount(DateTime month) {
    return getAllDays(month).length;
  }

  static bool contains(DateTime month, DateTime date) {
    final period = getPeriod(month);

    return !date.isBefore(period.start) && !date.isAfter(period.end);
  }
}

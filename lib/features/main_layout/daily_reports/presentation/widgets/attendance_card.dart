import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_salary/core/costants/color_manager.dart';
import 'package:table_calendar/table_calendar.dart';

class AttendanceCard extends StatefulWidget {
  final DateTime selectedDay;
  final ValueChanged<DateTime> onDayChanged;

  const AttendanceCard({
    super.key,
    required this.selectedDay,
    required this.onDayChanged,
  });

  @override
  State<AttendanceCard> createState() => _AttendanceCardState();
}

class _AttendanceCardState extends State<AttendanceCard> {
  static const primaryColor = Color(0xff004D40);
  static const overTimeColor = Color(0xff00695C);
  static const bonusColor = ColorManager.secondary;
  static const absentColor = ColorManager.red;
  static const reportsColor = Color(0xffFFB300);

  late DateTime _focusedDay;

  final Map<DateTime, List<Color>> attendance = {
    DateTime(2026, 7, 1): [absentColor],
    DateTime(2026, 7, 2): [overTimeColor],
    DateTime(2026, 7, 3): [overTimeColor],
    DateTime(2026, 7, 4): [overTimeColor],
    DateTime(2026, 7, 5): [overTimeColor, bonusColor],
    DateTime(2026, 7, 6): [overTimeColor],
    DateTime(2026, 7, 9): [absentColor],
    DateTime(2026, 7, 10): [bonusColor],
    DateTime(2026, 7, 11): [bonusColor],
    DateTime(2026, 7, 12): [overTimeColor, absentColor],
    DateTime(2026, 7, 13): [absentColor],
    DateTime(2026, 7, 16): [overTimeColor],
    DateTime(2026, 7, 17): [overTimeColor],
    DateTime(2026, 7, 18): [overTimeColor],
    DateTime(2026, 7, 19): [overTimeColor],
    DateTime(2026, 7, 20): [overTimeColor],
  };

  @override
  void initState() {
    super.initState();
    _focusedDay = widget.selectedDay;
  }

  List<Color> _markers(DateTime day) {
    return attendance.entries
        .firstWhere(
          (e) => isSameDay(e.key, day),
      orElse: () => MapEntry(day, []),
    )
        .value;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 25),
          _buildCalendar(),
          const SizedBox(height: 5),
          // const Divider(),
          // const SizedBox(height: 12),
          // _buildLegend(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "ATTENDANCE",
              style: TextStyle(
                color: primaryColor,
                fontSize: 13,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat.yMMMM().format(_focusedDay),
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Row(
          children: [
            _navButton(
              Icons.chevron_left,
                  () {
                setState(() {
                  _focusedDay = DateTime(_focusedDay.year, _focusedDay.month - 1);
                });
              },
            ),
            const SizedBox(width: 10),
            _navButton(
              Icons.chevron_right,
                  () {
                setState(() {
                  _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + 1);
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _navButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: 42,
        height: 42,
        decoration: const BoxDecoration(
          color: Color(0xffF4F4F4),
          shape: BoxShape.circle,
        ),
        child: Icon(icon),
      ),
    );
  }

  Widget _buildCalendar() {
    return TableCalendar(
      firstDay: DateTime(2020),
      lastDay: DateTime(2035),
      focusedDay: _focusedDay,
      headerVisible: false,
      selectedDayPredicate: (day) => isSameDay(widget.selectedDay, day),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _focusedDay = focusedDay;
        });
        widget.onDayChanged(selectedDay); // نمرر اليوم الجديد للأب
      },
      onPageChanged: (focusedDay) {
        setState(() {
          _focusedDay = focusedDay;
        });
      },
      calendarStyle: const CalendarStyle(
        markersMaxCount: 3,
        canMarkersOverflow: false,
        markerMargin: EdgeInsets.only(top: 4),
        cellMargin: EdgeInsets.all(4),
      ),
      daysOfWeekStyle: const DaysOfWeekStyle(
        weekdayStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
        weekendStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
      ),
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, day, focusedDay) {
          return Center(
            child: Text(
              "${day.day}",
              style: TextStyle(
                color: day.month == _focusedDay.month ? Colors.black87 : Colors.black26,
              ),
            ),
          );
        },
        selectedBuilder: (context, day, focusedDay) {
          return Container(
            margin: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(
                "${day.day}",
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          );
        },
        markerBuilder: (context, day, events) {
          final dots = _markers(day);
          if (dots.isEmpty) return const SizedBox();
          return Positioned(
            bottom: 4,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: dots.map((color) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 1),
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _legend("Over time", overTimeColor),
        _legend("Bonus", bonusColor),
        _legend("Absent", absentColor),
        _legend("Reports", reportsColor),
      ],
    );
  }

  Widget _legend(String title, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(title, style: const TextStyle(fontSize: 12, color: Colors.black54)),
      ],
    );
  }
}
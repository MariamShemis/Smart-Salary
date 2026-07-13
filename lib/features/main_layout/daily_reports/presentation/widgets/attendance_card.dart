import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:smart_salary/core/costants/color_manager.dart';
import 'package:smart_salary/core/utils/helper/salary_period_helper.dart';
import 'package:smart_salary/features/firebase/salary_firestore_services.dart';
import 'package:smart_salary/l10n/app_localizations.dart';
import 'package:table_calendar/table_calendar.dart';

class AttendanceCard extends StatefulWidget {
  final DateTime selectedDay;
  final ValueChanged<DateTime> onDayChanged;
  final int refresh;

  const AttendanceCard({
    super.key,
    required this.selectedDay,
    required this.onDayChanged,
    required this.refresh,
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
  late DateTime _focusedDay = widget.selectedDay;
  final String uid = FirebaseAuth.instance.currentUser!.uid;
  StreamSubscription? _subscription;

  Map<DateTime, List<Color>> attendance = {};

  // Future<void> _loadAttendance() async {
  //   attendance.clear();
  //   final days = SalaryPeriodHelper.getAllDays(_focusedDay);
  //   for (final date in days) {
  //     final data = await SalaryFirestoreServices.loadDailyInput(
  //       uid: uid,
  //       date: date,
  //     );
  //     List<Color> colors = [];
  //     if ((double.tryParse(data["overtime"] ?? "0") ?? 0) > 0) {
  //       colors.add(overTimeColor);
  //     }
  //     if ((double.tryParse(data["bonus"] ?? "0") ?? 0) > 0) {
  //       colors.add(bonusColor);
  //     }
  //     if ((double.tryParse(data["absent"] ?? "0") ?? 0) > 0) {
  //       colors.add(absentColor);
  //     }
  //     if ((data["report"] ?? "").trim().isNotEmpty) {
  //       colors.add(reportsColor);
  //     }
  //     if (colors.isNotEmpty) {
  //       attendance[DateTime(date.year, date.month, date.day)] = colors;
  //     }
  //   }
  //   setState(() {});
  // }
  Future<void> _syncSelectedMonth() async {
    final month = await SalaryFirestoreServices.loadSelectedMonth(uid);

    // _focusedDay = DateTime(
    //   month.year,
    //   month.month,
    //   widget.selectedDay.day,
    // );
    _focusedDay = DateTime(month.year, month.month, 1);

    _listenToMonth();
  }

  void _listenToMonth() {
    _subscription?.cancel();

    final period = SalaryPeriodHelper.getPeriod(_focusedDay);

    final firstDay = period.start.subtract(const Duration(days: 10));
    final lastDay = period.end.add(const Duration(days: 10));

    _subscription =
        SalaryFirestoreServices.calendarReportsStream(
          uid: uid,
          firstDay: firstDay,
          lastDay: lastDay,
        ).listen((snapshot) {
          attendance.clear();

          for (final doc in snapshot.docs) {
            final data = doc.data();
            final date = (data["date"] as Timestamp).toDate();

            final colors = <Color>[];

            if ((double.tryParse(data["overtime"].toString()) ?? 0) > 0) {
              colors.add(overTimeColor);
            }

            if ((double.tryParse(data["bonus"].toString()) ?? 0) > 0) {
              colors.add(bonusColor);
            }

            if ((double.tryParse(data["absent"].toString()) ?? 0) > 0) {
              colors.add(absentColor);
            }

            if ((data["report"] ?? "").toString().trim().isNotEmpty) {
              colors.add(reportsColor);
            }

            if (colors.isNotEmpty) {
              attendance[DateTime(date.year, date.month, date.day)] = colors;
            }
          }

          if (mounted) {
            setState(() {});
          }
        });
  }

  @override
  void initState() {
    super.initState();
    _focusedDay = widget.selectedDay;
    _syncSelectedMonth();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
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
      padding: REdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.r),
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
          SizedBox(height: 25.h),
          _buildCalendar(),
          SizedBox(height: 5.h),
          // const Divider(),
          // const SizedBox(height: 12),
          // _buildLegend(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                appLocalizations.attendance.toUpperCase(),
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                DateFormat.yMMMM().format(_focusedDay),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Row(
          children: [
            _navButton(Icons.chevron_left, () async {
              _focusedDay = DateTime(_focusedDay.year, _focusedDay.month - 1);
              await SalaryFirestoreServices.saveSelectedMonth(
                uid: uid,
                month: _focusedDay,
              );
              _listenToMonth();
              widget.onDayChanged(_focusedDay);
            }),
            SizedBox(width: 10.w),
            _navButton(Icons.chevron_right, () async {
              _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + 1);

              await SalaryFirestoreServices.saveSelectedMonth(
                uid: uid,
                month: _focusedDay,
              );

              _listenToMonth();

              widget.onDayChanged(_focusedDay);
            }),
          ],
        ),
      ],
    );
  }

  Widget _navButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30.r),
      child: Container(
        width: 42.w,
        height: 42.h,
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
      //key: ValueKey(widget.refresh),
      firstDay: DateTime(2020),
      lastDay: DateTime(2035),
      focusedDay: _focusedDay,
      headerVisible: false,
      selectedDayPredicate: (day) => isSameDay(widget.selectedDay, day),
      onDaySelected: (selectedDay, focusedDay) async {
        _focusedDay = focusedDay;
        await SalaryFirestoreServices.saveSelectedMonth(
          uid: uid,
          month: focusedDay,
        );
        _listenToMonth();
        widget.onDayChanged(selectedDay);
      },
      onPageChanged: (focusedDay) async {
        _focusedDay = focusedDay;
        await SalaryFirestoreServices.saveSelectedMonth(
          uid: uid,
          month: focusedDay,
        );
        _listenToMonth();
      },
      calendarStyle: CalendarStyle(
        markersMaxCount: 3,
        canMarkersOverflow: false,
        markerMargin: REdgeInsets.only(top: 4),
        cellMargin: REdgeInsets.all(4),
      ),
      daysOfWeekStyle: const DaysOfWeekStyle(
        weekdayStyle: TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.bold,
        ),
        weekendStyle: TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.bold,
        ),
      ),
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, day, focusedDay) {
          return Center(
            child: Text(
              "${day.day}",
              style: TextStyle(
                color: SalaryPeriodHelper.contains(_focusedDay, day)
                    ? Colors.black87
                    : Colors.black26,
              ),
            ),
          );
        },
        selectedBuilder: (context, day, focusedDay) {
          return Container(
            margin: REdgeInsets.all(6),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Center(
              child: Text(
                "${day.day}",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
        markerBuilder: (context, day, events) {
          final dots = _markers(day);
          if (dots.isEmpty) return const SizedBox();
          return Positioned(
            bottom: 4.h,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: dots.map((color) {
                return Container(
                  margin: REdgeInsets.symmetric(horizontal: 1),
                  width: 5.w,
                  height: 5.h,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLegend() {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _legend(appLocalizations.over_time, overTimeColor),
        _legend(appLocalizations.bonus, bonusColor),
        _legend(appLocalizations.absent, absentColor),
        _legend(appLocalizations.reports, reportsColor),
      ],
    );
  }

  Widget _legend(String title, Color color) {
    return Row(
      children: [
        Container(
          width: 8.w,
          height: 8.h,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 5.w),
        Text(
          title,
          style: TextStyle(fontSize: 12.sp, color: Colors.black54),
        ),
      ],
    );
  }
}

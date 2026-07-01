import 'package:flutter/cupertino.dart';
import 'package:smart_salary/l10n/app_localizations.dart';

class OnboardingModel {
  final String title;
  final String description;
  final String imagePath;

  const OnboardingModel({
    required this.title,
    required this.description,
    required this.imagePath,
  });
}

List<OnboardingModel> getOnboardingData(BuildContext context) {
  AppLocalizations appLocalizations = AppLocalizations.of(context)!;
  return [
    OnboardingModel(
      title: appLocalizations.manageYourSalaryEasily,
      description: appLocalizations
          .track_your_salary_bonuses_overtime_and_deductions_in_one_place,
      imagePath: 'assets/images/onboarding1.png',
    ),
    OnboardingModel(
      title: appLocalizations.trackWorkingHours,
      description: appLocalizations
          .monitor_attendance_overtime_late_arrivals_and_early_departures_with_precision_and_transparency,
      imagePath: 'assets/images/onboarding2.png',
    ),
    OnboardingModel(
      title: appLocalizations.monthlySalaryInsights,
      description: appLocalizations
          .view_salary_history_reports_and_analytics_for_every_month__Stay_informed_about_your_financial_progress,
      imagePath: 'assets/images/onboarding3.png',
    ),
  ];
}

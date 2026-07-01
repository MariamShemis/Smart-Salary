import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @smartSalary.
  ///
  /// In en, this message translates to:
  /// **'Smart Salary'**
  String get smartSalary;

  /// No description provided for @precisionPayroll_FinancialClarity.
  ///
  /// In en, this message translates to:
  /// **'Precision Payroll & Financial Clarity'**
  String get precisionPayroll_FinancialClarity;

  /// No description provided for @iNITIALIZING.
  ///
  /// In en, this message translates to:
  /// **'INITIALIZING'**
  String get iNITIALIZING;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @manageYourSalaryEasily.
  ///
  /// In en, this message translates to:
  /// **'Manage Your Salary Easily.'**
  String get manageYourSalaryEasily;

  /// No description provided for @track_your_salary_bonuses_overtime_and_deductions_in_one_place.
  ///
  /// In en, this message translates to:
  /// **'Track your salary, bonuses, overtime and deductions in one place.'**
  String get track_your_salary_bonuses_overtime_and_deductions_in_one_place;

  /// No description provided for @trackWorkingHours.
  ///
  /// In en, this message translates to:
  /// **'Track Working Hours'**
  String get trackWorkingHours;

  /// No description provided for @monitor_attendance_overtime_late_arrivals_and_early_departures_with_precision_and_transparency.
  ///
  /// In en, this message translates to:
  /// **'Monitor attendance, overtime, late arrivals and early departures with precision and transparency.'**
  String get monitor_attendance_overtime_late_arrivals_and_early_departures_with_precision_and_transparency;

  /// No description provided for @monthlySalaryInsights.
  ///
  /// In en, this message translates to:
  /// **'Monthly Salary Insights'**
  String get monthlySalaryInsights;

  /// No description provided for @view_salary_history_reports_and_analytics_for_every_month__Stay_informed_about_your_financial_progress.
  ///
  /// In en, this message translates to:
  /// **'View salary history, reports and analytics for every month. Stay informed about your financial progress.'**
  String get view_salary_history_reports_and_analytics_for_every_month__Stay_informed_about_your_financial_progress;

  /// No description provided for @precisionPayrollManagement.
  ///
  /// In en, this message translates to:
  /// **'Precision Payroll Management'**
  String get precisionPayrollManagement;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @enterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterYourEmail;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// No description provided for @enterYourName.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get enterYourName;

  /// No description provided for @rememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get rememberMe;

  /// No description provided for @forgetPassword.
  ///
  /// In en, this message translates to:
  /// **'Forget Password'**
  String get forgetPassword;

  /// No description provided for @forget_password_.
  ///
  /// In en, this message translates to:
  /// **'Forget Password ?'**
  String get forget_password_;

  /// No description provided for @orContinueWith.
  ///
  /// In en, this message translates to:
  /// **'Or continue with'**
  String get orContinueWith;

  /// No description provided for @dontHaveAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAnAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @sign_up.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get sign_up;

  /// No description provided for @welcome_.
  ///
  /// In en, this message translates to:
  /// **'Welcome!'**
  String get welcome_;

  /// No description provided for @welcome_back_.
  ///
  /// In en, this message translates to:
  /// **'Welcome back!'**
  String get welcome_back_;

  /// No description provided for @login_with_Google.
  ///
  /// In en, this message translates to:
  /// **'Login with Google'**
  String get login_with_Google;

  /// No description provided for @please_enter_your_email_to_receive_a_confirmation_code_to_set_a_new_password.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email to receive a confirmation code to set a new password'**
  String get please_enter_your_email_to_receive_a_confirmation_code_to_set_a_new_password;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_salary/core/costants/assets_manager.dart';
import 'package:smart_salary/core/costants/color_manager.dart';
import 'package:smart_salary/core/routes/app_routes.dart';
import 'package:smart_salary/core/utils/ui_utils.dart';
import 'package:smart_salary/core/widgets/main_gradient_background.dart';
import 'package:smart_salary/features/auth/data/cubit/auth_cubit.dart';
import 'package:smart_salary/features/verify_email/data/cubit/verify_email_cubit.dart';
import 'package:smart_salary/features/verify_email/data/cubit/verify_email_state.dart';
import 'package:smart_salary/l10n/app_localizations.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({
    super.key,
    this.email,
    this.fromAccountSecurity = false,
  });

  final String? email;
  final bool fromAccountSecurity;

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.fromAccountSecurity) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<VerifyEmailCubit>().sendEmailVerification();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    return BlocConsumer<VerifyEmailCubit, VerifyEmailState>(
      listener: (context, state) {
        if (state is VerifyEmailLoading || state is VerifyEmailChecking) {
          UiUtils.showLoading(context, isDismissible: false);
        } else {
          UiUtils.hideLoading(context);
        }

        if (state is VerifyEmailSent) {
          UiUtils.showSuccess(
            context,
            appLocalizations.verification_email_sent_Please_check_your_inbox,
          );
        }

        if (state is VerifyEmailError) {
          UiUtils.showError(context, state.message);
        }

        if (state is VerifyEmailVerified) {
          if (widget.fromAccountSecurity) {
            Navigator.pop(context, true);
          } else {
            UiUtils.showSuccess(
              context,
              appLocalizations.email_verified_successfully,
            );
            Navigator.pushReplacementNamed(context, AppRoutes.login);
          }
        }
      },
      builder: (context, state) {
        final isBusy = state is VerifyEmailLoading || state is VerifyEmailChecking;

        return MainGradientBackground(
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: [
                IconButton(
                  onPressed: () {
                    if (widget.fromAccountSecurity) {
                      Navigator.pop(context, false);
                    } else {
                      context.read<AuthCubit>().logout();
                      Navigator.pushReplacementNamed(context, AppRoutes.login);
                    }
                  },
                  icon: const Icon(CupertinoIcons.clear),
                ),
              ],
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: REdgeInsets.all(24),
                  child: Column(
                    children: [
                      Image.asset(ImageAssets.verifyEmail, width: 250.w),
                      SizedBox(height: 32.h),
                      Text(
                        appLocalizations.verify_your_email_address,
                        style: Theme.of(context).textTheme.headlineMedium,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        widget.email ?? '',
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          color: ColorManager.primaryColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        '${appLocalizations.congratulations_Your_account_awaits} '
                            '${appLocalizations.verify_your_email_to_continue}',
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 32.h),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isBusy
                              ? null
                              : () {
                            context
                                .read<VerifyEmailCubit>()
                                .checkEmailVerificationManually();
                          },
                          child: Text(appLocalizations.continue_),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: isBusy
                              ? null
                              : () {
                            context
                                .read<VerifyEmailCubit>()
                                .sendEmailVerification();
                          },
                          child: Text(appLocalizations.resend_to_Email),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
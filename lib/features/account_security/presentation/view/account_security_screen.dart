import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_salary/core/routes/app_routes.dart';
import 'package:smart_salary/core/utils/ui_utils.dart';
import 'package:smart_salary/core/widgets/main_gradient_background.dart';
import 'package:smart_salary/features/account_security/data/cubit/account_security_cubit.dart';
import 'package:smart_salary/features/account_security/data/cubit/account_security_state.dart';
import 'package:smart_salary/features/account_security/presentation/widgets/account_info_card.dart';
import 'package:smart_salary/features/account_security/presentation/widgets/change_password_bottom_sheet.dart';
import 'package:smart_salary/features/account_security/presentation/widgets/delete_account_dialog.dart';
import 'package:smart_salary/features/account_security/presentation/widgets/security_tile.dart';
import 'package:smart_salary/l10n/app_localizations.dart';

class AccountSecurityScreen extends StatefulWidget {
  const AccountSecurityScreen({super.key});

  @override
  State<AccountSecurityScreen> createState() => _AccountSecurityScreenState();
}

class _AccountSecurityScreenState extends State<AccountSecurityScreen> {
  @override
  void initState() {
    super.initState();

    context.read<AccountSecurityCubit>().reloadUser();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    final cubit = context.read<AccountSecurityCubit>();
    return MainGradientBackground(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios),
          ),
          title: Text(appLocalizations.account_Security),
        ),
        body: BlocConsumer<AccountSecurityCubit, AccountSecurityState>(
          listener: (context, state) {
            if (state is ChangePasswordLoading) {
              UiUtils.showLoading(context, isDismissible: false);
            }
            if (state is DeleteAccountLoading) {
              UiUtils.showLoading(context, isDismissible: false);
            }
      
            if (state is ChangePasswordSuccess) {
              UiUtils.hideLoading(context);
              Navigator.pop(context);
              UiUtils.showToast(appLocalizations.password_changed_successfully);
            }
      
            if (state is ChangePasswordError) {
              UiUtils.hideLoading(context);
              UiUtils.showError(context, state.message);
            }
      
            if (state is DeleteAccountSuccess) {
              UiUtils.hideLoading(context);
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.login,
                    (_) => false,
              );
              UiUtils.showToast(appLocalizations.account_deleted_successfully);
            }
            if (state is DeleteAccountError) {
              UiUtils.hideLoading(context);
              UiUtils.showError(context, state.message);
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(20.w),
              child: Column(
                children: [
                  AccountInfoCard(
                    email: cubit.email,
                    isVerified: cubit.currentUser?.emailVerified ?? false,
                  ),
                  SizedBox(height: 24.h),
                  if (!cubit.currentUser!.emailVerified)
                    SecurityTile(
                      icon: Icons.mark_email_unread_outlined,
                      title: appLocalizations.verifyEmail,
                      subtitle: appLocalizations.send_verification_email,
                      onTap: () async {
                        await cubit.sendVerificationEmail();
      
                        if (!context.mounted) return;
      
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text("Verify your email"),
                            content: const Text(
                              "We've sent a verification email to your inbox.\n\n"
                                  "Open the email and click the verification link, then press Refresh.",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("OK"),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  SizedBox(height: 24.h),
                  if (cubit.isEmailAccount)
                    SecurityTile(
                      icon: Icons.lock_outline_rounded,
                      title: appLocalizations.changePassword,
                      subtitle: appLocalizations.update_your_account_password,
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => BlocProvider.value(
                            value: cubit,
                            child: const ChangePasswordBottomSheet(),
                          ),
                        );
                      },
                    ),
      
                  if (cubit.isEmailAccount) SizedBox(height: 16.h),
      
                  SecurityTile(
                    icon: Icons.delete_outline_rounded,
                    title: appLocalizations.deleteAccount,
                    subtitle: appLocalizations.permanently_delete_your_account,
                    color: Colors.red,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => BlocProvider.value(
                          value: cubit,
                          child: const DeleteAccountDialog(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

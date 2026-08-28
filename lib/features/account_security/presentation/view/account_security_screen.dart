import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_salary/core/routes/app_routes.dart';
import 'package:smart_salary/core/session_service/biometric_service.dart';
import 'package:smart_salary/core/utils/ui_utils.dart';
import 'package:smart_salary/core/widgets/main_gradient_background.dart';
import 'package:smart_salary/features/account_security/data/cubit/account_security_cubit.dart';
import 'package:smart_salary/features/account_security/data/cubit/account_security_state.dart';
import 'package:smart_salary/features/account_security/presentation/widgets/account_info_card.dart';
import 'package:smart_salary/features/account_security/presentation/widgets/change_password_bottom_sheet.dart';
import 'package:smart_salary/features/account_security/presentation/widgets/delete_account_dialog.dart';
import 'package:smart_salary/features/account_security/presentation/widgets/security_switch_tile.dart';
import 'package:smart_salary/features/account_security/presentation/widgets/security_tile.dart';
import 'package:smart_salary/l10n/app_localizations.dart';

class AccountSecurityScreen extends StatefulWidget {
  const AccountSecurityScreen({super.key});

  @override
  State<AccountSecurityScreen> createState() => _AccountSecurityScreenState();
}

class _AccountSecurityScreenState extends State<AccountSecurityScreen> {
  bool biometricEnabled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadBiometric();
    });
    context.read<AccountSecurityCubit>().reloadUser();
  }

  Future<void> loadBiometric() async {
    final isEnabled = await context
        .read<AccountSecurityCubit>()
        .isBiometricEnabled();
    if (mounted) {
      setState(() {
        biometricEnabled = isEnabled;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    final cubit = context.read<AccountSecurityCubit>();
    return BlocListener<AccountSecurityCubit, AccountSecurityState>(
      listener: (context, state) {
        if (state is ChangePasswordLoading || state is DeleteAccountLoading) {
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
      child: MainGradientBackground(
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
          body: BlocBuilder<AccountSecurityCubit, AccountSecurityState>(
            builder: (context, state) {
              final isVerified = cubit.isEmailVerified;
              return SingleChildScrollView(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  children: [
                    AccountInfoCard(email: cubit.email, isVerified: isVerified),
                    SizedBox(height: 24.h),
                    SecuritySwitchTile(
                      icon: Icons.fingerprint,
                      title: appLocalizations.fingerprintLogin,
                      subtitle:
                          appLocalizations.secure_access_with_your_fingerprint,
                      value: biometricEnabled,
                      onChanged: (value) async {
                        if (value) {
                          final success = await BiometricService()
                              .authenticate();
                          if (!success) return;
                          await cubit.enableBiometric();

                          if (mounted) {
                            setState(() {
                              biometricEnabled = true;
                            });
                          }
                        } else {
                          await cubit.disableBiometric();

                          if (mounted) {
                            setState(() {
                              biometricEnabled = false;
                            });
                          }
                        }
                      },
                    ),
                    SizedBox(height: 24.h),
                    if (!isVerified && cubit.isEmailAccount) ...[
                      SecurityTile(
                        icon: Icons.email_outlined,
                        title: appLocalizations.verifyEmail,
                        subtitle: appLocalizations
                            .send_a_verification_email_to_your_email_address,
                        onTap: () async {
                          final result = await Navigator.pushNamed(
                            context,
                            AppRoutes.verifyEmail,
                            arguments: {
                              'email': cubit.email,
                              'fromAccountSecurity': true,
                            },
                          );
                          if (result == true && context.mounted) {
                            await cubit.reloadUser();
                            setState(() {});
                            UiUtils.showSuccess(
                              context,
                              appLocalizations.email_verified_successfully,
                            );
                          }
                        },
                      ),
                      SizedBox(height: 24.h),
                    ],
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
                      subtitle:
                          appLocalizations.permanently_delete_your_account,
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
      ),
    );
  }
}

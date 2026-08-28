import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_salary/core/costants/color_manager.dart';
import 'package:smart_salary/core/utils/validators/app_validators.dart';
import 'package:smart_salary/features/account_security/data/cubit/account_security_cubit.dart';
import 'package:smart_salary/features/account_security/presentation/widgets/password_text_field.dart';
import 'package:smart_salary/l10n/app_localizations.dart';

class DeleteAccountDialog extends StatefulWidget {
  const DeleteAccountDialog({super.key});

  @override
  State<DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<DeleteAccountDialog> {
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
    final cubit = context.read<AccountSecurityCubit>();

    return AlertDialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      icon: Icon(
        Icons.delete_forever_rounded,
        size: 40.r,
        color: ColorManager.red,
      ),
      title: Text(appLocalizations.deleteAccount, textAlign: TextAlign.center),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              cubit.isEmailAccount
                  ? appLocalizations
                        .this_action_is_permanent_Enter_your_password_to_continue
                  : appLocalizations.permanently_delete_your_account,
              textAlign: TextAlign.center,
            ),
            if (cubit.isEmailAccount) ...[
              SizedBox(height: 16.h),
              Form(
                key: formKey,
                child: PasswordTextField(
                  controller: passwordController,
                  label: appLocalizations.currentPassword,
                  validator: (value) =>
                      AppValidators.validatePassword(value, context),
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(appLocalizations.cancel),
        ),
        TextButton(
          onPressed: () {
            FocusScope.of(context).unfocus();

            if (cubit.isEmailAccount) {
              if (!formKey.currentState!.validate()) return;
            }
            Navigator.pop(context);

            cubit.deleteAccount(
              currentPassword: passwordController.text.trim(),
              context: context,
            );
          },
          child: Text(
            appLocalizations.delete,
            style: TextStyle(color: ColorManager.red),
          ),
        ),
      ],
    );
  }
}

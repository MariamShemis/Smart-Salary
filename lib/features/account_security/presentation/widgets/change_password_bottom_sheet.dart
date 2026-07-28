import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_salary/core/utils/validators/app_validators.dart';
import 'package:smart_salary/features/account_security/data/cubit/account_security_cubit.dart';
import 'package:smart_salary/features/account_security/data/cubit/account_security_state.dart';
import 'package:smart_salary/features/account_security/presentation/widgets/password_text_field.dart';
import 'package:smart_salary/l10n/app_localizations.dart';

class ChangePasswordBottomSheet extends StatefulWidget {
  const ChangePasswordBottomSheet({super.key});

  @override
  State<ChangePasswordBottomSheet> createState() =>
      _ChangePasswordBottomSheetState();
}

class _ChangePasswordBottomSheetState extends State<ChangePasswordBottomSheet> {
  final currentController = TextEditingController();
  final newController = TextEditingController();
  final confirmController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    return Container(
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        top: 24.h,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60.w,
              height: 5.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              appLocalizations.changePassword,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 25.h),
            PasswordTextField(
              controller: currentController,
              label: appLocalizations.currentPassword,
              validator: (value) =>
                  AppValidators.validatePassword(value, context),
            ),

            SizedBox(height: 18.h),

            PasswordTextField(
              controller: newController,
              label: appLocalizations.newPassword,
              validator: (value) =>
                  AppValidators.validatePassword(value, context),
            ),

            SizedBox(height: 18.h),

            PasswordTextField(
              controller: confirmController,
              label: appLocalizations.confirmPassword,
              validator: (value) => AppValidators.validateConfirmPassword(
                value,
                newController.text,
                context,
              ),
            ),
            SizedBox(height: 30.h),
            BlocBuilder<AccountSecurityCubit, AccountSecurityState>(
              builder: (context, state) {
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();

                      if (!formKey.currentState!.validate()) return;

                      context.read<AccountSecurityCubit>().changePassword(
                        currentPassword: currentController.text.trim(),
                        newPassword: newController.text.trim(),
                      );
                    },
                    child: Text(appLocalizations.updatePassword),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

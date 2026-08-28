import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_salary/core/costants/assets_manager.dart';
import 'package:smart_salary/core/costants/color_manager.dart';
import 'package:smart_salary/core/routes/app_routes.dart';
import 'package:smart_salary/core/utils/ui_utils.dart';
import 'package:smart_salary/core/utils/validators/app_validators.dart';
import 'package:smart_salary/core/widgets/custom_auth_text_form_field.dart';
import 'package:smart_salary/core/widgets/main_gradient_background.dart';
import 'package:smart_salary/features/auth/data/cubit/auth_cubit.dart';
import 'package:smart_salary/features/auth/data/cubit/auth_state.dart';
import 'package:smart_salary/features/auth/data/model/register_request.dart';
import 'package:smart_salary/l10n/app_localizations.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is RegisterLoading) {
          UiUtils.showLoading(context, isDismissible: false);
        }
        // if (state is RegisterSuccess) {
        //   UiUtils.hideLoading(context);
        //   UiUtils.showToast(appLocalizations.account_created_successfully);
        //   Navigator.pop(context);
        // }
        if (state is RegisterSuccess) {
          UiUtils.hideLoading(context);

          Navigator.pushReplacementNamed(
            context,
            AppRoutes.verifyEmail,
            arguments: {
              'email': _emailController.text,
              'fromAccountSecurity': false,
            },
          );
        }
        if (state is RegisterError) {
          UiUtils.hideLoading(context);
          UiUtils.showError(context, state.message);
        }
      },
      builder: (context, state) {
        return MainGradientBackground(
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: ColorManager.primaryColor,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                appLocalizations.sign_up,
                style: TextStyle(
                  color: ColorManager.primaryColor,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
            ),
            body: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: REdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 16.0,
                  ),
                  child: Container(
                    padding: REdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 32.0,
                    ),
                    decoration: BoxDecoration(
                      color: ColorManager.white,
                      borderRadius: BorderRadius.circular(28.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 20.r,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            ImageAssets.logoApp,
                            width: 80.w,
                            height: 80.h,
                          ),
                          //LogoApp(width: 65.w, height: 65.h, size: 43),
                          SizedBox(height: 16.h),
                          Text(
                            appLocalizations.smartSalary,
                            style: TextStyle(
                              fontSize: 26.sp,
                              fontWeight: FontWeight.bold,
                              color: ColorManager.primaryColor,
                            ),
                          ),
                          SizedBox(height: 25.h),
                          CustomAuthTextFormField(
                            controller: _nameController,
                            labelText: appLocalizations.name,
                            hintText: appLocalizations.enterYourName,
                            keyboardType: TextInputType.name,
                            validator: (value) =>
                                AppValidators.validateName(value, context),
                          ),
                          SizedBox(height: 20.h),
                          CustomAuthTextFormField(
                            controller: _emailController,
                            labelText: appLocalizations.email,
                            hintText: appLocalizations.enterYourEmail,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) =>
                                AppValidators.validateEmail(value, context),
                          ),
                          SizedBox(height: 20.h),
                          CustomAuthTextFormField(
                            controller: _phoneController,
                            labelText: appLocalizations.phoneNumber,
                            hintText: appLocalizations.enterYourPhoneNumber,
                            keyboardType: TextInputType.phone,
                            validator: (value) =>
                                AppValidators.validatePhone(value, context),
                          ),
                          SizedBox(height: 20.h),
                          CustomAuthTextFormField(
                            controller: _passwordController,
                            labelText: appLocalizations.password,
                            hintText: '••••••••',
                            keyboardType: TextInputType.visiblePassword,
                            isPassword: true,
                            validator: (value) =>
                                AppValidators.validatePassword(value, context),
                          ),
                          SizedBox(height: 20.h),
                          CustomAuthTextFormField(
                            controller: _confirmPasswordController,
                            labelText: appLocalizations.confirmPassword,
                            hintText: '••••••••',
                            keyboardType: TextInputType.visiblePassword,
                            isPassword: true,
                            validator: (value) =>
                                AppValidators.validateConfirmPassword(
                                  value,
                                  _passwordController.text,
                                  context,
                                ),
                          ),
                          SizedBox(height: 24.h),
                          ElevatedButton(
                            onPressed: _addRegister,
                            child: Text(appLocalizations.sign_up),
                          ),
                          // SizedBox(height: 24.h),
                          // Row(
                          //   children: [
                          //     const Expanded(
                          //       child: Divider(
                          //         color: Color(0xFFE5E9E7),
                          //         thickness: 1,
                          //       ),
                          //     ),
                          //     Padding(
                          //       padding: REdgeInsets.symmetric(
                          //         horizontal: 16.0,
                          //       ),
                          //       child: Text(
                          //         appLocalizations.orContinueWith,
                          //         style: TextStyle(
                          //           fontSize: 11.sp,
                          //           fontWeight: FontWeight.bold,
                          //           color: ColorManager.greyDark,
                          //           letterSpacing: 0.5,
                          //         ),
                          //       ),
                          //     ),
                          //     const Expanded(
                          //       child: Divider(
                          //         color: Color(0xFFE5E9E7),
                          //         thickness: 1,
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          // SizedBox(height: 24.h),
                          // Row(
                          //   children: [
                          //     Expanded(
                          //       child: CustomLoginOutlineBorder(
                          //         onPressed: () {},
                          //       ),
                          //     ),
                          //     SizedBox(width: 16.w),
                          //     Expanded(
                          //       child: CustomLoginOutlineBorder(
                          //         onPressed: () {},
                          //         isGoogle: false,
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          SizedBox(height: 24.h),
                          Center(
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text:
                                        "${appLocalizations.alreadyHaveAccount}  ",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: ColorManager.greyDark,
                                    ),
                                  ),
                                  WidgetSpan(
                                    child: GestureDetector(
                                      onTap: () => Navigator.pop(context),
                                      child: Text(
                                        appLocalizations.login,
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.bold,
                                          color: ColorManager.primaryColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _addRegister() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthCubit>().register(
      RegisterRequest(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        password: _passwordController.text,
      ),
      context,
    );
  }
}

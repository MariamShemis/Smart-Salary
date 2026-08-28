import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_salary/core/costants/assets_manager.dart';
import 'package:smart_salary/core/costants/color_manager.dart';
import 'package:smart_salary/core/routes/app_routes.dart';
import 'package:smart_salary/core/session_service/biometric_service.dart';
import 'package:smart_salary/core/utils/ui_utils.dart';
import 'package:smart_salary/core/utils/validators/app_validators.dart';
import 'package:smart_salary/core/widgets/custom_auth_text_form_field.dart';
import 'package:smart_salary/core/widgets/main_gradient_background.dart';
import 'package:smart_salary/features/auth/data/cubit/auth_cubit.dart';
import 'package:smart_salary/features/auth/data/cubit/auth_state.dart';
import 'package:smart_salary/features/auth/data/model/login_request.dart';
import 'package:smart_salary/features/auth/presentation/widgets/custom_login_outline_border.dart';
import 'package:smart_salary/l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final BiometricService _biometric = BiometricService();

  bool rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Future<void> _loginWithFingerprint() async {
  //   final authenticated = await _biometric.authenticate();
  //
  //   if (!authenticated) return;
  //
  //   final email = await SecureStorageService.getEmail();
  //   final password = await SecureStorageService.getPassword();
  //
  //   if (email == null || password == null) {
  //     UiUtils.showError(context, "Please login once using email.");
  //     return;
  //   }
  //
  //   try {
  //     await FirebaseServices.login(
  //       LoginRequest(
  //         email: email,
  //         password: password,
  //       ),
  //     );
  //
  //     Navigator.pushReplacementNamed(
  //       context,
  //       AppRoutes.mainLayout,
  //     );
  //   } catch (e) {
  //     UiUtils.showError(context, "Login failed");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is LoginLoading) {
          UiUtils.showLoading(context, isDismissible: false);
        }
        if (state is LoginSuccess) {
          UiUtils.hideLoading(context);
          UiUtils.showToast(
            "${appLocalizations.welcome} ${state.user.name}, ${appLocalizations.login_successfully}.",
          );
          Navigator.pushReplacementNamed(context, AppRoutes.mainLayout);
        }
        if (state is LoginError) {
          UiUtils.hideLoading(context);
          UiUtils.showError(context, state.message);
        }
      },
      builder: (context, state) {
        return MainGradientBackground(
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 5,
              title: Text(
                appLocalizations.login,
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
                            controller: _emailController,
                            labelText: appLocalizations.email,
                            hintText: appLocalizations.enterYourEmail,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) =>
                                AppValidators.validateEmail(value, context),
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
                          SizedBox(height: 16.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: Checkbox(
                                        value: rememberMe,
                                        onChanged: (value) {
                                          setState(() {
                                            rememberMe = value ?? false;
                                          });
                                        },
                                        activeColor: ColorManager.primaryColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 4.w),
                                    Text(
                                      appLocalizations.rememberMe,
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: ColorManager.greyDark,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      AppRoutes.forgetPassword,
                                    );
                                  },
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: Size.zero,
                                  ),
                                  child: Text(
                                    appLocalizations.forget_password_,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: ColorManager.primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 18.h),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _login,
                                  child: Text(appLocalizations.login),
                                ),
                              ),
                              SizedBox(width: 12.w),
                              SizedBox(
                                width: 56.w,
                                height: 56.h,
                                child: ElevatedButton(
                                  onPressed: () {
                                    context
                                        .read<AuthCubit>()
                                        .loginWithBiometric(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16.r),
                                    ),
                                    padding: EdgeInsets.zero,
                                  ),
                                  child: Icon(Icons.fingerprint, size: 28.sp),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 24.h),
                          Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: Color(0xFFE5E9E7),
                                  thickness: 1,
                                ),
                              ),
                              Padding(
                                padding: REdgeInsets.symmetric(
                                  horizontal: 16.0,
                                ),
                                child: Text(
                                  appLocalizations.orContinueWith,
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.bold,
                                    color: ColorManager.greyDark,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  color: Color(0xFFE5E9E7),
                                  thickness: 1,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 24.h),
                          CustomLoginOutlineBorder(
                            onPressed: () {
                              context.read<AuthCubit>().signInWithGoogle(
                                context,
                              );
                            },
                            isGoogleLogin: true,
                            isGoogle: false,
                          ),
                          SizedBox(height: 24.h),
                          Center(
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text:
                                        "${appLocalizations.dontHaveAnAccount}  ",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: ColorManager.greyDark,
                                    ),
                                  ),
                                  WidgetSpan(
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(
                                          context,
                                          AppRoutes.register,
                                        );
                                      },
                                      child: Text(
                                        appLocalizations.register,
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

  void _login() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    context.read<AuthCubit>().login(
      LoginRequest(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      ),
      context,
    );
  }
}

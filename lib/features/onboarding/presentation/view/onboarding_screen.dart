import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_salary/core/costants/color_manager.dart';
import 'package:smart_salary/core/routes/app_routes.dart';
import 'package:smart_salary/core/session_service/session_service.dart';
import 'package:smart_salary/core/widgets/main_gradient_background.dart';
import 'package:smart_salary/features/onboarding/data/cubit/onboarding_cubit.dart';
import 'package:smart_salary/features/onboarding/data/cubit/onboarding_state.dart';
import 'package:smart_salary/features/onboarding/data/model/on_boarding_model.dart';
import 'package:smart_salary/l10n/app_localizations.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    return BlocProvider(
      create: (_) => OnboardingCubit(),
      child: MainGradientBackground(
        child: Scaffold(
          body: SafeArea(
            child: BlocConsumer<OnboardingCubit, OnboardingState>(
              listenWhen: (previous, current) {
                return previous.currentPageIndex != current.currentPageIndex;
              },
              listener: (context, state) {
                if (_pageController.hasClients &&
                    _pageController.page?.round() != state.currentPageIndex) {
                  _pageController.animateToPage(
                    state.currentPageIndex,
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                  );
                }
              },
              builder: (context, state) {
                final cubit = context.read<OnboardingCubit>();
                final isLastPage =
                    state.currentPageIndex ==
                    getOnboardingData(context).length - 1;
                return Column(
                  children: [
                    Padding(
                      padding: REdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 8.0,
                      ),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: isLastPage
                            ? SizedBox(height: 40.h)
                            : TextButton(
                                onPressed: () {
                                  cubit.updatePageIndex(
                                    getOnboardingData(context).length - 1,
                                  );
                                },
                                child: Text(
                                  appLocalizations.skip,
                                  style: TextStyle(
                                    color: ColorManager.greyDark,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: getOnboardingData(context).length,
                        onPageChanged: (index) => cubit.updatePageIndex(index),
                        itemBuilder: (context, index) {
                          final item = getOnboardingData(context)[index];
                          return Padding(
                            padding: REdgeInsets.symmetric(horizontal: 32.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    child: Image.asset(
                                      item.imagePath,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 40.h),
                                Text(
                                  item.title,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 26.sp,
                                    fontWeight: FontWeight.bold,
                                    color: ColorManager.black,
                                  ),
                                ),
                                SizedBox(height: 16.h),
                                Text(
                                  item.description,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: ColorManager.greyDark,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SmoothPageIndicator(
                            controller: _pageController,
                            count: getOnboardingData(context).length,
                            effect: const ExpandingDotsEffect(
                              activeDotColor: ColorManager.primaryColor,
                              dotColor: ColorManager.background,
                              dotHeight: 6,
                              dotWidth: 6,
                              expansionFactor: 4,
                              spacing: 8,
                            ),
                          ),
                          SizedBox(height: 32.h),
                          Padding(
                            padding: REdgeInsets.symmetric(horizontal: 32.0),
                            child: ElevatedButton(
                              onPressed: () async {
                                print("Pressed");

                                if (isLastPage) {
                                  await SessionService.completeOnboarding();
                                  print("Saved");

                                  Navigator.pushReplacementNamed(
                                    context,
                                    AppRoutes.login,
                                  );
                                } else {
                                  cubit.nextPage(getOnboardingData(context).length);
                                }
                              },
                              style: Theme.of(
                                context,
                              ).elevatedButtonTheme.style,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    isLastPage
                                        ? appLocalizations.getStarted
                                        : appLocalizations.next,
                                  ),
                                  SizedBox(width: 8.w),
                                  if (!isLastPage)
                                    Icon(Icons.arrow_forward, size: 18.sp),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

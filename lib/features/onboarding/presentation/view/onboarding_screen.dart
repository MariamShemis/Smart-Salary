import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_salary/core/costants/color_manager.dart';
import 'package:smart_salary/core/routes/app_routes.dart';
import 'package:smart_salary/core/widgets/main_gradient_background.dart';
import 'package:smart_salary/features/onboarding/data/cubit/onboarding_cubit.dart';
import 'package:smart_salary/features/onboarding/data/cubit/onboarding_state.dart';
import 'package:smart_salary/features/onboarding/data/model/on_boarding_model.dart';
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
                    state.currentPageIndex == onboardingData.length - 1;
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 8.0,
                      ),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: isLastPage
                            ? const SizedBox(height: 40)
                            : TextButton(
                                onPressed: () {
                                  cubit.updatePageIndex(
                                    onboardingData.length - 1,
                                  );
                                },
                                child: const Text(
                                  'Skip',
                                  style: TextStyle(
                                    color: ColorManager.greyDark,
                                    fontSize: 16,
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
                        itemCount: onboardingData.length,
                        onPageChanged: (index) => cubit.updatePageIndex(index),
                        itemBuilder: (context, index) {
                          final item = onboardingData[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32.0,
                            ),
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
                                const SizedBox(height: 40),
                                Text(
                                  item.title,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: ColorManager.black,
                                    height: 1.3,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  item.description,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: ColorManager.greyDark,
                                    height: 1.5,
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
                            count: onboardingData.length,
                            effect: const ExpandingDotsEffect(
                              activeDotColor: ColorManager.primaryColor,
                              dotColor: ColorManager.background,
                              dotHeight: 6,
                              dotWidth: 6,
                              expansionFactor: 4,
                              spacing: 8,
                            ),
                          ),
                          const SizedBox(height: 32),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32.0,
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                if (isLastPage) {
                                  Navigator.pushReplacementNamed(context, AppRoutes.login);
                                } else {
                                  cubit.nextPage(onboardingData.length);
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
                                        ? 'Get Started'
                                        : (state.currentPageIndex == 0
                                              ? 'Next'
                                              : 'Next Step'),
                                  ),
                                  const SizedBox(width: 8),
                                  if (!isLastPage)
                                    const Icon(Icons.arrow_forward, size: 18),
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

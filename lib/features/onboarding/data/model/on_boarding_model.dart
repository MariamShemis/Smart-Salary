class OnboardingModel {
  final String title;
  final String description;
  final String imagePath;

  const OnboardingModel({
    required this.title,
    required this.description,
    required this.imagePath,
  });
}

const List<OnboardingModel> onboardingData = [
  OnboardingModel(
    title: 'Manage Your Salary Easily.',
    description: 'Track your salary, bonuses, overtime and deductions in one place.',
    imagePath: 'assets/images/onboarding1.png',
  ),
  OnboardingModel(
    title: 'Track Working Hours',
    description: 'Monitor attendance, overtime, late arrivals and early departures with precision and transparency.',
    imagePath: 'assets/images/onboarding2.png',
  ),
  OnboardingModel(
    title: 'Monthly Salary Insights',
    description: 'View salary history, reports and analytics for every month. Stay informed about your financial progress.',
    imagePath: 'assets/images/onboarding3.png',
  ),
];
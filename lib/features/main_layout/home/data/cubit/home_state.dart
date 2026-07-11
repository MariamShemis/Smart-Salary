abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final DateTime month;
  final Map<String, double> homeData;

  HomeLoaded({
    required this.month,
    required this.homeData,
  });
}
import 'package:smart_salary/features/auth/data/model/user_model.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final DateTime month;
  final Map<String, double> homeData;
  final UserModel user;

  HomeLoaded({
    required this.month,
    required this.homeData,
    required this.user,
  });
}

class HomeError extends HomeState {
  final String message;

  HomeError(this.message);
}

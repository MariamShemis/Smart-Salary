import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'salary_state.dart';

class SalaryCubit extends Cubit<SalaryState> {
  SalaryCubit() : super(SalaryInitial());
}

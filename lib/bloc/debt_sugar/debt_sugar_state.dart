part of 'debt_sugar_bloc.dart';

@immutable
abstract class DebtSugarState {}

class DebtSugarInitial extends DebtSugarState {}

class DebtSugarSuccess extends DebtSugarState {
  final List<DebtSugarModel> debtModel;
  DebtSugarSuccess({required this.debtModel});
}

class DebtSugarLoading extends DebtSugarState {}

class DebtSugarError extends DebtSugarState {}

class RequestDebtSuccess extends DebtSugarState {
  final int id;
  RequestDebtSuccess({required this.id});
}

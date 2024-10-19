part of 'finance_bloc.dart';

@immutable
abstract class FinanceState {}

class FinanceInitial extends FinanceState {}

class FinanceLoading extends FinanceState {}

class ShowFinanceSucces extends FinanceState {
  final FinanceModel finance;
  ShowFinanceSucces({required this.finance});
}

class FinanceSuccess extends FinanceState {
  final List<FinanceModel> finance;
  FinanceSuccess({required this.finance});
}

class FinanceError extends FinanceState {}

class RequestFinanceSucces extends FinanceState {
  final int id;
  RequestFinanceSucces({required this.id});
}

part of 'finance_bloc.dart';

@immutable
abstract class FinanceEvent {}

class GetFinance extends FinanceEvent {
  final Map<String, dynamic> date;
  GetFinance({required this.date});
}

class ShowFinance extends FinanceEvent {}

class CreateFinance extends FinanceEvent {
  final FinanceModel finance;
  CreateFinance({required this.finance});
}

class UpdateFinance extends FinanceEvent {
  final FinanceModel finance;
  UpdateFinance({required this.finance});
}

class DeleteFinance extends FinanceEvent {
  final int id;
  DeleteFinance({required this.id});
}

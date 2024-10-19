part of 'debt_sugar_bloc.dart';

@immutable
abstract class DebtSugarEvent {}

class GetDebtSugar extends DebtSugarEvent {}

class SearchDebtSugar extends DebtSugarEvent {
  final String nama;
  SearchDebtSugar({required this.nama});
}

class CreateDebtSugar extends DebtSugarEvent {
  final DebtSugarModel debtSugarModel;
  CreateDebtSugar({required this.debtSugarModel});
}

class UpdateDebtSugar extends DebtSugarEvent {
  final DebtSugarModel debtSugarModel;
  UpdateDebtSugar({required this.debtSugarModel});
}

class DeleteDebtSugar extends DebtSugarEvent {
  final int id;
  DeleteDebtSugar({required this.id});
}

class CreateDebtSugarDetail extends DebtSugarEvent {
  final DebtSugarModel debtSugarModel;
  CreateDebtSugarDetail({required this.debtSugarModel});
}

part of 'bill_bloc.dart';

@immutable
abstract class BillState {}

class BillInitial extends BillState {}

class BillLoading extends BillState {}

class BillSuccess extends BillState {
  final List<BillModel> bill;
  BillSuccess({required this.bill});
}

class BillError extends BillState {}

class RequestBillSuccess extends BillState {
  final int id;
  RequestBillSuccess({required this.id});
}

class RequestAddSuccess extends BillState {
  final BillModel billModel;
  RequestAddSuccess({required this.billModel});
}

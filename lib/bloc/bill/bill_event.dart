part of 'bill_bloc.dart';

@immutable
abstract class BillEvent {}

class GetBill extends BillEvent {}

class CreateBill extends BillEvent {
  final BillModel billModel;
  CreateBill({required this.billModel});
}

class UpdateBill extends BillEvent {
  final BillModel billModel;
  UpdateBill({required this.billModel});
}

class DeleteBill extends BillEvent {
  final int id;
  DeleteBill({required this.id});
}

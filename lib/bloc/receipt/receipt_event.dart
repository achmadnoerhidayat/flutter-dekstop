part of 'receipt_bloc.dart';

@immutable
abstract class ReceiptEvent {}

class GetReceipt extends ReceiptEvent {}

class CreateReceipt extends ReceiptEvent {
  final ReceiptModel receiptModel;
  CreateReceipt({required this.receiptModel});
}

class UpdateReceipt extends ReceiptEvent {
  final ReceiptModel receiptModel;
  UpdateReceipt({required this.receiptModel});
}

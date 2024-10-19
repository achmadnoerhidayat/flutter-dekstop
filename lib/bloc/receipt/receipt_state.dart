part of 'receipt_bloc.dart';

@immutable
abstract class ReceiptState {}

class ReceiptInitial extends ReceiptState {}

class ReceiptLoading extends ReceiptState {}

class ReceiptSuccess extends ReceiptState {
  final ReceiptModel receiptModel;
  ReceiptSuccess({required this.receiptModel});
}

class ReceiptError extends ReceiptState {}

class RequestReceiptSuccess extends ReceiptState {}

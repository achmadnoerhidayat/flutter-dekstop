// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:kasir_dekstop/models/receipt_model.dart';
import 'package:kasir_dekstop/service/product_helper.dart';
import 'package:meta/meta.dart';

part 'receipt_event.dart';
part 'receipt_state.dart';

class ReceiptBloc extends Bloc<ReceiptEvent, ReceiptState> {
  ProductHelper productHelper = ProductHelper();
  ReceiptBloc() : super(ReceiptInitial()) {
    on<GetReceipt>((event, emit) async {
      emit(ReceiptLoading());
      final response = await productHelper.getReceipt();
      if (response != null) {
        emit(ReceiptSuccess(receiptModel: response));
      } else {
        emit(ReceiptError());
      }
    });
    on<CreateReceipt>((event, emit) async {
      emit(ReceiptLoading());
      final response = await productHelper.insertReceipt(event.receiptModel);
      if (response > 0) {
        emit(RequestReceiptSuccess());
      } else {
        emit(ReceiptError());
      }
    });
    on<UpdateReceipt>((event, emit) async {
      emit(ReceiptLoading());
      final response = await productHelper.updateReceipt(event.receiptModel);
      if (response > 0) {
        emit(RequestReceiptSuccess());
      } else {
        emit(ReceiptError());
      }
    });
  }
}

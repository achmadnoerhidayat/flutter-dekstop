// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:kasir_dekstop/models/finance_model.dart';
import 'package:kasir_dekstop/service/product_helper.dart';
import 'package:meta/meta.dart';

part 'finance_event.dart';
part 'finance_state.dart';

class FinanceBloc extends Bloc<FinanceEvent, FinanceState> {
  ProductHelper productHelper = ProductHelper();
  FinanceBloc() : super(FinanceInitial()) {
    on<GetFinance>((event, emit) async {
      emit(FinanceLoading());
      final response = await productHelper.getFinance(event.date);
      if (response!.isNotEmpty) {
        emit(FinanceSuccess(finance: response));
      } else {
        emit(FinanceError());
      }
    });
    on<CreateFinance>((event, emit) async {
      emit(FinanceLoading());
      final response = await productHelper.insertFinance(event.finance);
      emit(RequestFinanceSucces(id: response));
    });
  }
}

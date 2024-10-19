// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:kasir_dekstop/models/debt_sugar_model.dart';
import 'package:kasir_dekstop/service/product_helper.dart';
import 'package:meta/meta.dart';

part 'debt_sugar_event.dart';
part 'debt_sugar_state.dart';

class DebtSugarBloc extends Bloc<DebtSugarEvent, DebtSugarState> {
  ProductHelper productHelper = ProductHelper();
  DebtSugarBloc() : super(DebtSugarInitial()) {
    on<GetDebtSugar>((event, emit) async {
      emit(DebtSugarLoading());
      final response = await productHelper.getDebtSugar();
      if (response.isNotEmpty) {
        emit(DebtSugarSuccess(debtModel: response));
      } else {
        emit(DebtSugarError());
      }
    });
    on<SearchDebtSugar>((event, emit) async {
      emit(DebtSugarLoading());
      final response = await productHelper.getDebtSugarByName(event.nama);
      if (response.isNotEmpty) {
        emit(DebtSugarSuccess(debtModel: response));
      } else {
        emit(DebtSugarError());
      }
    });
    on<CreateDebtSugar>((event, emit) async {
      emit(DebtSugarLoading());
      final response =
          await productHelper.insertDebtSugar(event.debtSugarModel);
      emit(RequestDebtSuccess(id: response));
    });
    on<UpdateDebtSugar>((event, emit) async {
      emit(DebtSugarLoading());
      final response =
          await productHelper.updateDebtSugar(event.debtSugarModel);
      emit(RequestDebtSuccess(id: response));
    });
    on<DeleteDebtSugar>((event, emit) async {
      emit(DebtSugarLoading());
      final response = await productHelper.deleteDebtSugar(event.id);
      emit(RequestDebtSuccess(id: response));
    });
    on<CreateDebtSugarDetail>((event, emit) async {
      emit(DebtSugarLoading());
      final response =
          await productHelper.tambahDebtSugarDetail(event.debtSugarModel);
      emit(RequestDebtSuccess(id: response));
    });
  }
}

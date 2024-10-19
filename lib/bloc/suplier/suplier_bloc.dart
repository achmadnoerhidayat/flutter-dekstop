// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:kasir_dekstop/models/suplier_model.dart';
import 'package:kasir_dekstop/service/product_helper.dart';
import 'package:meta/meta.dart';

part 'suplier_event.dart';
part 'suplier_state.dart';

class SuplierBloc extends Bloc<SuplierEvent, SuplierState> {
  ProductHelper productHelper = ProductHelper();
  SuplierBloc() : super(SuplierInitial()) {
    on<GetSuplier>((event, emit) async {
      emit(SuplierLoading());
      final response = await productHelper.getSuplier();
      if (response!.isNotEmpty) {
        emit(SuplierSuccess(suplier: response));
      } else {
        emit(SuplierError());
      }
    });
    on<GetSuplierName>((event, emit) async {
      emit(SuplierLoading());
      final response = await productHelper.getSuplierName(event.name);
      if (response!.isNotEmpty) {
        emit(SuplierSuccess(suplier: response));
      } else {
        emit(SuplierError());
      }
    });
    on<CreateSuplier>((event, emit) async {
      emit(SuplierLoading());
      final response = await productHelper.insertSuplier(event.suplier);
      if (response > 0) {
        emit(RequestSuplier(id: response));
      } else {
        emit(SuplierError());
      }
    });
    on<UpdateSuplier>((event, emit) async {
      emit(SuplierLoading());
      final response = await productHelper.updateSuplier(event.suplier);
      if (response > 0) {
        emit(RequestSuplier(id: response));
      } else {
        emit(SuplierError());
      }
    });
    on<DeleteSuplier>((event, emit) async {
      emit(SuplierLoading());
      final response = await productHelper.deleteSuplier(event.id);
      if (response > 0) {
        emit(RequestSuplier(id: response));
      } else {
        emit(SuplierError());
      }
    });
  }
}

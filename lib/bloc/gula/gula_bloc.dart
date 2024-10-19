// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:kasir_dekstop/models/gula_model.dart';
import 'package:kasir_dekstop/service/product_helper.dart';
import 'package:meta/meta.dart';

part 'gula_event.dart';
part 'gula_state.dart';

class GulaBloc extends Bloc<GulaEvent, GulaState> {
  final ProductHelper productHelper = ProductHelper();
  GulaBloc() : super(GulaInitial()) {
    on<GetGula>((event, emit) async {
      emit(GulaLoading());
      final response = await productHelper.getGula();
      if (response.isEmpty) {
        emit(GulaError());
      } else {
        emit(GulaSuccess(gula: response));
      }
    });
    on<CreateGula>((event, emit) async {
      emit(GulaLoading());
      final response = await productHelper.insertGula(event.gulaModel);
      emit(RequestGulaSuccess(id: response));
    });
    on<UpdateGula>((event, emit) async {
      emit(GulaLoading());
      final response = await productHelper.updateGula(event.gulaModel);
      emit(RequestGulaSuccess(id: response));
    });
    on<DeleteGula>((event, emit) async {
      emit(GulaLoading());
      final response = await productHelper.deleteGula(event.idGula);
      emit(RequestGulaSuccess(id: response));
    });
  }
}

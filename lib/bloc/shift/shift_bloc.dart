// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:kasir_dekstop/models/shift_model.dart';
import 'package:kasir_dekstop/service/product_helper.dart';
import 'package:meta/meta.dart';

part 'shift_event.dart';
part 'shift_state.dart';

class ShiftBloc extends Bloc<ShiftEvent, ShiftState> {
  ProductHelper productHelper = ProductHelper();
  ShiftBloc() : super(ShiftInitial()) {
    on<GetShiftEvent>((event, emit) async {
      emit(ShiftLoading());
      final response = await productHelper.getShift();
      if (response!.isNotEmpty) {
        emit(ShiftSuccess(shift: response));
      } else {
        emit(ShiftError());
      }
    });
    on<ShowShiftEvent>((event, emit) async {
      emit(ShiftLoading());
      final response = await productHelper.showShift(event.date);
      if (response != null) {
        emit(ShowShiftSuccess(shift: response));
      } else {
        emit(ShiftError());
      }
    });
    on<CreateShiftEvent>((event, emit) async {
      emit(ShiftLoading());
      final response = await productHelper.insertShift(event.shift);
      if (response > 0) {
        emit(RequestShiftSuccess(id: response));
      } else {
        emit(ShiftError());
      }
    });
    on<UpdateShiftEvent>((event, emit) async {
      emit(ShiftLoading());
      final response = await productHelper.updateShift(event.shift);
      if (response > 0) {
        emit(RequestShiftSuccess(id: response));
      } else {
        emit(ShiftError());
      }
    });
  }
}

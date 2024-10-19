// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:kasir_dekstop/models/debt_watch_model.dart';
import 'package:kasir_dekstop/service/product_helper.dart';
import 'package:meta/meta.dart';

part 'deb_watch_event.dart';
part 'deb_watch_state.dart';

class DebWatchBloc extends Bloc<DebWatchEvent, DebWatchState> {
  final ProductHelper productHelper = ProductHelper();
  DebWatchBloc() : super(DebWatchInitial()) {
    on<GetDebtWatch>((event, emit) async {
      emit(DebWatchLoading());
      final response = await productHelper.getDebtWatch();
      emit(DebWatchSuccess(watch: response));
    });
    on<SearchDebtWatch>((event, emit) async {
      emit(DebWatchLoading());
      final response = await productHelper.getDebtWatchByName(event.name);
      emit(DebWatchSuccess(watch: response));
    });
    on<CreateDebtWatch>((event, emit) async {
      emit(DebWatchLoading());
      final response =
          await productHelper.insertDebtWatch(event.debtWatchModel);
      emit(RequestDebWatchSuccess(id: response));
    });
    on<UpdateDebtWatch>((event, emit) async {
      emit(DebWatchLoading());
      final response =
          await productHelper.updateDebtwatch(event.debtWatchModel);
      emit(RequestDebWatchSuccess(id: response));
    });
    on<DeleteDebtWatch>((event, emit) async {
      emit(DebWatchLoading());
      final response = await productHelper.deleteDebtWatch(event.id);
      emit(RequestDebWatchSuccess(id: response));
    });
    on<CreateDebtWatchDetail>((event, emit) async {
      emit(DebWatchLoading());
      final response =
          await productHelper.tambahDebtWatchDetail(event.debtWatchModel);
      emit(RequestDebWatchSuccess(id: response));
    });
  }
}

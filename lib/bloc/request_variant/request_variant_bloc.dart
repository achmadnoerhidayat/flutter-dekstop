// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:kasir_dekstop/models/varian_model.dart';
import 'package:kasir_dekstop/service/product_helper.dart';
import 'package:meta/meta.dart';

part 'request_variant_event.dart';
part 'request_variant_state.dart';

class RequestVariantBloc
    extends Bloc<RequestVariantEvent, RequestVariantState> {
  ProductHelper productHelper;
  RequestVariantBloc(this.productHelper) : super(RequestVariantInitial()) {
    on<GetVarianList>((event, emit) {
      emit(RequestVariantList(formVarian: event.formVarian));
    });
    on<RemoveVarianList>((event, emit) {
      var find = event.formVarian!.firstWhere((it) => it == event.varianModel);
      event.formVarian?.removeAt(event.formVarian!.indexOf(find));
      emit(RequestVariantList(formVarian: event.formVarian!));
    });
    on<CreateVarian>((event, emit) async {
      emit(RequestVarianLoading());
      await productHelper.insertProductVarian(event.formVarian, event.idBarang);
    });
    on<DeleteVarian>((event, emit) async {
      emit(RequestVarianLoading());
      await productHelper.deleteVarian(event.idBarang);
      emit(RequestVariantList(formVarian: event.formVarian!));
    });
  }
}

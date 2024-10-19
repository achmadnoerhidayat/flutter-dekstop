// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:kasir_dekstop/models/promo_model.dart';
import 'package:kasir_dekstop/service/product_helper.dart';
import 'package:meta/meta.dart';

part 'promo_event.dart';
part 'promo_state.dart';

class PromoBloc extends Bloc<PromoEvent, PromoState> {
  final ProductHelper productHelper = ProductHelper();
  PromoBloc() : super(PromoInitial()) {
    on<GetPromo>((event, emit) async {
      emit(PromoLoading());
      var response = await productHelper.getPromo();
      emit(PromoSuccess(promo: response));
    });
    on<CreatePromo>((event, emit) async {
      emit(PromoLoading());
      var response = await productHelper.insertPromo(event.promoModel);
      emit(RequestPromoSuccess(id: response));
    });
    on<UpdatePromo>((event, emit) async {
      emit(PromoLoading());
      var response = await productHelper.updatePromo(event.promoModel);
      emit(RequestPromoSuccess(id: response));
    });
    on<DeletePromo>((event, emit) async {
      emit(PromoLoading());
      var response = await productHelper.deletePromo(event.id);
      emit(RequestPromoSuccess(id: response));
    });
  }
}

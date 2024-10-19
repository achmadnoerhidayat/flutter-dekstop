// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:kasir_dekstop/models/discount_model.dart';
import 'package:kasir_dekstop/service/product_helper.dart';
import 'package:meta/meta.dart';

part 'discount_event.dart';
part 'discount_state.dart';

class DiscountBloc extends Bloc<DiscountEvent, DiscountState> {
  final ProductHelper productHelper = ProductHelper();
  DiscountBloc() : super(DiscountInitial()) {
    on<GetDiscount>((event, emit) async {
      emit(DiscountLoading());
      final response = await productHelper.getDiscountProduct();
      emit(DiscountSuccess(discount: response));
    });
    on<CreateDiscount>((event, emit) async {
      emit(DiscountLoading());
      final response = await productHelper.insertDiscount(event.discountModel);
      emit(RequestDiscountSuccess(id: response));
    });
    on<UpdateDiscount>((event, emit) async {
      emit(DiscountLoading());
      final response = await productHelper.updateDiscount(event.discountModel);
      emit(RequestDiscountSuccess(id: response));
    });
    on<DeleteDiscount>((event, emit) async {
      emit(DiscountLoading());
      final response = await productHelper.deleteDiscount(event.id);
      emit(RequestDiscountSuccess(id: response));
    });
  }
}

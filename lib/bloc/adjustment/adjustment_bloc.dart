// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:kasir_dekstop/models/adjustment_model.dart';
import 'package:kasir_dekstop/models/product_models.dart';
import 'package:kasir_dekstop/service/product_helper.dart';

part 'adjustment_event.dart';
part 'adjustment_state.dart';

class AdjustmentBloc extends Bloc<AdjustmentEvent, AdjustmentState> {
  ProductHelper productHelper = ProductHelper();
  AdjustmentBloc() : super(AdjustmentInitial()) {
    on<GetAdjustment>((event, emit) async {
      emit(AdjustmentLoading());
      final response = await productHelper.getAdjustment();
      if (response!.isNotEmpty) {
        emit(AdjustmentSuccess(adjustment: response));
      } else {
        emit(AdjustmentError());
      }
    });

    on<ShowAdjustmentDetail>((event, emit) async {
      emit(AdjustmentLoading());
      final response = await productHelper.getOrderDetailAdjustment(event.date);
      if (response!.isNotEmpty) {
        int totalAdj = 0;
        int totalItem = 0;
        int totalExpen = 0;
        int totalIncome = 0;
        for (var e in response) {
          int expense = int.parse(e.hargaModal!) * int.parse(e.adjustment!);
          totalAdj = response.length;
          totalItem += int.parse(e.adjustment!);
          totalExpen += expense;
          totalIncome = 0;
        }
        emit(ShowAdjustmentSuccess(
          adjustment: response,
          totalAdj: totalAdj,
          totalItem: totalItem,
          totalExpen: totalExpen,
          totalIncome: totalIncome,
        ));
      } else {
        emit(AdjustmentError());
      }
    });

    on<CreateAdjustment>((event, emit) async {
      emit(AdjustmentLoading());
      final response = await productHelper.insertAdjustment(event.adjustment);
      if (event.adjustment.detail!.isNotEmpty) {
        event.adjustment.detail?.forEach((order) async {
          var request = ProductsModel(
            id: int.parse(order.idProduct!),
            namaBarang: order.product!.namaBarang,
            idCategory: order.product!.idCategory,
            idVarian: order.product!.idVarian,
            deskripsi: order.product!.deskripsi,
            harga: order.product!.harga,
            sku: order.product!.sku,
            hargaModal: order.product!.hargaModal,
            stock: order.stock!,
            createdAt: order.product!.createdAt,
          );
          await productHelper.updateProduct(request);
        });
      }
      if (response) {
        emit(Requestadjustment());
      } else {
        emit(AdjustmentError());
      }
    });

    on<Modal>((event, emit) {
      emit(AdjustmentLoading());
      emit(ModalShow(context: event.context));
    });

    on<CreatModalAdjustment>((event, emit) {
      emit(AdjustmentLoading());
      emit(ListUdjestment(adjustment: event.adjustment));
    });
  }
}

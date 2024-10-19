// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:kasir_dekstop/models/order_model.dart';
import 'package:kasir_dekstop/models/product_models.dart';
import 'package:kasir_dekstop/models/varian_reesponse_model.dart';
import 'package:kasir_dekstop/service/product_helper.dart';
part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  ProductHelper productHelper = ProductHelper();
  OrderBloc() : super(OrderInitial()) {
    on<GetOrder>((event, emit) async {
      emit(OrderLoading());
      final response = await productHelper.getOrder(event.date);
      if (response!.isNotEmpty) {
        emit(OrderSuccess(order: response));
      } else {
        emit(OrderError());
      }
    });
    on<GetOrderSuplier>((event, emit) async {
      emit(OrderLoading());
      final response = await productHelper.getOrderSuplier(event.suplier);
      if (response!.isNotEmpty) {
        emit(OrderSuccess(order: response));
      } else {
        emit(OrderError());
      }
    });
    on<CreateOrder>((event, emit) async {
      emit(OrderLoading());
      final response = await productHelper.insertOrder(event.order);
      event.order.detail?.forEach((order) async {
        String harga = "";
        List<VarianResponseModel>? varian;
        if (order.product!.hargaModal != order.harga) {
          harga = order.harga!;
          if (order.product!.varian != null) {
            varian = [];
            order.product!.varian?.forEach((varians) {
              int hargaModalVarian =
                  int.parse(order.harga!) * int.parse(varians.stokVarian);
              varian!.add(VarianResponseModel(
                id: varians.id,
                idBarang: varians.idBarang,
                namaVarian: varians.namaVarian,
                hargaVarian: varians.hargaVarian,
                skuVarian: varians.skuVarian,
                stokVarian: varians.stokVarian,
                hargaModalVarian: hargaModalVarian.toString(),
              ));
            });
          }
        }
        int stok = int.parse(order.product!.stock) + int.parse(order.qty!);
        var request = ProductsModel(
            id: int.parse(order.idProduct!),
            namaBarang: order.product!.namaBarang,
            idCategory: order.product!.idCategory,
            idVarian: order.product!.idVarian,
            deskripsi: order.product!.deskripsi,
            harga: order.product!.harga,
            sku: order.product!.sku,
            hargaModal: (harga == "") ? order.product!.hargaModal : harga,
            stock: stok.toString(),
            createdAt: order.product!.createdAt,
            varian: varian);
        await productHelper.updateProduct(request);
      });
      if (response > 0) {
        emit(RequestOrderSuccess(id: response));
      } else {
        emit(OrderError());
      }
    });
    on<UpdateOrder>((event, emit) async {
      emit(OrderLoading());
      final response = await productHelper.updateOrder(event.order);
      emit(RequestOrderSuccess(id: response));
    });
    on<DeleteOrder>((event, emit) async {
      emit(OrderLoading());
      final response = await productHelper.deleteOrder(event.id);
      emit(RequestOrderSuccess(id: response));
    });
    on<Modal>((event, emit) async {
      emit(OrderLoading());
      emit(ModalShow(context: event.context));
    });
    on<GetOrderDetail>((event, emit) async {
      emit(OrderLoading());
      final response = await productHelper.getOrderDetail(event.date);
      if (response!.isNotEmpty) {
        emit(OrderDetailSucces(orderDetail: response));
      } else {
        emit(OrderError());
      }
    });
  }
}

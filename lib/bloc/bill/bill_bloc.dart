// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:kasir_dekstop/models/bill_model.dart';
import 'package:kasir_dekstop/models/product_models.dart';
import 'package:kasir_dekstop/service/product_helper.dart';
import 'package:meta/meta.dart';

part 'bill_event.dart';
part 'bill_state.dart';

class BillBloc extends Bloc<BillEvent, BillState> {
  bool isWholeNumber(double value) {
    return value == value.toInt().toDouble();
  }

  ProductHelper productHelper = ProductHelper();
  BillBloc() : super(BillInitial()) {
    on<GetBill>((event, emit) async {
      emit(BillLoading());
      final response = await productHelper.getBill();
      if (response.isNotEmpty) {
        emit(BillSuccess(bill: response));
      } else {
        emit(BillError());
      }
    });
    on<CreateBill>((event, emit) async {
      emit(BillLoading());
      final response = await productHelper.insertBill(event.billModel);
      final Map<int, double> groupedSums = {};
      for (var item in event.billModel.billCart!) {
        final idProduct = int.parse(item.productId!);
        double qty = 0;
        if (item.varianId != null) {
          qty = double.parse(item.varian!.stokVarian) * double.parse(item.qty!);
        } else {
          qty = double.parse(item.qty!);
        }
        if (groupedSums.containsKey(idProduct)) {
          groupedSums[idProduct] = (groupedSums[idProduct] ?? 0) + qty;
        } else {
          groupedSums[idProduct] = qty;
        }
      }
      groupedSums.forEach((key, value) async {
        var dataProduct = event.billModel.billCart!.firstWhere(
          (element) => element.productId == key.toString(),
        );
        String stok = "";
        var total = double.parse(dataProduct.product!.stock) - value;
        if (isWholeNumber(value)) {
          stok = total.toInt().toString();
        } else {
          stok = total.toString();
        }

        var request = ProductsModel(
            id: dataProduct.product!.id,
            namaBarang: dataProduct.product!.namaBarang,
            idCategory: dataProduct.product!.idCategory,
            idVarian: dataProduct.product!.idVarian,
            deskripsi: dataProduct.product!.deskripsi,
            harga: dataProduct.product!.harga,
            sku: dataProduct.product!.sku,
            hargaModal: dataProduct.product!.hargaModal,
            stock: stok.toString(),
            createdAt: dataProduct.product!.createdAt);

        await productHelper.updateProduct(request);
      });
      if (response > 0) {
        emit(RequestBillSuccess(id: response));
      } else {
        emit(BillError());
      }
    });
  }
}

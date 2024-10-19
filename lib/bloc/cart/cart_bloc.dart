// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:kasir_dekstop/models/bill_model.dart';
import 'package:kasir_dekstop/models/cart_model.dart';
import 'package:kasir_dekstop/models/product_models.dart';
import 'package:kasir_dekstop/service/product_helper.dart';
import 'package:meta/meta.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  bool isWholeNumber(double value) {
    return value == value.toInt().toDouble();
  }

  ProductHelper productHelper = ProductHelper();
  CartBloc() : super(CartInitial()) {
    on<GetCart>((event, emit) async {
      emit(CartLoading());
      final response = await productHelper.getCart();
      emit(CartSuccess(cart: response));
    });
    on<CreateCart>((event, emit) async {
      emit(CartLoading());
      var cart = await productHelper.getCart();
      var barang = cart.firstWhere(
        (value) =>
            value.productId == event.cart.productId &&
            value.varianId == event.cart.varianId,
        orElse: () => CartModel(productId: null, qty: null, created: null),
      );
      if (barang.productId != null) {
        var total = int.parse(barang.qty!) + 1;
        var request = CartModel(
            id: barang.id,
            productId: barang.productId,
            varianId: barang.varianId,
            discountId: barang.discountId,
            customerId: barang.customerId,
            qty: total.toString(),
            created: barang.created);
        final response = await productHelper.updateCart(request);
        if (response > 0) {
          emit(RequestCartSuccess(id: response));
        }
      } else {
        final response = await productHelper.insertCart(event.cart);
        emit(RequestCartSuccess(id: response));
      }
    });
    on<UpdateCart>((event, emit) async {
      emit(CartLoading());
      final response = await productHelper.updateCart(event.cart);
      emit(RequestCartSuccess(id: response));
    });
    on<DeleteCart>((event, emit) async {
      emit(CartLoading());
      final response = await productHelper.deleteCart(event.id);
      emit(RequestCartSuccess(id: response));
    });

    on<UbahBill>((event, emit) async {
      emit(CartLoading());
      final response = await productHelper.deleteBill(event.billModel.id!);
      final Map<int, double> groupedSums = {};
      for (var item in event.billModel.billCart!) {
        var request = CartModel(
            productId: item.productId,
            qty: item.qty,
            varianId: item.varianId,
            discountId: item.discountId,
            customerId: item.customerId,
            created: DateTime.now().toIso8601String());
        await productHelper.insertCart(request);
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
        var total = double.parse(dataProduct.product!.stock) + value;
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
      emit(RequestCartSuccess(id: response));
    });
  }
}

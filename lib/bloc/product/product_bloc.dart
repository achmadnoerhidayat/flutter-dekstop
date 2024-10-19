// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:kasir_dekstop/models/cart_model.dart';
import 'package:kasir_dekstop/models/product_models.dart';
import 'package:kasir_dekstop/service/product_helper.dart';
import 'package:meta/meta.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductHelper productHelper = ProductHelper();
  ProductBloc() : super(ProductInitial()) {
    on<GetProducts>((event, emit) async {
      emit(ProductLoading());
      final response = await productHelper.getProduct();
      emit(ProductSuccess(product: response));
    });
    on<GetProductsByName>((event, emit) async {
      emit(ProductLoading());
      if (event.nama.isNotEmpty && event.type == 'barcode') {
        final response =
            await productHelper.getSearchProduct(event.nama, event.type);
        if (response.isNotEmpty) {
          CartModel cart = CartModel(
            productId: response.first.id.toString(),
            qty: "1",
            varianId: null,
            discountId: null,
            customerId: null,
            created: DateTime.now().toIso8601String(),
          );
          final keranjang = await productHelper.addKernjang(cart);
          if (keranjang > 0) {
            emit(ProductSuccess(product: response));
          } else {
            emit(ProductError(error: "Tidak ditemukan"));
          }
        } else {
          emit(ProductError(error: "Tidak ditemukan"));
        }
      } else if (event.type == 'search') {
        final response =
            await productHelper.getSearchProduct(event.nama, event.type);
        emit(ProductSuccess(product: response));
      } else {
        emit(ProductError(error: "data tidak ditemukan"));
      }
    });
    on<GetProductsByCategory>((event, emit) async {
      emit(ProductLoading());
      final response = await productHelper.getKategoriProduct(event.idCategory);
      emit(ProductSuccess(product: response));
    });
    on<CreateProduct>((event, emit) async {
      emit(ProductLoading());
      var id = await productHelper.insertProduct(event.productsModel);
      emit(ProductCreateSuccess(id: id));
    });
    on<UpdateProduct>((event, emit) async {
      emit(ProductLoading());
      var id = await productHelper.updateProduct(event.productsModel);
      emit(ProductUpdateSuccess(id: id));
    });
    on<DeleteProduct>((event, emit) async {
      emit(ProductLoading());
      var id = await productHelper.deleteProduct(event.productsModel);
      emit(ProductDeleteSuccess(id: id));
    });
  }
}

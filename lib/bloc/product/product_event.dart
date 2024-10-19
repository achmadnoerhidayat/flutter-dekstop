part of 'product_bloc.dart';

@immutable
abstract class ProductEvent {}

class GetProducts extends ProductEvent {}

class GetProductsByName extends ProductEvent {
  final String nama;
  final String type;
  GetProductsByName({required this.nama, required this.type});
}

class GetProductsByCategory extends ProductEvent {
  final String idCategory;
  GetProductsByCategory({required this.idCategory});
}

class CreateProduct extends ProductEvent {
  final ProductsModel productsModel;
  CreateProduct({required this.productsModel});
}

class UpdateProduct extends ProductEvent {
  final ProductsModel productsModel;
  UpdateProduct({required this.productsModel});
}

class DeleteProduct extends ProductEvent {
  final ProductsModel productsModel;
  DeleteProduct({required this.productsModel});
}

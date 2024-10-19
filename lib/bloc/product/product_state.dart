// ignore_for_file: must_be_immutable

part of 'product_bloc.dart';

@immutable
abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductSuccess extends ProductState {
  final List<ProductsModel>? product;
  ProductSuccess({required this.product});
}

class ProductError extends ProductState {
  String error;
  ProductError({required this.error});
}

class ProductCreateSuccess extends ProductState {
  int id;
  ProductCreateSuccess({required this.id});
}

class ProductUpdateSuccess extends ProductState {
  int id;
  ProductUpdateSuccess({required this.id});
}

class ProductDeleteSuccess extends ProductState {
  int id;
  ProductDeleteSuccess({required this.id});
}

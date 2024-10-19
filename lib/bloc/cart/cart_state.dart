part of 'cart_bloc.dart';

@immutable
abstract class CartState {}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartSuccess extends CartState {
  final List<CartModel>? cart;
  CartSuccess({required this.cart});
}

class RequestCartSuccess extends CartState {
  final int id;
  RequestCartSuccess({required this.id});
}

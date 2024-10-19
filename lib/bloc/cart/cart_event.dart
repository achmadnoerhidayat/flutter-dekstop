part of 'cart_bloc.dart';

@immutable
abstract class CartEvent {}

class GetCart extends CartEvent {}

class CreateCart extends CartEvent {
  final CartModel cart;
  CreateCart({required this.cart});
}

class UpdateCart extends CartEvent {
  final CartModel cart;
  UpdateCart({required this.cart});
}

class DeleteCart extends CartEvent {
  final int id;
  DeleteCart({required this.id});
}

class UbahBill extends CartEvent {
  final BillModel billModel;
  UbahBill({required this.billModel});
}

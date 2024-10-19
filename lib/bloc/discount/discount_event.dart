part of 'discount_bloc.dart';

@immutable
abstract class DiscountEvent {}

class GetDiscount extends DiscountEvent {}

class CreateDiscount extends DiscountEvent {
  final DiscountModel discountModel;
  CreateDiscount({required this.discountModel});
}

class UpdateDiscount extends DiscountEvent {
  final DiscountModel discountModel;
  UpdateDiscount({required this.discountModel});
}

class DeleteDiscount extends DiscountEvent {
  final int id;
  DeleteDiscount({required this.id});
}

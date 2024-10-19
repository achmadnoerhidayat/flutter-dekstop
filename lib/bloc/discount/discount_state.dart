part of 'discount_bloc.dart';

@immutable
abstract class DiscountState {}

class DiscountInitial extends DiscountState {}

class DiscountLoading extends DiscountState {}

class DiscountSuccess extends DiscountState {
  final List<DiscountModel> discount;
  DiscountSuccess({required this.discount});
}

class DiscountError extends DiscountState {}

class RequestDiscountSuccess extends DiscountState {
  final int id;
  RequestDiscountSuccess({required this.id});
}

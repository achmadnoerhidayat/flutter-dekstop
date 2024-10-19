part of 'promo_bloc.dart';

@immutable
abstract class PromoState {}

class PromoInitial extends PromoState {}

class PromoSuccess extends PromoState {
  final List<PromoModel> promo;
  PromoSuccess({required this.promo});
}

class PromoLoading extends PromoState {}

class PromoError extends PromoState {}

class RequestPromoSuccess extends PromoState {
  final int id;
  RequestPromoSuccess({required this.id});
}

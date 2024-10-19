part of 'promo_bloc.dart';

@immutable
abstract class PromoEvent {}

class GetPromo extends PromoEvent {}

class CreatePromo extends PromoEvent {
  final PromoModel promoModel;
  CreatePromo({required this.promoModel});
}

class UpdatePromo extends PromoEvent {
  final PromoModel promoModel;
  UpdatePromo({required this.promoModel});
}

class DeletePromo extends PromoEvent {
  final int id;
  DeletePromo({required this.id});
}

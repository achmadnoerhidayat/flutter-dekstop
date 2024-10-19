part of 'request_variant_bloc.dart';

@immutable
abstract class RequestVariantState {}

class RequestVariantInitial extends RequestVariantState {}

// ignore: must_be_immutable
class RequestVariantList extends RequestVariantState {
  List<VarianModel> formVarian;
  RequestVariantList({required this.formVarian});
}

class RequestVarianSuccess extends RequestVariantState {}

class RequestVarianLoading extends RequestVariantState {}

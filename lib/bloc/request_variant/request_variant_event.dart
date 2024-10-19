// ignore_for_file: must_be_immutable

part of 'request_variant_bloc.dart';

@immutable
abstract class RequestVariantEvent {}

class GetVarianList extends RequestVariantEvent {
  List<VarianModel> formVarian;
  GetVarianList({required this.formVarian});
}

class RemoveVarianList extends RequestVariantEvent {
  List<VarianModel>? formVarian;
  VarianModel varianModel;
  RemoveVarianList({required this.formVarian, required this.varianModel});
}

class DeleteVarian extends RequestVariantEvent {
  List<VarianModel>? formVarian;
  int idBarang;
  DeleteVarian({required this.formVarian, required this.idBarang});
}

class CreateVarian extends RequestVariantEvent {
  List<VarianModel> formVarian;
  int idBarang;
  CreateVarian({required this.formVarian, required this.idBarang});
}

// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:kasir_dekstop/models/product_models.dart';

PromoProductModel PromoProductModelFromJson(String str) =>
    PromoProductModel.fromJson(json.decode(str));

String PromoProductModelToJson(PromoProductModel data) =>
    json.encode(data.toJson());

class PromoProductModel {
  final int? id;
  late String? idPromo;
  late String? idProduct;
  late String? hargaPromo;
  late String? discount;
  late String? minBelanja;
  ProductsModel? product;

  PromoProductModel(
      {this.id,
      required this.idPromo,
      required this.idProduct,
      required this.hargaPromo,
      required this.discount,
      required this.minBelanja,
      this.product});

  factory PromoProductModel.fromJson(Map<String, dynamic> json) =>
      PromoProductModel(
        id: json["id"],
        idPromo: json["idPromo"],
        idProduct: json["idProduct"],
        hargaPromo: json["hargaPromo"],
        discount: json["discount"],
        minBelanja: json["minBelanja"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "idPromo": idPromo,
        "idProduct": idProduct,
        "hargaPromo": hargaPromo,
        "discount": discount,
        "minBelanja": minBelanja,
      };
}

// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:kasir_dekstop/models/promo_product_model.dart';

PromoModel PromoModelFromJson(String str) =>
    PromoModel.fromJson(json.decode(str));

String PromoModelToJson(PromoModel data) => json.encode(data.toJson());

class PromoModel {
  final int? id;
  final String? judul;
  final String? promoMulai;
  final String? promoBerakhir;
  final List<PromoProductModel>? promoProdact;

  PromoModel({
    this.id,
    required this.judul,
    required this.promoMulai,
    required this.promoBerakhir,
    this.promoProdact,
  });

  factory PromoModel.fromJson(Map<String, dynamic> json) => PromoModel(
        id: json["id"],
        judul: json["judul"],
        promoMulai: json["promoMulai"],
        promoBerakhir: json["promoBerakhir"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "judul": judul,
        "promoMulai": promoMulai,
        "promoBerakhir": promoBerakhir,
      };
}

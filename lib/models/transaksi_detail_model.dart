// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:kasir_dekstop/models/product_models.dart';
import 'package:kasir_dekstop/models/varian_model.dart';

TransaksiDetailModel TransaksiDetailModelFromJson(String str) =>
    TransaksiDetailModel.fromJson(json.decode(str));

String TransaksiDetailModelToJson(TransaksiDetailModel data) =>
    json.encode(data.toJson());

class TransaksiDetailModel {
  final int? id;
  String? idTransaksi;
  final String? idProduct;
  final String? idVarian;
  final String? qty;
  final String? hargaModal;
  final String? hargaProduct;
  final String? totalDiskon;
  final String? created;
  ProductsModel? product;
  VarianModel? varian;

  TransaksiDetailModel({
    this.id,
    required this.idTransaksi,
    required this.idProduct,
    required this.idVarian,
    required this.qty,
    required this.hargaModal,
    required this.hargaProduct,
    this.totalDiskon,
    this.created,
    this.product,
    this.varian,
  });

  factory TransaksiDetailModel.fromJson(Map<String, dynamic> json) =>
      TransaksiDetailModel(
        id: json["id"],
        idTransaksi: json["idTransaksi"],
        idProduct: json["idProduct"],
        idVarian: json["idVarian"],
        qty: json["qty"],
        hargaModal: json["hargaModal"],
        hargaProduct: json["hargaProduct"],
        totalDiskon: json["totalDiskon"],
        created: json["created"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "idTransaksi": idTransaksi,
        "idProduct": idProduct,
        "idVarian": idVarian,
        "qty": qty,
        "hargaModal": hargaModal,
        "hargaProduct": hargaProduct,
        "totalDiskon": totalDiskon,
        "created": created,
      };
}

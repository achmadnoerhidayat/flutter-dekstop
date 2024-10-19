// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:kasir_dekstop/models/product_models.dart';

AdjustmentModel AdjustmentModelFromJson(String str) =>
    AdjustmentModel.fromJson(json.decode(str));

String AdjustmentModelToJson(AdjustmentModel data) =>
    json.encode(data.toJson());

class AdjustmentModel {
  final int? id;
  final String? note;
  final String? created;
  List<AdjustmentModelDetail>? detail;

  AdjustmentModel({
    this.id,
    required this.note,
    required this.created,
    this.detail,
  });

  factory AdjustmentModel.fromJson(Map<String, dynamic> json) =>
      AdjustmentModel(
        id: json["id"],
        note: json["note"],
        created: json["created"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "note": note,
        "created": created,
      };
}

class AdjustmentModelDetail {
  final int? id;
  String? idAdjustment;
  final String? idProduct;
  final String? hargaModal;
  String? stock;
  String? adjustment;
  final String? created;
  ProductsModel? product;
  AdjustmentModel? adjustmentModel;

  AdjustmentModelDetail({
    this.id,
    required this.idAdjustment,
    required this.idProduct,
    required this.hargaModal,
    required this.stock,
    this.adjustment,
    required this.created,
    this.product,
    this.adjustmentModel,
  });

  factory AdjustmentModelDetail.fromJson(Map<String, dynamic> json) =>
      AdjustmentModelDetail(
        id: json["id"],
        idAdjustment: json["idAdjustment"],
        idProduct: json["idProduct"],
        hargaModal: json["hargaModal"],
        stock: json["stock"],
        adjustment: json["adjustment"],
        created: json["created"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "idAdjustment": idAdjustment,
        "idProduct": idProduct,
        "hargaModal": hargaModal,
        "stock": stock,
        "adjustment": adjustment,
        "created": created,
      };
}

// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:kasir_dekstop/models/customer_model.dart';

DebtWatchModel DebtWatchModelFromJson(String str) =>
    DebtWatchModel.fromJson(json.decode(str));

String DebtWatchModelToJson(DebtWatchModel data) => json.encode(data.toJson());

class DebtWatchModel {
  final int? id;
  final String? idCustomer;
  final String? nominal;
  final String? created;
  List<DebtWatchDetailModel>? kasbonDetail;
  CustomerModel? customerModel;
  String? status;

  DebtWatchModel({
    this.id,
    required this.idCustomer,
    required this.nominal,
    required this.created,
    this.kasbonDetail,
    this.customerModel,
    this.status,
  });

  factory DebtWatchModel.fromJson(Map<String, dynamic> json) => DebtWatchModel(
        id: json["id"],
        idCustomer: json["idCustomer"],
        nominal: json["nominal"],
        created: json["created"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "idCustomer": idCustomer,
        "nominal": nominal,
        "created": created,
      };
}

class DebtWatchDetailModel {
  final int? id;
  String? idKasbon;
  final String? type;
  final String? nominal;
  final String? note;
  final String? created;

  DebtWatchDetailModel({
    this.id,
    required this.idKasbon,
    required this.type,
    required this.nominal,
    required this.note,
    required this.created,
  });

  factory DebtWatchDetailModel.fromJson(Map<String, dynamic> json) =>
      DebtWatchDetailModel(
        id: json["id"],
        idKasbon: json["idKasbon"],
        type: json["type"],
        nominal: json["nominal"],
        note: json["note"],
        created: json["created"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "idKasbon": idKasbon,
        "type": type,
        "nominal": nominal,
        "note": note,
        "created": created,
      };
}

// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:kasir_dekstop/models/customer_model.dart';

DebtSugarModel DebtSugarModelFromJson(String str) =>
    DebtSugarModel.fromJson(json.decode(str));

String DebtSugarModelToJson(DebtSugarModel data) => json.encode(data.toJson());

class DebtSugarModel {
  final int? id;
  final String? idCustomer;
  final String? nominal;
  final String? created;
  List<DebtSugarDetailModel>? sugarDetail;
  CustomerModel? customerModel;
  String? status;

  DebtSugarModel({
    this.id,
    required this.idCustomer,
    required this.nominal,
    required this.created,
    this.sugarDetail,
    this.customerModel,
    this.status,
  });

  factory DebtSugarModel.fromJson(Map<String, dynamic> json) => DebtSugarModel(
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

class DebtSugarDetailModel {
  final int? id;
  String? idHutang;
  final String? type;
  final String? nominal;
  final String? note;
  final String? created;

  DebtSugarDetailModel({
    this.id,
    required this.idHutang,
    required this.type,
    required this.nominal,
    required this.note,
    required this.created,
  });

  factory DebtSugarDetailModel.fromJson(Map<String, dynamic> json) =>
      DebtSugarDetailModel(
        id: json["id"],
        idHutang: json["idHutang"],
        type: json["type"],
        nominal: json["nominal"],
        note: json["note"],
        created: json["created"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "idHutang": idHutang,
        "type": type,
        "nominal": nominal,
        "note": note,
        "created": created,
      };
}

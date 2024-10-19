// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

GulaModel GulaModelFromJson(String str) => GulaModel.fromJson(json.decode(str));

String GulaModelToJson(GulaModel data) => json.encode(data.toJson());

class GulaModel {
  final int? id;
  final String? type;
  final String? priceBeli;
  final String? priceJual;
  final String? created;

  GulaModel({
    this.id,
    required this.type,
    required this.priceBeli,
    required this.priceJual,
    required this.created,
  });

  factory GulaModel.fromJson(Map<String, dynamic> json) => GulaModel(
        id: json["id"],
        type: json["type"],
        priceBeli: json["priceBeli"],
        priceJual: json["priceJual"],
        created: json["created"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "priceBeli": priceBeli,
        "priceJual": priceJual,
        "created": created,
      };
}

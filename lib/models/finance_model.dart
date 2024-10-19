// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

FinanceModel FinanceModelFromJson(String str) =>
    FinanceModel.fromJson(json.decode(str));

String FinanceModelToJson(FinanceModel data) => json.encode(data.toJson());

class FinanceModel {
  final int? id;
  final String? shiftId;
  final String? type;
  final String? nominal;
  final String? note;
  final String? created;

  FinanceModel({
    this.id,
    required this.shiftId,
    required this.type,
    this.nominal,
    this.note,
    required this.created,
  });

  factory FinanceModel.fromJson(Map<String, dynamic> json) => FinanceModel(
        id: json["id"],
        shiftId: json["shiftId"],
        type: json["type"],
        nominal: json["nominal"],
        note: json["note"],
        created: json["created"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "shiftId": shiftId,
        "type": type,
        "nominal": nominal,
        "note": note,
        "created": created,
      };
}

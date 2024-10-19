// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

SuplierModel SuplierModelFromJson(String str) =>
    SuplierModel.fromJson(json.decode(str));

String SuplierModelToJson(SuplierModel data) => json.encode(data.toJson());

class SuplierModel {
  final int? id;
  final String? name;
  final String? phone;
  final String? email;
  final String? created;

  SuplierModel({
    this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.created,
  });

  factory SuplierModel.fromJson(Map<String, dynamic> json) => SuplierModel(
        id: json["id"],
        name: json["name"],
        phone: json["phone"],
        email: json["email"],
        created: json["created"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "phone": phone,
        "email": email,
        "created": created,
      };
}

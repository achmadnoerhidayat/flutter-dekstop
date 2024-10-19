// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:kasir_dekstop/models/debt_watch_model.dart';

CustomerModel CustomerModelFromJson(String str) =>
    CustomerModel.fromJson(json.decode(str));

String CustomerModelToJson(CustomerModel data) => json.encode(data.toJson());

class CustomerModel {
  final int? id;
  final String? nama;
  final String? phone;
  final String? email;
  final String? created;
  DebtWatchModel? kasbon;

  CustomerModel(
      {this.id,
      required this.nama,
      required this.phone,
      required this.email,
      required this.created,
      this.kasbon});

  factory CustomerModel.fromJson(Map<String, dynamic> json) => CustomerModel(
        id: json["id"],
        nama: json["nama"],
        phone: json["phone"],
        email: json["email"],
        created: json["created"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama": nama,
        "phone": phone,
        "email": email,
        "created": created,
      };
}

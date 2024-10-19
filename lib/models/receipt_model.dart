// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

ReceiptModel ReceiptModelFromJson(String str) =>
    ReceiptModel.fromJson(json.decode(str));

String ReceiptModelToJson(ReceiptModel data) => json.encode(data.toJson());

class ReceiptModel {
  final int? id;
  final String? namaToko;
  final String? alamat;
  final String? provinsi;
  final String? kota;
  final String? kodePos;
  final String? phone;
  final String? notes;
  final String? created;

  ReceiptModel({
    this.id,
    required this.namaToko,
    required this.alamat,
    this.provinsi,
    this.kota,
    this.kodePos,
    this.phone,
    this.notes,
    this.created,
  });

  factory ReceiptModel.fromJson(Map<String, dynamic> json) => ReceiptModel(
        id: json["id"],
        namaToko: json["namaToko"],
        alamat: json["alamat"],
        provinsi: json["provinsi"],
        kota: json["kota"],
        kodePos: json["kodePos"],
        phone: json["phone"],
        notes: json["notes"],
        created: json["created"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "namaToko": namaToko,
        "alamat": alamat,
        "provinsi": provinsi,
        "kota": kota,
        "kodePos": kodePos,
        "phone": phone,
        "notes": notes,
        "created": created,
      };
}

// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

DiscountModel DiscountModelFromJson(String str) =>
    DiscountModel.fromJson(json.decode(str));

String DiscountModelToJson(DiscountModel data) => json.encode(data.toJson());

class DiscountModel {
  final int? id;
  final String? nama;
  final String? jumlah;
  final String? type;
  bool status;

  DiscountModel({
    this.id,
    required this.nama,
    required this.jumlah,
    required this.type,
    this.status = false,
  });

  factory DiscountModel.fromJson(Map<String, dynamic> json) => DiscountModel(
        id: json["id"],
        nama: json["nama"],
        jumlah: json["jumlah"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama": nama,
        "jumlah": jumlah,
        "type": type,
      };
}

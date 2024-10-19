// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

ShiftModel ShiftModelFromJson(String str) =>
    ShiftModel.fromJson(json.decode(str));

String ShiftModelToJson(ShiftModel data) => json.encode(data.toJson());

class ShiftModel {
  final int? id;
  final String? modal;
  final String? startShift;
  final String? endShift;
  final String? totalUang;
  final String? selisih;
  final String? created;
  final String? totalTransaksi;
  final String? totalKasbon;
  final String? totalSetor;
  final String? totalGula;
  final String? totalPengeluaran;
  final String? totalPemasukan;

  ShiftModel({
    this.id,
    required this.modal,
    required this.startShift,
    this.endShift,
    this.totalUang,
    this.selisih,
    required this.created,
    this.totalTransaksi,
    this.totalKasbon,
    this.totalSetor,
    this.totalGula,
    this.totalPengeluaran,
    this.totalPemasukan,
  });

  factory ShiftModel.fromJson(Map<String, dynamic> json) => ShiftModel(
        id: json["id"],
        modal: json["modal"],
        startShift: json["startShift"],
        endShift: json["endShift"],
        totalUang: json["totalUang"],
        selisih: json["selisih"],
        created: json["created"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "modal": modal,
        "startShift": startShift,
        "endShift": endShift,
        "totalUang": totalUang,
        "selisih": selisih,
        "created": created,
      };
}

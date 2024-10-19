import 'dart:convert';

VarianResponseModel varianResponseModelFromJson(String str) =>
    VarianResponseModel.fromJson(json.decode(str));

String varianResponseModelToJson(VarianResponseModel data) =>
    json.encode(data.toJson());

class VarianResponseModel {
  final int id;
  final String idBarang;
  final String namaVarian;
  final String hargaVarian;
  final String skuVarian;
  final String stokVarian;
  final String hargaModalVarian;
  bool status;

  VarianResponseModel({
    required this.id,
    required this.idBarang,
    required this.namaVarian,
    required this.hargaVarian,
    required this.skuVarian,
    required this.stokVarian,
    required this.hargaModalVarian,
    this.status = false,
  });

  factory VarianResponseModel.fromJson(Map<String, dynamic> json) =>
      VarianResponseModel(
        id: json["id"],
        idBarang: json["idBarang"],
        namaVarian: json["namaVarian"],
        hargaVarian: json["hargaVarian"],
        skuVarian: json["skuVarian"],
        stokVarian: json["stokVarian"],
        hargaModalVarian: json["hargaModalVarian"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "idBarang": idBarang,
        "namaVarian": namaVarian,
        "hargaVarian": hargaVarian,
        "skuVarian": skuVarian,
        "stokVarian": stokVarian,
        "hargaModalVarian": hargaModalVarian,
      };
}

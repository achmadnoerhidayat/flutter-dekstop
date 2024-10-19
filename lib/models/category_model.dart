// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

CategoryModel CategoryModelFromJson(String str) =>
    CategoryModel.fromJson(json.decode(str));

String CategoryModelToJson(CategoryModel data) => json.encode(data.toJson());

class CategoryModel {
  final int? id;
  final String? nama;
  bool status;

  CategoryModel({this.id, required this.nama, this.status = false});

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json["id"],
        nama: json["nama"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama": nama,
      };
}

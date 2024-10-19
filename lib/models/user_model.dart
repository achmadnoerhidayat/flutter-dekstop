// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

UserModel UserModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String UserModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  final int? id;
  final String? nama;
  final String? role;
  final String? email;
  final String? password;
  final String? created;

  UserModel({
    this.id,
    required this.nama,
    required this.role,
    required this.email,
    required this.password,
    required this.created,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        nama: json["nama"],
        role: json["role"],
        email: json["email"],
        password: json["password"],
        created: json["created"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama": nama,
        "role": role,
        "email": email,
        "password": password,
        "created": created,
      };
}

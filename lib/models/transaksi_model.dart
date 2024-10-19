// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:kasir_dekstop/models/customer_model.dart';
import 'package:kasir_dekstop/models/receipt_model.dart';
import 'package:kasir_dekstop/models/transaksi_detail_model.dart';
import 'package:kasir_dekstop/models/user_model.dart';

TransaksiModel TransaksiModelFromJson(String str) =>
    TransaksiModel.fromJson(json.decode(str));

String TransaksiModelToJson(TransaksiModel data) => json.encode(data.toJson());

class TransaksiModel {
  final int? id;
  final String? idUser;
  final String? idCustomer;
  String? orderId;
  String? shiftId;
  String? totalGula;
  String? weightGula;
  String? priceBeliGula;
  String? priceJualGula;
  String? totalKasbon;
  String? setorKasbon;
  String? noteKasbon;
  String? setorGula;
  String? noteGula;
  final String? totalHarga;
  final String? bayar;
  final String? kembalian;
  final String? paymentType;
  final String? created;
  CustomerModel? customer;
  List<TransaksiDetailModel>? detail;
  ReceiptModel? receipt;
  UserModel? user;

  TransaksiModel({
    this.id,
    required this.idUser,
    required this.idCustomer,
    required this.orderId,
    required this.shiftId,
    this.totalGula,
    this.weightGula,
    this.priceBeliGula,
    this.priceJualGula,
    this.totalKasbon,
    this.setorKasbon,
    this.noteKasbon,
    this.setorGula,
    this.noteGula,
    required this.totalHarga,
    required this.bayar,
    required this.kembalian,
    required this.paymentType,
    required this.created,
    this.customer,
    this.detail,
    this.receipt,
    this.user,
  });

  factory TransaksiModel.fromJson(Map<String, dynamic> json) => TransaksiModel(
        id: json["id"],
        idUser: json["idUser"],
        idCustomer: json["idCustomer"],
        orderId: json["orderId"],
        shiftId: json["shiftId"],
        totalGula: json["totalGula"],
        weightGula: json["weightGula"],
        priceBeliGula: json["priceBeliGula"],
        priceJualGula: json["priceJualGula"],
        totalKasbon: json["totalKasbon"],
        setorKasbon: json["setorKasbon"],
        setorGula: json["setorGula"],
        totalHarga: json["totalHarga"],
        bayar: json["bayar"],
        kembalian: json["kembalian"],
        paymentType: json["paymentType"],
        created: json["created"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "idUser": idUser,
        "idCustomer": idCustomer,
        "orderId": orderId,
        "shiftId": shiftId,
        "totalGula": totalGula,
        "weightGula": weightGula,
        "priceBeliGula": priceBeliGula,
        "priceJualGula": priceJualGula,
        "totalKasbon": totalKasbon,
        "setorKasbon": setorKasbon,
        "setorGula": setorGula,
        "totalHarga": totalHarga,
        "bayar": bayar,
        "kembalian": kembalian,
        "paymentType": paymentType,
        "created": created,
      };
}

class TransaksiHariModel {
  final String hari;
  final double sales;
  final TransaksiProductTerlarisModel? terlaris;

  TransaksiHariModel({required this.hari, required this.sales, this.terlaris});
  factory TransaksiHariModel.fromJson(Map<String, dynamic> json) =>
      TransaksiHariModel(
        hari: json["hari"],
        sales: json["sales"],
      );

  Map<String, dynamic> toJson() => {
        "hari": hari,
        "sales": sales,
      };
}

class TransaksiProductTerlarisModel {
  final String namaProduct;
  final double sales;

  TransaksiProductTerlarisModel(
      {required this.namaProduct, required this.sales});
  factory TransaksiProductTerlarisModel.fromJson(Map<String, dynamic> json) =>
      TransaksiProductTerlarisModel(
        namaProduct: json["namaProduct"],
        sales: json["sales"],
      );

  Map<String, dynamic> toJson() => {
        "namaProduct": namaProduct,
        "sales": sales,
      };
}

class TransaksiJamModel {
  final String jam;
  final double sales;
  final TransaksiProductTerlarisModel? terlaris;

  TransaksiJamModel({required this.jam, required this.sales, this.terlaris});
  factory TransaksiJamModel.fromJson(Map<String, dynamic> json) =>
      TransaksiJamModel(
        jam: json["jam"],
        sales: json["sales"],
      );

  Map<String, dynamic> toJson() => {
        "jam": jam,
        "sales": sales,
      };
}

class TransaksiWeightmModel {
  final String minggu;
  final double berat;

  TransaksiWeightmModel({required this.minggu, required this.berat});
  factory TransaksiWeightmModel.fromJson(Map<String, dynamic> json) =>
      TransaksiWeightmModel(
        minggu: json["minggu"],
        berat: json["berat"],
      );

  Map<String, dynamic> toJson() => {
        "minggu": minggu,
        "berat": berat,
      };
}

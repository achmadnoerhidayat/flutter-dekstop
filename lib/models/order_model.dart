// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:kasir_dekstop/models/product_models.dart';
import 'package:kasir_dekstop/models/suplier_model.dart';
import 'package:kasir_dekstop/models/transaksi_detail_model.dart';

OrderModel OrderModelFromJson(String str) =>
    OrderModel.fromJson(json.decode(str));

String OrderModelToJson(OrderModel data) => json.encode(data.toJson());

class OrderModel {
  final int? id;
  final String? idSuplier;
  final String? noFaktur;
  final String? nominal;
  final String? status;
  final String? created;
  List<OrderDetailModel>? detail;
  SuplierModel? suplier;

  OrderModel({
    this.id,
    required this.idSuplier,
    required this.noFaktur,
    required this.nominal,
    required this.status,
    required this.created,
    this.detail,
    this.suplier,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        id: json["id"],
        idSuplier: json["idSuplier"],
        noFaktur: json["noFaktur"],
        nominal: json["nominal"],
        status: json["status"],
        created: json["created"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "idSuplier": idSuplier,
        "noFaktur": noFaktur,
        "nominal": nominal,
        "status": status,
        "created": created,
      };
}

class OrderDetailModel {
  final int? id;
  String? idPembelian;
  final String? idProduct;
  String? qty;
  String? stockBarang;
  String? harga;
  String? subtotal;
  final String? created;
  ProductsModel? product;
  TransaksiDetailModel? orderDetail;

  OrderDetailModel({
    this.id,
    required this.idPembelian,
    required this.idProduct,
    this.qty,
    this.stockBarang,
    this.harga,
    this.subtotal,
    required this.created,
    this.product,
    this.orderDetail,
  });

  factory OrderDetailModel.fromJson(Map<String, dynamic> json) =>
      OrderDetailModel(
        id: json["id"],
        idPembelian: json["idPembelian"],
        idProduct: json["idProduct"],
        qty: json["qty"],
        stockBarang: json["stockBarang"],
        created: json["created"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "idPembelian": idPembelian,
        "idProduct": idProduct,
        "qty": qty,
        "stockBarang": stockBarang,
        "created": created,
      };
}

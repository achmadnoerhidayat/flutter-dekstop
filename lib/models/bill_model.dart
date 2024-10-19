// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:kasir_dekstop/models/customer_model.dart';
import 'package:kasir_dekstop/models/discount_model.dart';
import 'package:kasir_dekstop/models/product_models.dart';
import 'package:kasir_dekstop/models/varian_model.dart';

BillModel BillModelFromJson(String str) => BillModel.fromJson(json.decode(str));

String BillModelToJson(BillModel data) => json.encode(data.toJson());

class BillModel {
  final int? id;
  final String? billName;
  final String? note;
  final String? created;
  List<BillCartModel>? billCart;

  BillModel({
    this.id,
    required this.billName,
    required this.note,
    required this.created,
    this.billCart,
  });

  factory BillModel.fromJson(Map<String, dynamic> json) => BillModel(
        id: json["id"],
        billName: json["billName"],
        note: json["note"],
        created: json["created"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "billName": billName,
        "note": note,
        "created": created,
      };
}

class BillCartModel {
  final int? id;
  String? billId;
  final String? productId;
  final String? varianId;
  final String? discountId;
  final String? customerId;
  final String? qty;
  final String? created;
  VarianModel? varian;
  ProductsModel? product;
  DiscountModel? discon;
  CustomerModel? customer;
  String subtotal;
  List<DiscountModel>? diskons;

  BillCartModel({
    this.id,
    required this.billId,
    required this.productId,
    required this.varianId,
    required this.discountId,
    required this.customerId,
    required this.qty,
    required this.created,
    this.varian,
    this.product,
    this.discon,
    this.customer,
    this.subtotal = "",
    this.diskons,
  });

  factory BillCartModel.fromJson(Map<String, dynamic> json) => BillCartModel(
        id: json["id"],
        billId: json["billId"],
        productId: json["productId"],
        varianId: json["varianId"],
        discountId: json["discountId"],
        customerId: json["customerId"],
        qty: json["qty"],
        created: json["created"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "billId": billId,
        "productId": productId,
        "varianId": varianId,
        "discountId": discountId,
        "customerId": customerId,
        "qty": qty,
        "created": created,
      };
}

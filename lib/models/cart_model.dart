// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:kasir_dekstop/models/customer_model.dart';
import 'package:kasir_dekstop/models/discount_model.dart';
import 'package:kasir_dekstop/models/product_models.dart';
import 'package:kasir_dekstop/models/varian_model.dart';

CartModel CartModelFromJson(String str) => CartModel.fromJson(json.decode(str));

String CartModelToJson(CartModel data) => json.encode(data.toJson());

class CartModel {
  final int? id;
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

  CartModel({
    this.id,
    required this.productId,
    this.varianId,
    this.discountId,
    this.customerId,
    required this.qty,
    required this.created,
    this.varian,
    this.product,
    this.discon,
    this.customer,
    this.subtotal = "",
    this.diskons,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
        id: json["id"],
        productId: json["productId"],
        varianId: json["varianId"],
        discountId: json["discountId"],
        customerId: json["customerId"],
        qty: json["qty"],
        created: json["created"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "productId": productId,
        "varianId": varianId,
        "discountId": discountId,
        "customerId": customerId,
        "qty": qty,
        "created": created,
      };
}

import 'package:kasir_dekstop/models/category_model.dart';
import 'package:kasir_dekstop/models/discount_model.dart';
import 'package:kasir_dekstop/models/varian_reesponse_model.dart';

class ProductsModel {
  final int? id;
  final String namaBarang;
  final int idCategory;
  final int idVarian;
  final String deskripsi;
  final String harga;
  final String sku;
  final String hargaModal;
  final String stock;
  final String createdAt;
  final List<VarianResponseModel>? varian;
  CategoryModel? categori;
  bool cheked;
  final PromoProductsModels? promoProducts;
  List<DiscountModel>? diskonModel;

  ProductsModel({
    this.id,
    required this.namaBarang,
    required this.idCategory,
    required this.idVarian,
    required this.deskripsi,
    required this.harga,
    required this.sku,
    required this.hargaModal,
    required this.stock,
    required this.createdAt,
    this.varian,
    this.categori,
    this.cheked = false,
    this.promoProducts,
    this.diskonModel,
  });

  Map<String, dynamic> toMap() => {
        "id": id,
        "namaBarang": namaBarang,
        "idCategory": idCategory,
        "idVarian": idVarian,
        "deskripsi": deskripsi,
        "harga": harga,
        "sku": sku,
        "hargaModal": hargaModal,
        "stock": stock,
        "createdAt": createdAt,
        "varian": varian,
        "categori": categori?.toJson(),
      };
}

class PromoModels {
  final int? id;
  final String? judul;
  final String? promoMulai;
  final String? promoBerakhir;

  PromoModels({
    this.id,
    required this.judul,
    required this.promoMulai,
    required this.promoBerakhir,
  });

  factory PromoModels.fromJson(Map<String, dynamic> json) => PromoModels(
        id: json["id"],
        judul: json["judul"],
        promoMulai: json["promoMulai"],
        promoBerakhir: json["promoBerakhir"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "judul": judul,
        "promoMulai": promoMulai,
        "promoBerakhir": promoBerakhir,
      };
}

class PromoProductsModels {
  final int? id;
  late String? idPromo;
  late String? idProduct;
  late String? hargaPromo;
  late String? discount;
  late String? minBelanja;
  PromoModels? promo;

  PromoProductsModels(
      {this.id,
      required this.idPromo,
      required this.idProduct,
      required this.hargaPromo,
      required this.discount,
      required this.minBelanja,
      this.promo});

  factory PromoProductsModels.fromJson(Map<String, dynamic> json) =>
      PromoProductsModels(
        id: json["id"],
        idPromo: json["idPromo"],
        idProduct: json["idProduct"],
        hargaPromo: json["hargaPromo"],
        discount: json["discount"],
        minBelanja: json["minBelanja"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "idPromo": idPromo,
        "idProduct": idProduct,
        "hargaPromo": hargaPromo,
        "discount": discount,
        "minBelanja": minBelanja,
      };
}

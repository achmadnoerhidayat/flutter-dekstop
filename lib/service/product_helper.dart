import 'dart:io';
import 'package:kasir_dekstop/models/adjustment_model.dart';
import 'package:kasir_dekstop/models/finance_model.dart';
import 'package:kasir_dekstop/models/shift_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:kasir_dekstop/models/bill_model.dart';
import 'package:kasir_dekstop/models/cart_model.dart';
import 'package:kasir_dekstop/models/gula_model.dart';
import 'package:kasir_dekstop/models/user_model.dart';
import 'package:kasir_dekstop/models/order_model.dart';
import 'package:kasir_dekstop/models/promo_model.dart';
import 'package:kasir_dekstop/models/varian_model.dart';
import 'package:kasir_dekstop/models/receipt_model.dart';
import 'package:kasir_dekstop/models/suplier_model.dart';
import 'package:kasir_dekstop/models/product_models.dart';
import 'package:kasir_dekstop/models/category_model.dart';
import 'package:kasir_dekstop/models/customer_model.dart';
import 'package:kasir_dekstop/models/discount_model.dart';
import 'package:kasir_dekstop/models/transaksi_model.dart';
import 'package:kasir_dekstop/models/debt_sugar_model.dart';
import 'package:kasir_dekstop/models/debt_watch_model.dart';
import 'package:kasir_dekstop/models/promo_product_model.dart';
import 'package:kasir_dekstop/models/varian_reesponse_model.dart';
import 'package:kasir_dekstop/models/transaksi_detail_model.dart';
// ignore: depend_on_referenced_packages

class ProductHelper {
  final databaseName = "rizkyPos.db";
  static final ProductHelper _instance = ProductHelper._internal();
  factory ProductHelper() => _instance;

  static Database? _db;

  ProductHelper._internal();

  // Future<Database> get db async {
  //   if (_db != null) return _db!;
  //   _db = await init();
  //   return _db!;
  // }

  // Inisialisasi database
  static Future<Database> getDatabase() async {
    if (_db != null) return _db!;
    sqfliteFfiInit(); // Inisialisasi sqflite_common_ffi untuk platform desktop
    // final databasePath = await getApplicationDocumentsDirectory();
    final executablePath = Directory.current.path;
    // final path = join(databasePath.path, "database", "rizkyPos.db");
    final path = join(executablePath, "database", "rizkyPos.db");
    // print(executablePath);
    var db = await databaseFactoryFfi.openDatabase(path);
    // Create products table
    await db.execute('''
          CREATE TABLE IF NOT EXISTS products (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            namaBarang TEXT NOT NULL,
            idCategory INTEGER,
            idVarian INTEGER,
            deskripsi TEXT NOT NULL,
            harga TEXT NOT NULL,
            sku TEXT NOT NULL,
            hargaModal TEXT,
            stock TEXT,
            createdAt TEXT
          )
        ''');

    // Create varian table
    await db.execute('''
          CREATE TABLE IF NOT EXISTS varian (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            idBarang TEXT NOT NULL,
            namaVarian TEXT NOT NULL,
            hargaVarian TEXT NOT NULL,
            skuVarian TEXT,
            stokVarian TEXT,
            hargaModalVarian TEXT
          )
        ''');

    // Create category table
    await db.execute('''
          CREATE TABLE IF NOT EXISTS category (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nama TEXT NOT NULL
          )
        ''');

    // Create discount table
    await db.execute('''
          CREATE TABLE IF NOT EXISTS discount (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nama TEXT NOT NULL,
            jumlah TEXT,
            type TEXT
          )
        ''');

    // Create promo table
    await db.execute('''
          CREATE TABLE IF NOT EXISTS promo (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            judul TEXT NOT NULL,
            promoMulai TEXT,
            promoBerakhir TEXT
          )
        ''');

    // Create promo product table
    await db.execute('''
          CREATE TABLE IF NOT EXISTS promoProduct (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            idPromo TEXT NOT NULL,
            idProduct TEXT NOT NULL,
            hargaPromo TEXT NOT NULL,
            discount TEXT NOT NULL,
            minBelanja TEXT
          )
        ''');

    // Create customer table
    await db.execute('''
          CREATE TABLE IF NOT EXISTS customer (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nama TEXT NOT NULL,
            phone TEXT,
            email TEXT,
            created TEXT
          )
        ''');

    // Create cart table
    await db.execute('''
          CREATE TABLE IF NOT EXISTS cart (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            productId TEXT,
            varianId TEXT,
            discountId TEXT,
            customerId TEXT,
            qty TEXT,
            created TEXT
          )
        ''');

    // Create user table
    await db.execute('''
          CREATE TABLE IF NOT EXISTS user (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nama TEXT NOT NULL,
            role TEXT,
            email TEXT,
            password TEXT,
            created TEXT
          )
        ''');

    // Create Transaksi table
    await db.execute('''
          CREATE TABLE IF NOT EXISTS transaksi (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            idUser TEXT,
            idCustomer TEXT,
            orderId TEXT,
            shiftId TEXT,
            totalGula TEXT,
            weightGula TEXT,
            priceBeliGula TEXT,
            priceJualGula TEXT,
            totalKasbon TEXT,
            setorKasbon TEXT,
            setorGula TEXT,
            totalHarga TEXT,
            bayar TEXT,
            kembalian TEXT,
            paymentType TEXT,
            created TEXT
          )
        ''');

    // Create Transaksi Detail table
    await db.execute('''
          CREATE TABLE IF NOT EXISTS transaksiDetail (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            idTransaksi TEXT,
            idProduct TEXT,
            idVarian TEXT,
            qty TEXT,
            hargaModal TEXT,
            hargaProduct TEXT,
            totalDiskon TEXT,
            created TEXT
          )
        ''');

    // Create receipt/struk table
    await db.execute('''
          CREATE TABLE IF NOT EXISTS receipt (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            namaToko TEXT NOT NULL,
            alamat TEXT,
            provinsi TEXT,
            kota TEXT,
            kodePos TEXT,
            phone TEXT,
            notes TEXT,
            created TEXT
          )
        ''');

    // Create bill table
    await db.execute('''
          CREATE TABLE IF NOT EXISTS bill (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            billName TEXT NOT NULL,
            note TEXT,
            created TEXT
          )
        ''');

    // Create billCart table
    await db.execute('''
          CREATE TABLE IF NOT EXISTS billCart (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            billId TEXT,
            productId TEXT,
            varianId TEXT,
            discountId TEXT,
            customerId TEXT,
            qty TEXT,
            created TEXT
          )
        ''');

    // Create gula table
    await db.execute('''
          CREATE TABLE IF NOT EXISTS gula (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            type TEXT,
            priceBeli TEXT,
            priceJual TEXT,
            created TEXT
          )
        ''');

    // Create finance table
    await db.execute('''
          CREATE TABLE IF NOT EXISTS finance (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            shiftId TEXT,
            type TEXT,
            nominal TEXT,
            note TEXT,
            created TEXT
          )
        ''');

    // Create hutang table
    await db.execute('''
          CREATE TABLE IF NOT EXISTS hutang (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            idCustomer TEXT,
            nominal TEXT,
            created TEXT
          )
        ''');

    // Create hutang detail table
    await db.execute('''
          CREATE TABLE IF NOT EXISTS hutangDetail (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            idHutang TEXT,
            type TEXT,
            nominal TEXT,
            note TEXT,
            created TEXT
          )
        ''');

    // Create kasbon table
    await db.execute('''
          CREATE TABLE IF NOT EXISTS kasbon (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            idCustomer TEXT,
            nominal TEXT,
            created TEXT
          )
        ''');

    // Create kasbon detail table
    await db.execute('''
          CREATE TABLE IF NOT EXISTS kasbonDetail (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            idKasbon TEXT,
            type TEXT,
            nominal TEXT,
            note TEXT,
            created TEXT
          )
        ''');

    // Create pembelian barang table
    await db.execute('''
          CREATE TABLE IF NOT EXISTS pembelianBarang (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            idSuplier TEXT,
            noFaktur TEXT,
            nominal TEXT,
            status TEXT,
            created TEXT
          )
        ''');

    // Create pembelian barang detail table
    await db.execute('''
          CREATE TABLE IF NOT EXISTS pembelianBarangDetail (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            idPembelian TEXT,
            idProduct TEXT,
            qty TEXT,
            stockBarang TEXT,
            created TEXT
          )
        ''');

    // Create suplier table
    await db.execute('''
          CREATE TABLE IF NOT EXISTS suplier (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            email TEXT,
            phone TEXT,
            created TEXT
          )
        ''');

    // Create shift table
    await db.execute('''
          CREATE TABLE IF NOT EXISTS shift (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            modal TEXT,
            startShift TEXT,
            endShift TEXT,
            totalUang TEXT,
            selisih TEXT,
            created TEXT
          )
        ''');

    // Create shift table
    await db.execute('''
          CREATE TABLE IF NOT EXISTS adjustment (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            note TEXT,
            created TEXT
          )
        ''');

    // Create shift table
    await db.execute('''
          CREATE TABLE IF NOT EXISTS adjustmentDetail (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            idAdjustment TEXT,
            idProduct TEXT,
            hargaModal TEXT,
            stock TEXT,
            adjustment TEXT,
            created TEXT
          )
        ''');

    return db;
  }

  Future<void> deleteDatabaseFile() async {
    var database = await getDatabase();
    // Mendapatkan path ke direktori databases di perangkat
    final databasePath = await getApplicationDocumentsDirectory();
    final path = "${databasePath.path}/$databaseName";

    // Menutup koneksi ke database jika ada yang terbuka
    await database.close();

    // Memeriksa apakah file database ada sebelum menghapusnya
    if (await File(path).exists()) {
      await deleteDatabase(path);
    } else {}
  }

  // Fungsi untuk generate order id
  Future<String> generateOrderId() async {
    // Mendapatkan tanggal saat ini
    DateTime now = DateTime.now();

    // Format tanggal menjadi string YYMMDD
    String formattedDate =
        "${now.year.toString().substring(2)}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}";

    // Mengambil data pesanan dengan tanggal hari ini dari SQLite
    var database = await getDatabase();
    List<Map<String, dynamic>> result = await database.query('transaksi',
        where: 'orderId LIKE ?', whereArgs: ['%$formattedDate%']);

    // Mendapatkan jumlah pesanan untuk tanggal saat ini
    int count = result.length + 1;

    // Membuat ID pesanan dengan format INV/YYMMDD/001, INV/YYMMDD/002, dst.
    String orderId = 'INV/$formattedDate/${count.toString().padLeft(3, '0')}';
    return orderId;
  }

  // Fungsi untuk generate order id
  Future<String> generateShiftd() async {
    String today = DateTime.now().toIso8601String().substring(0, 10);

    // Mengambil data pesanan dengan tanggal hari ini dari SQLite
    var database = await getDatabase();
    List<Map<String, dynamic>> result = await database.query('shift',
        where: 'created LIKE ? AND shift.endShift IS NULL',
        whereArgs: ['%$today%']);

    // Mendapatkan jumlah pesanan untuk tanggal saat ini
    var data = result.first;
    String shiftId = data['id'].toString();
    return shiftId;
  }

  //Register
  Future<int> register(UserModel user) async {
    var database = await getDatabase();
    int id = await database.insert("user", user.toJson());
    return id;
  }

  //Register
  Future<UserModel?> login(UserModel user) async {
    var database = await getDatabase();
    String sql =
        "SELECT * FROM user WHERE nama = '${user.nama}' AND password = '${user.password}'";
    List<Map<String, dynamic>> result = await database.rawQuery(sql);
    if (result.isNotEmpty) {
      var data = result.first;
      return UserModel(
        id: data['id'],
        nama: data['nama'],
        role: data['role'],
        email: data['email'],
        password: data['password'],
        created: data['created'],
      );
    }
    return null;
    // return id;
  }

  //Get Product
  Future<List<ProductsModel>> getProduct() async {
    List<DiscountModel> diskon = [];
    var database = await getDatabase();
    String sql =
        "SELECT p.id AS product_id, p.namaBarang AS product_name, p.deskripsi AS product_description, p.harga AS product_price, p.sku AS product_sku, p.hargaModal AS product_cost, p.stock AS product_stock, p.createdAt AS product_created_at, c.id AS category_id, c.nama AS category_name, v.id AS variant_id, v.namaVarian AS variant_name, v.hargaVarian AS variant_price, v.skuVarian AS variant_sku, v.stokVarian AS variant_stock, v.hargaModalVarian  AS variant_cost, pp.idPromo AS promo_id, pp.hargaPromo AS promo_price, pp.discount AS promo_discount, pp.minBelanja AS promo_min_purchase FROM products p LEFT JOIN category c ON p.idCategory = c.id LEFT JOIN varian v ON p.id = v.idBarang LEFT JOIN promoProduct pp ON p.id = pp.idProduct ORDER BY p.createdAt DESC";
    List<Map<String, dynamic>> result = await database.rawQuery(sql);
    diskon = await getDiscountProduct();
    final Map<String, ProductsModel> productMap = {};

    for (var row in result) {
      final productId = row['product_id'] as int;
      final productName = row['product_name'] as String;
      final productDescription = row['product_description'] as String;
      final productPrice = row['product_price'] as String;
      final productSku = row['product_sku'] as String;
      final productCost = row['product_cost'] as String?;
      final productStock = row['product_stock'] as String?;
      final productCreatedAt = row['product_created_at'] as String?;

      final categoryId = row['category_id'];
      final categoryName = row['category_name'] as String?;
      final variantId = row['variant_id'];
      final variantName = row['variant_name'] as String?;
      final variantPrice = row['variant_price'] as String?;
      final variantSku = row['variant_sku'] as String?;
      final variantStock = row['variant_stock'] as String?;
      final variantCost = row['variant_cost'] as String?;

      final promoId = row['promo_id'] as int?;
      final promoPrice = row['promo_price'] as String?;
      final promoDiscount = row['promo_discount'] as String?;
      final promoMinPurchase = row['promo_min_purchase'] as String?;
      ProductsModel product = productMap.putIfAbsent(
        productId.toString(),
        () => ProductsModel(
            id: productId,
            namaBarang: productName,
            idCategory: categoryId!,
            idVarian: variantId != null ? variantId! : 0,
            deskripsi: productDescription,
            harga: productPrice,
            sku: productSku,
            hargaModal: productCost!,
            stock: productStock!,
            createdAt: productCreatedAt!,
            categori: categoryName != null
                ? CategoryModel(id: categoryId, nama: categoryName)
                : null,
            varian: [],
            promoProducts:
                promoId != null && promoPrice != null && promoDiscount != null
                    ? PromoProductsModels(
                        id: promoId,
                        idProduct: productId.toString(),
                        idPromo: promoId.toString(),
                        hargaPromo: promoPrice,
                        discount: promoDiscount,
                        minBelanja: promoMinPurchase,
                      )
                    : null,
            diskonModel: diskon),
      );
      if (variantId != null && variantName != null) {
        product.varian!.add(
          VarianResponseModel(
            id: variantId,
            idBarang: productId.toString(),
            namaVarian: variantName,
            hargaVarian: variantPrice!,
            skuVarian: variantSku!,
            stokVarian: variantStock!,
            hargaModalVarian: variantCost!,
          ),
        );
      }
    }
    return productMap.values.toList();
  }

  //Get Search Product
  Future<List<ProductsModel>> getSearchProduct(String nama, String type) async {
    List<DiscountModel> diskon = [];
    var database = await getDatabase();
    String query =
        "SELECT p.id AS product_id, p.namaBarang AS product_name, p.deskripsi AS product_description, p.harga AS product_price, p.sku AS product_sku, p.hargaModal AS product_cost, p.stock AS product_stock, p.createdAt AS product_created_at, c.id AS category_id, c.nama AS category_name, v.id AS variant_id, v.namaVarian AS variant_name, v.hargaVarian AS variant_price, v.skuVarian AS variant_sku, v.stokVarian AS variant_stock, v.hargaModalVarian  AS variant_cost, pp.idPromo AS promo_id, pp.hargaPromo AS promo_price, pp.discount AS promo_discount, pp.minBelanja AS promo_min_purchase FROM products p LEFT JOIN category c ON p.idCategory = c.id LEFT JOIN varian v ON p.id = v.idBarang LEFT JOIN promoProduct pp ON p.id = pp.idProduct";
    if (type == 'search') {
      query += " WHERE p.namaBarang like '%$nama%' OR p.sku = '$nama'";
    } else {
      query += " WHERE p.sku = $nama";
    }
    query += " ORDER BY p.createdAt DESC";
    List<Map<String, dynamic>> result = await database.rawQuery(query);
    diskon = await getDiscountProduct();
    final Map<String, ProductsModel> productMap = {};

    for (var row in result) {
      final productId = row['product_id'] as int;
      final productName = row['product_name'] as String;
      final productDescription = row['product_description'] as String;
      final productPrice = row['product_price'] as String;
      final productSku = row['product_sku'] as String;
      final productCost = row['product_cost'] as String?;
      final productStock = row['product_stock'] as String?;
      final productCreatedAt = row['product_created_at'] as String?;

      final categoryId = row['category_id'];
      final categoryName = row['category_name'] as String?;
      final variantId = row['variant_id'];
      final variantName = row['variant_name'] as String?;
      final variantPrice = row['variant_price'] as String?;
      final variantSku = row['variant_sku'] as String?;
      final variantStock = row['variant_stock'] as String?;
      final variantCost = row['variant_cost'] as String?;

      final promoId = row['promo_id'] as int?;
      final promoPrice = row['promo_price'] as String?;
      final promoDiscount = row['promo_discount'] as String?;
      final promoMinPurchase = row['promo_min_purchase'] as String?;
      ProductsModel product = productMap.putIfAbsent(
        productId.toString(),
        () => ProductsModel(
            id: productId,
            namaBarang: productName,
            idCategory: categoryId!,
            idVarian: variantId != null ? variantId! : 0,
            deskripsi: productDescription,
            harga: productPrice,
            sku: productSku,
            hargaModal: productCost!,
            stock: productStock!,
            createdAt: productCreatedAt!,
            categori: categoryName != null
                ? CategoryModel(id: categoryId, nama: categoryName)
                : null,
            varian: [],
            promoProducts:
                promoId != null && promoPrice != null && promoDiscount != null
                    ? PromoProductsModels(
                        id: promoId,
                        idProduct: productId.toString(),
                        idPromo: promoId.toString(),
                        hargaPromo: promoPrice,
                        discount: promoDiscount,
                        minBelanja: promoMinPurchase,
                      )
                    : null,
            diskonModel: diskon),
      );
      if (variantId != null && variantName != null) {
        product.varian!.add(
          VarianResponseModel(
            id: variantId,
            idBarang: productId.toString(),
            namaVarian: variantName,
            hargaVarian: variantPrice!,
            skuVarian: variantSku!,
            stokVarian: variantStock!,
            hargaModalVarian: variantCost!,
          ),
        );
      }
    }
    return productMap.values.toList();
  }

  //Get show Transaksi
  Future<ProductsModel?> showProduct(int idProduct) async {
    ProductsModel? lists;
    CategoryModel? categori;
    PromoProductsModels? promoProduct;
    var database = await getDatabase();
    List<Map<String, dynamic>> result = await database.query("products",
        where: "id = ?", whereArgs: [idProduct], limit: 1);
    var dat = result.first;
    String idCategory = '${dat['idCategory']}';
    categori = await getCategoriProduct(idCategory);
    promoProduct = await getPromoByIdProduct(idProduct.toString());
    lists = ProductsModel(
      id: dat['id'],
      namaBarang: dat['namaBarang'],
      idCategory: dat['idCategory'],
      idVarian: dat['idVarian'],
      deskripsi: dat['deskripsi'],
      harga: dat['harga'],
      sku: dat['sku'],
      hargaModal: dat['hargaModal'],
      stock: dat['stock'],
      createdAt: dat['createdAt'],
      categori: categori,
      promoProducts: promoProduct,
    );
    // print("Ini ${lists.length}");
    return lists;
  }

  //Get Search Product
  Future<List<ProductsModel>> getKategoriProduct(String idKategori) async {
    List<ProductsModel>? lists;
    List<VarianResponseModel> varianModel = [];
    List<DiscountModel> diskon = [];
    CategoryModel? categori;
    PromoProductsModels? promoProduct;
    var database = await getDatabase();
    List<Map<String, dynamic>> result = await database
        .query("products", where: "idCategory = ?", whereArgs: [idKategori]);
    diskon = await getDiscountProduct();
    lists = [];
    for (var i = 0; i < result.length; i++) {
      String id = '${result[i]['id']}';
      String idCategory = '${result[i]['idCategory']}';
      varianModel = await getProductVarian(id);
      categori = await getCategoriProduct(idCategory);
      promoProduct = await getPromoByIdProduct(id);
      if (promoProduct != null) {
        lists.add(ProductsModel(
          id: result[i]['id'],
          namaBarang: result[i]['namaBarang'],
          idCategory: result[i]['idCategory'],
          idVarian: result[i]['idVarian'],
          deskripsi: result[i]['deskripsi'],
          harga: result[i]['harga'],
          sku: result[i]['sku'],
          hargaModal: result[i]['hargaModal'],
          stock: result[i]['stock'],
          createdAt: result[i]['createdAt'],
          varian: varianModel,
          categori: categori,
          promoProducts: promoProduct,
          diskonModel: diskon,
        ));
      } else {
        lists.add(ProductsModel(
          id: result[i]['id'],
          namaBarang: result[i]['namaBarang'],
          idCategory: result[i]['idCategory'],
          idVarian: result[i]['idVarian'],
          deskripsi: result[i]['deskripsi'],
          harga: result[i]['harga'],
          sku: result[i]['sku'],
          hargaModal: result[i]['hargaModal'],
          stock: result[i]['stock'],
          createdAt: result[i]['createdAt'],
          varian: varianModel,
          categori: categori,
          diskonModel: diskon,
        ));
      }
    }
    return lists;
  }

  //Insert product
  Future<int> insertProduct(ProductsModel product) async {
    var database = await getDatabase();
    var request = {
      "namaBarang": product.namaBarang,
      "idCategory": product.idCategory,
      "idVarian": product.idVarian,
      "deskripsi": product.deskripsi,
      "harga": product.harga,
      "sku": product.sku,
      "hargaModal": product.hargaModal,
      "stock": product.stock,
      "createdAt": product.createdAt
    };
    int id = await database.insert("products", request);
    return id;
  }

  //Insert product
  Future<int> updateProduct(ProductsModel product) async {
    try {
      var database = await getDatabase();
      int id = await database.rawUpdate(
          "update products set namaBarang = ?, idCategory = ?, deskripsi = ?, harga = ?, sku = ?, hargaModal = ?, stock = ? where id = ?",
          [
            product.namaBarang,
            product.idCategory,
            product.deskripsi,
            product.harga,
            product.sku,
            product.hargaModal,
            product.stock,
            product.id
          ]);
      List<VarianResponseModel> reqVarian = [];
      int idBarang = 0;
      if (product.id != null) {
        idBarang = product.id!;
      }
      if (product.varian != null) {
        reqVarian = product.varian!;
      }
      if (reqVarian.isNotEmpty) {
        await updateProductVarian(reqVarian, idBarang);
      }
      return id;
    } catch (e) {
      // print("error ya apa ? $e");
    }
    return 0;
  }

  Future<int> deleteProduct(ProductsModel product) async {
    var database = await getDatabase();
    int id = await database
        .delete("products", where: "id = ?", whereArgs: [product.id]);
    await database
        .delete("varian", where: "idBarang = ?", whereArgs: [product.id]);
    return id;
  }

  //Get Varian
  Future<List<VarianResponseModel>> getProductVarian(String idBarang) async {
    var database = await getDatabase();
    List<Map<String, Object?>> result = await database
        .rawQuery("select * from varian where idBarang = ?", [idBarang]);
    var list = result.map((e) => VarianResponseModel.fromJson(e)).toList();
    return list;
  }

  //Get show Transaksi
  Future<VarianModel?> showVarian(int idVarian) async {
    VarianModel? lists;
    var database = await getDatabase();
    List<Map<String, dynamic>> result = await database.query("varian",
        where: "id = ?", whereArgs: [idVarian], limit: 1);
    var dat = result.first;
    lists = VarianModel(
      id: "${dat['id']}",
      namaVarian: dat['namaVarian'],
      hargaVarian: dat['hargaVarian'],
      skuVarian: dat['skuVarian'],
      stokVarian: dat['stokVarian'],
    );
    // print("Ini ${lists.length}");
    return lists;
  }

  //Insert product varian
  Future<int> insertProductVarian(
      List<VarianModel> product, int idBarang) async {
    var database = await getDatabase();
    // ignore: avoid_function_literals_in_foreach_calls
    product.forEach((val) async {
      var map = {
        'idBarang': idBarang,
        'namaVarian': val.namaVarian,
        'hargaVarian': val.hargaVarian,
        'skuVarian': val.skuVarian,
        'stokVarian': val.stokVarian,
        'hargaModalVarian': val.hargaModalVarian
      };
      await database.insert("varian", map);
    });
    return idBarang;
  }

  // update product varian
  Future<int> updateProductVarian(
      List<VarianResponseModel> product, int idBarang) async {
    var database = await getDatabase();
    // ignore: avoid_function_literals_in_foreach_calls
    product.forEach((val) async {
      if (val.id == 0) {
        var map = {
          'idBarang': idBarang,
          'namaVarian': val.namaVarian,
          'hargaVarian': val.hargaVarian,
          'skuVarian': val.skuVarian,
          'stokVarian': val.stokVarian,
          'hargaModalVarian': val.hargaModalVarian
        };
        await database.insert("varian", map);
      } else {
        await database.rawUpdate(
            "update varian set namaVarian = ?, hargaVarian = ?, skuVarian = ?, stokVarian = ?, hargaModalVarian = ? where id = ?",
            [
              val.namaVarian,
              val.hargaVarian,
              val.skuVarian,
              val.stokVarian,
              val.hargaModalVarian,
              val.id
            ]);
      }
    });
    return idBarang;
  }

  Future<int> deleteVarian(int idBarang) async {
    var database = await getDatabase();
    int id =
        await database.delete("varian", where: "id = ?", whereArgs: [idBarang]);
    return id;
  }

  //Get Categori
  Future<List<CategoryModel>> getCategori() async {
    List<CategoryModel> lists = [];
    try {
      var database = await getDatabase();
      List<Map<String, dynamic>> result = await database.query("category");
      for (var i = 0; i < result.length; i++) {
        lists.add(CategoryModel(
          id: result[i]['id'],
          nama: result[i]['nama'],
        ));
      }
      return lists;
    } catch (e) {
      // print("eroor apa ? $e");
    }
    return lists;
  }

  //Get Categori
  Future<List<CategoryModel>> getCategoriKasir() async {
    List<CategoryModel> lists = [];
    lists.add(CategoryModel(nama: "All Category", id: 0, status: true));
    try {
      var database = await getDatabase();
      List<Map<String, dynamic>> result = await database.query("category");
      for (var i = 0; i < result.length; i++) {
        lists.add(CategoryModel(
          id: result[i]['id'],
          nama: result[i]['nama'],
        ));
      }
      return lists;
    } catch (e) {
      // print("eroor apa ? $e");
    }
    return lists;
  }

  //Get Categori Product
  Future<CategoryModel?> getCategoriProduct(String idCategori) async {
    CategoryModel? lists;
    try {
      var database = await getDatabase();
      final result = await database
          .rawQuery("select * from category where id = ?", [idCategori]);

      return CategoryModel.fromJson(result.first);
    } catch (e) {
      // print("eroor apa ? $e");
    }
    return lists;
  }

  //Insert product varian
  Future<int> insertCategori(CategoryModel categori) async {
    try {
      var database = await getDatabase();
      int id = await database.insert("category", categori.toJson());
      return id;
    } catch (e) {
      // print("$e");
    }
    return 0;
  }

  //Update Categori
  Future<int> updateCategori(CategoryModel categori) async {
    try {
      var database = await getDatabase();
      int id = await database.rawUpdate(
          "update category set nama = ? where id = ?",
          [categori.nama, categori.id]);
      return id;
    } catch (e) {
      // print("$e");
    }
    return 0;
  }

  //Update Categori
  Future<int> deleteCategori(int idCategori) async {
    try {
      var database = await getDatabase();
      int id = await database
          .delete("category", where: "id = ?", whereArgs: [idCategori]);
      return id;
    } catch (e) {
      // print("$e");
    }
    return 0;
  }

  //Get Discount Product
  Future<List<DiscountModel>> getDiscountProduct() async {
    List<DiscountModel> lists = [];
    try {
      var database = await getDatabase();
      List<Map<String, dynamic>> result = await database.query("discount");
      for (var i = 0; i < result.length; i++) {
        lists.add(DiscountModel(
          id: result[i]['id'],
          nama: result[i]['nama'],
          jumlah: result[i]['jumlah'],
          type: result[i]['type'],
        ));
      }
      return lists;
    } catch (e) {
      // print("eroor apa ? $e");
    }
    return lists;
  }

  // create discount
  Future<int> insertDiscount(DiscountModel discountModel) async {
    try {
      var database = await getDatabase();
      int id = await database.insert("discount", discountModel.toJson());
      return id;
    } catch (e) {
      // print("$e");
    }
    return 0;
  }

  //Update Discount
  Future<int> updateDiscount(DiscountModel discountModel) async {
    try {
      var database = await getDatabase();
      int id = await database.rawUpdate(
          "update discount set nama = ?, jumlah = ?, type = ? where id = ?", [
        discountModel.nama,
        discountModel.jumlah,
        discountModel.type,
        discountModel.id
      ]);
      return id;
    } catch (e) {
      // print("$e");
    }
    return 0;
  }

  //Delete Discount
  Future<int> deleteDiscount(int idDiscount) async {
    try {
      var database = await getDatabase();
      int id = await database
          .delete("discount", where: "id = ?", whereArgs: [idDiscount]);
      return id;
    } catch (e) {
      // print("$e");
    }
    return 0;
  }

  //Get Customer
  Future<List<CustomerModel>> getCustomer(String? search) async {
    String sql =
        "SELECT c.id AS cus_id, c.nama AS cus_nama, c.phone AS cus_phone, c.email AS cus_email, c.created AS cus_created, k.id AS kas_id, k.idCustomer AS kas_customer, k.nominal AS kas_nominal, k.created AS kas_created FROM customer c LEFT JOIN kasbon k ON k.idCustomer = c.id ";
    if (search != null) {
      sql += "WHERE c.nama LIKE '%$search%'";
    }
    sql += " ORDER BY c.nama ASC";
    List<CustomerModel> lists = [];
    try {
      var database = await getDatabase();
      List<Map<String, dynamic>> result = await database.rawQuery(sql);
      for (var row in result) {
        final custId = row['cus_id'] as int?;
        final custNama = row['cus_nama'] as String?;
        final custPhone = row['cus_phone'] as String?;
        final custEmail = row['cus_email'] as String?;
        final cusCreated = row['cus_created'] as String?;

        final kasId = row['kas_id'] as int?;
        final kasCus = row['kas_customer'] as String?;
        final kasNominal = row['kas_nominal'] as String?;
        final kasCreated = row['kas_created'] as String?;
        lists.add(
          CustomerModel(
              id: custId,
              nama: custNama,
              phone: custPhone,
              email: custEmail,
              created: cusCreated,
              kasbon: kasId != null
                  ? DebtWatchModel(
                      id: kasId,
                      idCustomer: kasCus,
                      nominal: kasNominal,
                      created: kasCreated)
                  : null),
        );
      }
      return lists;
    } catch (e) {
      // print("eroor apa ? $e");
    }
    return lists;
  }

  // create customer
  Future<int> insertCustomer(CustomerModel customerModel) async {
    try {
      var database = await getDatabase();
      int id = await database.insert("customer", customerModel.toJson());
      return id;
    } catch (e) {
      // print("$e");
    }
    return 0;
  }

  //Update customer
  Future<int> updateCustomer(CustomerModel customer) async {
    try {
      var database = await getDatabase();
      int id = await database.rawUpdate(
          "update customer set nama = ?, phone = ?, email = ? where id = ?",
          [customer.nama, customer.phone, customer.email, customer.id]);
      return id;
    } catch (e) {
      // print("$e");
    }
    return 0;
  }

  //Delete Discount
  Future<int> deleteCustomer(int idCustomer) async {
    try {
      var database = await getDatabase();
      int id = await database
          .delete("customer", where: "id = ?", whereArgs: [idCustomer]);
      return id;
    } catch (e) {
      // print("$e");
    }
    return 0;
  }

  //Get Promo
  Future<List<PromoModel>> getPromo() async {
    List<PromoModel> lists = [];
    var database = await getDatabase();
    List<Map<String, dynamic>> result = await database.query("promo");
    for (var i = 0; i < result.length; i++) {
      String idPromo = "${result[i]['id']}";
      var promoProduct = await getPromoProduct(idPromo);
      lists.add(PromoModel(
          id: result[i]['id'],
          judul: result[i]['judul'],
          promoMulai: result[i]['promoMulai'],
          promoBerakhir: result[i]['promoBerakhir'],
          promoProdact: promoProduct));
    }
    // print("Ini ${lists.length}");
    return lists;
  }

  //Get Show Promo
  Future<PromoModels?> getPromoById(String idPromo) async {
    PromoModels? lists;
    var database = await getDatabase();
    List<Map<String, dynamic>> result =
        await database.rawQuery("select * FROM promo where id = ?", [idPromo]);
    for (var i = 0; i < result.length; i++) {
      lists = PromoModels(
        id: result[i]['id'],
        judul: result[i]['judul'],
        promoMulai: result[i]['promoMulai'],
        promoBerakhir: result[i]['promoBerakhir'],
      );
    }
    return lists;
  }

  // create Promo Product
  Future<int> insertPromo(PromoModel promoModel) async {
    try {
      var database = await getDatabase();
      int id = await database.insert("promo", promoModel.toJson());
      if (promoModel.promoProdact!.isNotEmpty) {
        for (var prod in promoModel.promoProdact!) {
          prod.idPromo = id.toString();
          insertPromoProduct(prod);
        }
      }
      return id;
    } catch (e) {
      // print("$e");
    }
    return 0;
  }

  //Update Promo
  Future<int> updatePromo(PromoModel promo) async {
    try {
      var database = await getDatabase();
      int id = await database.rawUpdate(
          "update promo set judul = ?, promoMulai = ?, promoBerakhir = ? where id = ?",
          [promo.judul, promo.promoMulai, promo.promoBerakhir, promo.id]);
      return id;
    } catch (e) {
      // print("$e");
    }
    return 0;
  }

  //Get Promo Product
  Future<List<PromoProductModel>> getPromoProduct(String promoId) async {
    List<PromoProductModel> lists = [];
    var database = await getDatabase();
    List<Map<String, dynamic>> result = await database
        .rawQuery("select * FROM promoProduct where idPromo = ?", [promoId]);
    for (var i = 0; i < result.length; i++) {
      lists.add(PromoProductModel(
        id: result[i]['id'],
        idPromo: result[i]['idPromo'],
        idProduct: result[i]['idProduct'],
        hargaPromo: result[i]['hargaPromo'],
        discount: result[i]['discount'],
        minBelanja: result[i]['minBelanja'],
      ));
    }
    return lists;
  }

  //Get Promo Product
  Future<PromoProductsModels?> getPromoByIdProduct(String idProduct) async {
    PromoProductsModels? lists;
    late PromoModels? promo;
    var database = await getDatabase();
    List<Map<String, dynamic>> result = await database.rawQuery(
        "select * FROM promoProduct where idProduct = ?", [idProduct]);
    for (var i = 0; i < result.length; i++) {
      String id = "${result[i]['id']}";
      promo = await getPromoById(id);
      lists = PromoProductsModels(
          id: result[i]['id'],
          idPromo: result[i]['idPromo'],
          idProduct: result[i]['idProduct'],
          hargaPromo: result[i]['hargaPromo'],
          discount: result[i]['discount'],
          minBelanja: result[i]['minBelanja'],
          promo: promo);
    }
    return lists;
  }

  // create Promo Product
  Future<int> insertPromoProduct(PromoProductModel promoModel) async {
    try {
      var database = await getDatabase();
      int id = await database.insert("promoProduct", promoModel.toJson());
      return id;
    } catch (e) {
      // print("$e");
    }
    return 0;
  }

  //Update Promo product
  Future<int> updatePromoproduct(PromoProductModel productModel) async {
    try {
      var database = await getDatabase();
      int id = await database.rawUpdate(
          "update promoProduct set idPromo = ?, idProduct = ?, hargaPromo = ?, discount = ?, minBelanja = ?  where id = ?",
          [
            productModel.idPromo,
            productModel.idProduct,
            productModel.hargaPromo,
            productModel.discount,
            productModel.minBelanja,
            productModel.id
          ]);
      return id;
    } catch (e) {
      // print("$e");
    }
    return 0;
  }

  //Delete Discount
  Future<int> deletePromo(int idPromo) async {
    try {
      var database = await getDatabase();
      int id =
          await database.delete("promo", where: "id = ?", whereArgs: [idPromo]);
      await database
          .delete("promoProduct", where: "idPromo = ?", whereArgs: [idPromo]);
      return id;
    } catch (e) {
      // print("$e");
    }
    return 0;
  }

  // create cart Product
  Future<int> addKernjang(CartModel cart) async {
    try {
      var keranjang = await getCart();
      var barang = keranjang.firstWhere(
        (value) =>
            value.productId == cart.productId &&
            value.varianId == cart.varianId,
        orElse: () => CartModel(productId: null, qty: null, created: null),
      );
      if (barang.productId != null) {
        var total = int.parse(barang.qty!) + 1;
        var request = CartModel(
            id: barang.id,
            productId: barang.productId,
            varianId: barang.varianId,
            discountId: barang.discountId,
            customerId: barang.customerId,
            qty: total.toString(),
            created: barang.created);
        int id = await updateCart(request);
        return id;
      } else {
        int id = await insertCart(cart);
        return id;
      }
    } catch (e) {
      // print("$e");
    }
    return 0;
  }

  Future<int> insertCart(CartModel cart) async {
    try {
      var database = await getDatabase();
      int id = await database.insert("cart", cart.toJson());
      return id;
    } catch (e) {
      // print("$e");
    }
    return 0;
  }

  //Get Promo Product
  Future<List<CartModel>> getCart() async {
    List<CartModel>? lists;
    List<DiscountModel>? diskons;
    PromoProductsModels? promoProduct;
    var database = await getDatabase();
    lists = [];
    List<Map<String, dynamic>> result = await database.rawQuery(
        '''select cart.id AS cart_id, cart.productId, cart.varianId, cart.discountId, cart.customerId, cart.qty, cart.created, products.id AS product_id, products.namaBarang, products.idCategory, products.idVarian, products.deskripsi, products.harga, products.sku, products.hargaModal, products.stock, products.createdAt,varian.id AS varian_id,varian.idBarang,varian.namaVarian,varian.hargaVarian,varian.skuVarian,varian.hargaModalVarian,varian.stokVarian,discount.id AS disc_id,discount.nama AS disc_nama,discount.jumlah AS disc_jumlah,discount.type,customer.id AS cust_id,customer.nama AS cust_nama, customer.phone AS cust_phone,customer.email AS cust_email,customer.created AS cust_created FROM cart LEFT JOIN products ON cart.productId = products.id LEFT JOIN varian ON cart.varianId = varian.id LEFT JOIN discount ON cart.discountId = discount.id LEFT JOIN customer ON cart.customerId = customer.id ORDER BY cart.id DESC''');
    List<VarianResponseModel> varianModel = [];
    int subtotal = 0;
    for (var i = 0; i < result.length; i++) {
      double harga = 0;
      // int id = await deleteCart(result[i]['cart_id']);
      // print(id);
      VarianModel? varian;
      varianModel = await getProductVarian(result[i]['productId']);
      diskons = await getDiscountProduct();
      promoProduct = await getPromoByIdProduct("${result[i]['productId']}");
      if (result[i]['varianId'] != null) {
        varian = VarianModel(
          id: result[i]['varian_id'].toString(),
          namaVarian: result[i]['namaVarian'],
          hargaVarian: result[i]['hargaVarian'],
          skuVarian: result[i]['skuVarian'],
          stokVarian: result[i]['stokVarian'],
          hargaModalVarian: result[i]['hargaModalVarian'],
        );
        for (var varians in varianModel) {
          if (result[i]['varianId'] != null) {
            harga = int.parse(result[i]['hargaVarian']) *
                double.parse(result[i]['qty']);
            if (int.parse(result[i]['varianId']) == varians.id) {
              varians.status = true;
            }
          }
        }
      } else {
        harga = int.parse(result[i]['harga']) * double.parse(result[i]['qty']);
      }
      if (result[i]['discountId'] != null) {
        for (var disk in diskons) {
          if (result[i]['discountId'] != null) {
            if (int.parse(result[i]['discountId']) == disk.id) {
              disk.status = true;
            }
          }
        }
      }
      subtotal += harga.toInt();
      lists.add(CartModel(
        id: result[i]['cart_id'],
        productId: result[i]['productId'],
        varianId: result[i]['varianId'],
        discountId: result[i]['discountId'],
        customerId: result[i]['customerId'],
        qty: result[i]['qty'],
        created: result[i]['created'],
        varian: varian,
        product: (result[i]['product_id'] == null)
            ? null
            : ProductsModel(
                id: result[i]['product_id'],
                namaBarang: result[i]['namaBarang'],
                idCategory: result[i]['idCategory'],
                idVarian: result[i]['idVarian'],
                deskripsi: result[i]['deskripsi'],
                harga: result[i]['harga'],
                sku: result[i]['sku'],
                hargaModal: result[i]['hargaModal'],
                stock: result[i]['stock'],
                createdAt: result[i]['createdAt'],
                varian: varianModel,
                promoProducts: promoProduct,
              ),
        discon: (result[i]['disc_nama'] == null)
            ? null
            : DiscountModel(
                id: result[i]['disc_id'],
                nama: result[i]['disc_nama'],
                jumlah: result[i]['disc_jumlah'],
                type: result[i]['type']),
        customer: (result[i]['cust_nama'] == null)
            ? null
            : CustomerModel(
                nama: result[i]['cust_nama'],
                phone: result[i]['cust_phone'],
                email: result[i]['cust_email'],
                created: result[i]['cust_created']),
        subtotal: subtotal.toString(),
        diskons: diskons,
      ));
    }
    return lists;
  }

  //Update Cart product
  Future<int> updateCart(CartModel cart) async {
    try {
      var database = await getDatabase();
      int id = await database.rawUpdate(
          "update cart set customerId = ?, discountId = ?, varianId = ?, qty = ? where id = ?",
          [cart.customerId, cart.discountId, cart.varianId, cart.qty, cart.id]);
      return id;
    } catch (e) {
      // print("$e");
    }
    return 0;
  }

  //Delete Discount
  Future<int> deleteCart(int idCart) async {
    try {
      var database = await getDatabase();
      int id =
          await database.delete("cart", where: "id = ?", whereArgs: [idCart]);
      return id;
    } catch (e) {
      // print("$e");
    }
    return 0;
  }

  //Get Bill
  Future<List<BillModel>> getBill() async {
    // List<BillModel> lists = [];
    var database = await getDatabase();
    String sql =
        "SELECT b.id AS bil_id, b.billName AS bil_name, b.note AS bil_note, b.created AS bil_created, c.id AS bchart_id, c.varianId AS bchart_variant, c.qty AS bchart_qty, c.discountId AS bchart_discount, c.created AS bchart_created, p.id AS product_id, p.idCategory AS prooduct_categori, p.idVarian AS product_varian, p.namaBarang AS product_name, p.deskripsi AS product_description, p.harga AS product_price, p.sku AS product_sku, p.hargaModal AS product_cost, p.stock AS product_stock, p.createdAt AS product_created_at, v.id AS variant_id, v.namaVarian AS variant_name, v.hargaVarian AS variant_price, v.skuVarian AS variant_sku, v.stokVarian AS variant_stock, v.hargaModalVarian  AS variant_cost FROM bill AS b LEFT JOIN billCart c ON c.billId = b.id LEFT JOIN products p ON p.id = c.productId LEFT JOIN varian v ON v.id = c.varianId";
    List<Map<String, dynamic>> result = await database.rawQuery(sql);
    final Map<String, BillModel> billMap = {};
    for (var row in result) {
      final bilId = row['bil_id'] as int;
      final billName = row['bil_name'] as String;
      final billNote = row['bil_note'] as String;
      final billCreated = row['bil_created'] as String;

      final billChartId = row['bchart_id'];
      final billChartVariant = row['bchart_variant'] as String?;
      final billChartDiskon = row['bchart_discount'] as String?;
      final billChartQty = row['bchart_qty'] as String?;
      final billChartCreated = row['bchart_created'] as String?;

      final productId = row['product_id'] as int;
      final productName = row['product_name'] as String;
      final productCat = row['prooduct_categori'] as int;
      final productVar = row['product_varian'] as int;
      final productDescription = row['product_description'] as String;
      final productPrice = row['product_price'] as String;
      final productSku = row['product_sku'] as String;
      final productCost = row['product_cost'] as String?;
      final productStock = row['product_stock'] as String?;
      final productCreatedAt = row['product_created_at'] as String?;

      final variantId = row['variant_id'];
      final variantName = row['variant_name'] as String?;
      final variantPrice = row['variant_price'] as String?;
      final variantSku = row['variant_sku'] as String?;
      final variantStock = row['variant_stock'] as String?;
      final variantCost = row['variant_cost'] as String?;

      BillModel bill = billMap.putIfAbsent(
        bilId.toString(),
        () => BillModel(
            id: bilId,
            billName: billName,
            note: billNote,
            created: billCreated,
            billCart: []),
      );
      if (billChartId != null) {
        bill.billCart!.add(
          BillCartModel(
            billId: billChartId.toString(),
            productId: productId.toString(),
            varianId: billChartVariant,
            discountId: billChartDiskon,
            customerId: null,
            qty: billChartQty,
            created: billChartCreated,
            varian: variantId != null
                ? VarianModel(
                    id: variantId.toString(),
                    namaVarian: variantName!,
                    hargaVarian: variantPrice!,
                    skuVarian: variantSku!,
                    stokVarian: variantStock!,
                    hargaModalVarian: variantCost!,
                  )
                : null,
            product: ProductsModel(
              id: productId,
              namaBarang: productName,
              idCategory: productCat,
              idVarian: productVar,
              deskripsi: productDescription,
              harga: productPrice,
              sku: productSku,
              hargaModal: productCost!,
              stock: productStock!,
              createdAt: productCreatedAt!,
            ),
          ),
        );
      }
    }
    return billMap.values.toList();
  }

  // insert bill
  Future<int> insertBill(BillModel bil) async {
    try {
      var database = await getDatabase();
      int id = await database.insert("bill", bil.toJson());
      if (bil.billCart != null) {
        bil.billCart?.forEach((value) async {
          value.billId = id.toString();
          await insertBillCart(value);
        });
      }
      return id;
    } catch (e) {
      // print("$e");
    }
    return 0;
  }

  // insert bill
  Future<int> insertBillCart(BillCartModel bil) async {
    try {
      var database = await getDatabase();
      int id = await database.insert("billCart", bil.toJson());
      return id;
    } catch (e) {
      // print("$e");
    }
    return 0;
  }

  //Get Bill
  Future<List<BillCartModel>> showBillcart(int idBill) async {
    List<BillCartModel> lists = [];
    try {
      var database = await getDatabase();
      List<Map<String, dynamic>> result = await database.query("billCart",
          where: "billId = ?", whereArgs: [idBill.toString()]);
      for (var i = 0; i < result.length; i++) {
        int idProduct = int.parse(result[i]['productId']);
        var products = await showProduct(idProduct);
        VarianModel? varian;
        if (result[i]['varianId'] != null) {
          int idVarian = int.parse(result[i]['varianId']);
          varian = await showVarian(idVarian);
        }
        lists.add(BillCartModel(
          id: result[i]['id'],
          billId: result[i]['billId'],
          productId: result[i]['productId'],
          varianId: result[i]['varianId'],
          discountId: result[i]['discountId'],
          customerId: result[i]['customerId'],
          qty: result[i]['qty'],
          created: result[i]['created'],
          varian: varian,
          product: products,
        ));
      }
      return lists;
    } catch (e) {
      // print("eroor apa ? $e");
    }
    return lists;
  }

  //Delete Discount
  Future<int> deleteBill(int idBill) async {
    try {
      var database = await getDatabase();
      int id =
          await database.delete("bill", where: "id = ?", whereArgs: [idBill]);
      await database
          .delete("billCart", where: "billId = ?", whereArgs: [idBill]);
      return id;
    } catch (e) {
      // print("$e");
    }
    return 0;
  }

  //Get Transaksi
  Future<List<TransaksiModel>> getTransaksi() async {
    List<TransaksiModel> lists = [];
    ReceiptModel? receipt;
    var database = await getDatabase();
    String today = DateTime.now().toIso8601String().substring(0, 10);
    List<Map<String, dynamic>> result = await database.rawQuery('''
      SELECT transaksi.id, transaksi.idUser,transaksi.idCustomer,transaksi.orderId,transaksi.shiftId,transaksi.totalGula,transaksi.weightGula,transaksi.priceBeliGula,transaksi.priceJualGula,transaksi.totalKasbon,transaksi.setorKasbon,transaksi.setorGula,transaksi.totalHarga,transaksi.bayar,transaksi.kembalian,transaksi.paymentType,transaksi.created, customer.nama, customer.phone, customer.email, customer.created AS date, user.id AS userId, user.nama AS userNama, user.role, user.email AS userEmail, user.password, user.created AS userCreated FROM transaksi LEFT JOIN customer ON customer.id = transaksi.idCustomer LEFT JOIN user ON user.id = transaksi.idUser WHERE transaksi.created LIKE '$today%' ORDER BY transaksi.created DESC
    ''');
    receipt = await getReceipt();
    for (var i = 0; i < result.length; i++) {
      // int transId = await deleteTrans(result[i]['id']);
      // print(transId);
      var transDetail = await getTransaksDetailiByIdTrans(result[i]['id']);
      lists.add(TransaksiModel(
        id: result[i]['id'],
        idUser: result[i]['idUser'],
        idCustomer: result[i]['idCustomer'],
        orderId: result[i]['orderId'],
        shiftId: result[i]['shiftId'],
        totalGula: result[i]["totalGula"],
        weightGula: result[i]["weightGula"],
        priceBeliGula: result[i]["priceBeliGula"],
        priceJualGula: result[i]["priceJualGula"],
        totalKasbon: result[i]["totalKasbon"],
        setorKasbon: result[i]["setorKasbon"],
        setorGula: result[i]["setorGula"],
        totalHarga: result[i]['totalHarga'],
        bayar: result[i]['bayar'],
        kembalian: result[i]['kembalian'],
        paymentType: result[i]['paymentType'],
        created: result[i]['created'],
        customer: CustomerModel(
            nama: result[i]['nama'],
            phone: result[i]['phone'],
            email: result[i]['email'],
            created: result[i]['date']),
        detail: transDetail,
        receipt: receipt,
        user: UserModel(
          nama: result[i]['userNama'],
          role: result[i]['role'],
          email: result[i]['userEmail'],
          password: result[i]['password'],
          created: result[i]['userCreated'],
        ),
      ));
    }
    // print("Ini ${lists.length}");
    return lists;
  }

  //Get Transaksi
  Future<List<TransaksiHariModel>> getTransaksiHari() async {
    List<TransaksiHariModel> lists = [];
    var database = await getDatabase();
    List<Map<String, dynamic>> result = await database.rawQuery('''
        WITH days AS (SELECT 'Minggu' AS hari, '0' AS strftime_value UNION ALL SELECT 'Senin', '1' UNION ALL SELECT 'Selasa', '2' UNION ALL SELECT 'Rabu', '3' UNION ALL SELECT 'Kamis', '4' UNION ALL SELECT 'Jumat', '5' UNION ALL SELECT 'Sabtu', '6') SELECT days.hari, COALESCE(SUM(transaksi.totalharga), 0) AS total_transaksi FROM days LEFT JOIN transaksi ON strftime('%w', transaksi.created) = days.strftime_value AND substr(transaksi.created, 1, 10) BETWEEN date('now', '-6 days') AND date('now') GROUP BY days.hari ORDER BY CASE WHEN days.strftime_value = strftime('%w', 'now') THEN 1 ELSE 0 END, days.strftime_value LIMIT 7
        ''');
    for (var i = 0; i < result.length; i++) {
      lists.add(TransaksiHariModel(
        hari: result[i]['hari'],
        sales: double.parse(result[i]['total_transaksi'].toString()),
      ));
    }
    // print("Ini ${lists.length}");
    return lists;
  }

  Future<List<TransaksiJamModel>> getTransaksiJam() async {
    List<TransaksiJamModel> lists = [];
    var database = await getDatabase();
    List<Map<String, dynamic>> result = await database.rawQuery('''
        WITH hours AS (SELECT '00' AS hour UNION ALL SELECT '01' UNION ALL SELECT '02' UNION ALL SELECT '03' UNION ALL SELECT '04' UNION ALL SELECT '05' UNION ALL SELECT '06' UNION ALL SELECT '07' UNION ALL SELECT '08' UNION ALL SELECT '09' UNION ALL SELECT '10' UNION ALL SELECT '11' UNION ALL SELECT '12' UNION ALL SELECT '13' UNION ALL SELECT '14' UNION ALL SELECT '15' UNION ALL SELECT '16' UNION ALL SELECT '17' UNION ALL SELECT '18' UNION ALL SELECT '19' UNION ALL SELECT '20' UNION ALL SELECT '21' UNION ALL SELECT '22' UNION ALL SELECT '23') SELECT h.hour AS jam, COALESCE(SUM(t.totalharga), 0) AS total_transaksi FROM hours h LEFT JOIN (SELECT substr(created, 1, 10) AS date_only, strftime('%H', created) AS hour, totalharga FROM transaksi WHERE substr(created, 1, 10) = date('now')) t ON h.hour = t.hour GROUP BY h.hour ORDER BY h.hour
        ''');
    for (var i = 0; i < result.length; i++) {
      lists.add(TransaksiJamModel(
        jam: result[i]['jam'],
        sales: double.parse(result[i]['total_transaksi'].toString()),
      ));
    }
    // print("Ini ${lists.length}");
    return lists;
  }

  //Get Transaksi
  Future<List<TransaksiWeightmModel>> getWeightSugar() async {
    List<TransaksiWeightmModel> lists = [];
    var database = await getDatabase();
    List<Map<String, dynamic>> result = await database.rawQuery('''
        WITH minggu AS (SELECT 'Minggu 1' AS minggu, 1 AS id UNION ALL SELECT 'Minggu 2', 2 UNION ALL SELECT 'Minggu 3', 3 UNION ALL SELECT 'Minggu 4', 4), transaksi_gula AS (SELECT CASE WHEN strftime('%d', created) BETWEEN '01' AND '07' THEN 'Minggu 1' WHEN strftime('%d', created) BETWEEN '08' AND '14' THEN 'Minggu 2' WHEN strftime('%d', created) BETWEEN '15' AND '21' THEN 'Minggu 3' ELSE 'Minggu 4' END AS minggu, SUM(weightgula) AS total_gula FROM transaksi WHERE strftime('%Y-%m', created) = strftime('%Y-%m', 'now', 'localtime') GROUP BY minggu) SELECT m.minggu, COALESCE(tg.total_gula, 0) AS total_gula FROM minggu m LEFT JOIN transaksi_gula tg ON m.minggu = tg.minggu ORDER BY m.id
        ''');
    for (var i = 0; i < result.length; i++) {
      lists.add(TransaksiWeightmModel(
        minggu: result[i]['minggu'],
        berat: double.parse(result[i]['total_gula'].toString()),
      ));
    }
    // print("Ini ${lists.length}");
    return lists;
  }

  //Get Transaksi
  Future<List<TransaksiProductTerlarisModel>>
      getTransaksiProductTerlaris() async {
    List<TransaksiProductTerlarisModel> lists = [];
    var database = await getDatabase();
    List<Map<String, dynamic>> result = await database.rawQuery('''
        SELECT products.namaBarang AS namaProduct, SUM(CASE WHEN transaksiDetail.idVarian IS NOT NULL THEN transaksiDetail.qty * varian.stokVarian ELSE transaksiDetail.qty END) AS qty FROM transaksiDetail LEFT JOIN transaksi ON transaksi.id = transaksiDetail.idTransaksi LEFT JOIN varian ON varian.id = transaksiDetail.idVarian LEFT JOIN products ON products.id = transaksiDetail.idProduct GROUP BY products.id ORDER BY qty DESC LIMIT 6
        ''');
    for (var i = 0; i < result.length; i++) {
      lists.add(TransaksiProductTerlarisModel(
        namaProduct: result[i]['namaProduct'],
        sales: double.parse(result[i]['qty'].toString()),
      ));
    }
    // print("Ini ${lists.length}");
    return lists;
  }

  //Get Transaksi
  Future<List<TransaksiModel>> getSearchTrans(Map<String, dynamic> map) async {
    List<TransaksiModel> lists = [];
    ReceiptModel? receipt;
    var database = await getDatabase();
    String sql =
        "SELECT transaksi.id, transaksi.idUser,transaksi.idCustomer,transaksi.orderId,transaksi.shiftId,transaksi.totalGula,transaksi.weightGula,transaksi.priceBeliGula,transaksi.priceJualGula,transaksi.totalKasbon,transaksi.setorKasbon,transaksi.setorGula,transaksi.totalHarga,transaksi.bayar,transaksi.kembalian,transaksi.paymentType,transaksi.created, customer.nama, customer.phone, customer.email, customer.created AS date, user.nama AS userNama, user.role, user.email AS userEmail, user.password, user.created AS userCreated FROM transaksi LEFT JOIN customer ON customer.id = transaksi.idCustomer LEFT JOIN user ON user.id = transaksi.idUser";
    var noOrder = map['no_order'];
    var tanggal = map['tanggal'];
    var customer = map['cutomer_id'];
    if (noOrder != "") {
      sql +=
          " WHERE transaksi.orderId LIKE '%$noOrder%' AND transaksi.created LIKE '%$tanggal%'";
    } else {
      if (customer != "") {
        sql += " WHERE customer.nama LIKE '$customer%'";
        if (tanggal != "") {
          sql += " AND transaksi.created LIKE '$tanggal%'";
        }
      } else {
        sql += " WHERE transaksi.created LIKE '$tanggal%'";
      }
    }
    sql += " ORDER BY transaksi.created DESC";
    List<Map<String, dynamic>> result = await database.rawQuery(sql);
    receipt = await getReceipt();
    for (var i = 0; i < result.length; i++) {
      // int transId = await deleteTrans(result[i]['id']);
      // print(transId);
      var transDetail = await getTransaksDetailiByIdTrans(result[i]['id']);
      lists.add(TransaksiModel(
        id: result[i]['id'],
        idUser: result[i]['idUser'],
        idCustomer: result[i]['idCustomer'],
        orderId: result[i]['orderId'],
        shiftId: result[i]['shiftId'],
        totalGula: result[i]["totalGula"],
        weightGula: result[i]["weightGula"],
        priceBeliGula: result[i]["priceBeliGula"],
        priceJualGula: result[i]["priceJualGula"],
        totalKasbon: result[i]["totalKasbon"],
        setorKasbon: result[i]["setorKasbon"],
        setorGula: result[i]["setorGula"],
        totalHarga: result[i]['totalHarga'],
        bayar: result[i]['bayar'],
        kembalian: result[i]['kembalian'],
        paymentType: result[i]['paymentType'],
        created: result[i]['created'],
        customer: CustomerModel(
            nama: result[i]['nama'],
            phone: result[i]['phone'],
            email: result[i]['email'],
            created: result[i]['date']),
        detail: transDetail,
        receipt: receipt,
        user: UserModel(
          nama: result[i]['userNama'],
          role: result[i]['role'],
          email: result[i]['userEmail'],
          password: result[i]['password'],
          created: result[i]['userCreated'],
        ),
      ));
    }
    // print("Ini ${lists.length}");
    return lists;
  }

  // create transaksi Product
  Future<int> insertTransaksi(TransaksiModel trans) async {
    try {
      var orderId = await generateOrderId();
      var shiftId = await generateShiftd();
      var database = await getDatabase();
      trans.orderId = orderId;
      trans.shiftId = shiftId;
      int id = await database.insert("transaksi", trans.toJson());
      return id;
      // ignore: empty_catches
    } catch (e) {}
    return 0;
  }

  //Get show Transaksi
  Future<TransaksiModel?> showTransaksi(int idTransaksi) async {
    TransaksiModel? lists;
    ReceiptModel? receipt;
    var database = await getDatabase();
    List<Map<String, dynamic>> result = await database.rawQuery('''
    SELECT transaksi.id, transaksi.idUser,transaksi.idCustomer,transaksi.orderId,transaksi.shiftId,transaksi.totalGula,transaksi.weightGula,transaksi.priceBeliGula,transaksi.priceJualGula,transaksi.totalKasbon,transaksi.setorKasbon,transaksi.setorGula,transaksi.totalHarga,transaksi.bayar,transaksi.kembalian,transaksi.paymentType,transaksi.created, customer.nama, customer.phone, customer.email, customer.created AS date FROM transaksi LEFT JOIN customer ON customer.id = transaksi.idCustomer WHERE transaksi.id = '$idTransaksi'
    ''');
    var dat = result.first;
    receipt = await getReceipt();
    var transDetail = await getTransaksDetailiByIdTrans(dat['id']);
    lists = TransaksiModel(
      id: dat['id'],
      idUser: dat['idUser'],
      idCustomer: dat['idCustomer'],
      orderId: dat['orderId'],
      shiftId: dat['shiftId'],
      totalGula: dat["totalGula"],
      weightGula: dat["weightGula"],
      priceBeliGula: dat["priceBeliGula"],
      priceJualGula: dat["priceJualGula"],
      totalKasbon: dat["totalKasbon"],
      setorKasbon: dat["setorKasbon"],
      setorGula: dat["setorGula"],
      totalHarga: dat['totalHarga'],
      bayar: dat['bayar'],
      kembalian: dat['kembalian'],
      paymentType: dat['paymentType'],
      created: dat['created'],
      customer: CustomerModel(
          nama: dat['nama'],
          phone: dat['phone'],
          email: dat['email'],
          created: dat['date']),
      detail: transDetail,
      receipt: receipt,
    );
    // print("Ini ${lists.length}");
    return lists;
  }

  //Get Transaksi
  Future<List<TransaksiDetailModel>> getTransaksiDetaiilSales(
      Map<String, dynamic> map) async {
    List<TransaksiDetailModel> lists = [];
    var database = await getDatabase();
    VarianModel? varian;
    String sql =
        "SELECT transaksiDetail.id, transaksiDetail.idTransaksi, transaksiDetail.idProduct, transaksiDetail.idVarian, SUM(CASE WHEN transaksiDetail.idVarian IS NOT NULL THEN transaksiDetail.qty * varian.stokVarian ELSE transaksiDetail.qty END) AS qty, SUM(transaksiDetail.hargaModal * transaksiDetail.qty) AS hargaModal, SUM(transaksiDetail.hargaProduct * transaksiDetail.qty) AS hargaProduct, SUM(transaksiDetail.totalDiskon) AS totalDiskon, transaksiDetail.created FROM transaksiDetail LEFT JOIN transaksi ON transaksi.id = transaksiDetail.idTransaksi LEFT JOIN varian ON varian.id = transaksiDetail.idVarian LEFT JOIN products ON products.id = transaksiDetail.idProduct";
    var noOrder = map['no_order'];
    var tanggal = map['tanggal'];
    if (noOrder != "") {
      sql +=
          " WHERE transaksi.orderId LIKE '%$noOrder%' AND transaksi.created LIKE '%$tanggal%'";
    } else {
      sql += " WHERE transaksi.created LIKE '$tanggal%'";
    }
    sql +=
        " GROUP BY transaksiDetail.idProduct ORDER BY products.namaBarang ASC";
    List<Map<String, dynamic>> result = await database.rawQuery(sql);
    double totalQty = 0;
    double totalHargaModal = 0;
    double totalHarga = 0;
    double totalDiskon = 0;
    for (var i = 0; i < result.length; i++) {
      int idProd = int.parse("${result[i]['idProduct']}");

      var prod = await showProduct(idProd);
      if (result[i]['idVarian'] != null) {
        int idVar = int.parse("${result[i]['idVarian']}");
        varian = await showVarian(idVar);
      }
      totalQty += double.parse("${result[i]['qty']}");
      totalHargaModal += double.parse("${result[i]['hargaModal']}");
      totalHarga += double.parse("${result[i]['hargaProduct']}");
      if (result[i]['totalDiskon'] != null) {
        totalDiskon += double.parse("${result[i]['totalDiskon']}");
      }
      lists.add(TransaksiDetailModel(
          id: result[i]['id'],
          idTransaksi: result[i]['idTransaksi'],
          idProduct: result[i]['idProduct'],
          idVarian: result[i]['idVarian'],
          qty: "${result[i]['qty']}",
          hargaModal: "${result[i]['hargaModal']}",
          hargaProduct: "${result[i]['hargaProduct']}",
          totalDiskon: "${result[i]['totalDiskon']}",
          created: result[i]['created'],
          product: prod,
          varian: varian));
    }
    if (result.isNotEmpty) {
      lists.add(TransaksiDetailModel(
        idTransaksi: "",
        idProduct: "",
        idVarian: "",
        qty: totalQty.toInt().toString(),
        hargaModal: totalHargaModal.toInt().toString(),
        hargaProduct: totalHarga.toInt().toString(),
        totalDiskon: (totalDiskon.toInt() == 0)
            ? "null"
            : totalDiskon.toInt().toString(),
        product: ProductsModel(
            namaBarang: "Total",
            idCategory: 1,
            idVarian: 1,
            deskripsi: "",
            harga: "",
            sku: "",
            hargaModal: "",
            stock: "",
            createdAt: "",
            categori: CategoryModel(nama: "Total")),
      ));
    }
    // print("Ini ${lists.length}");
    return lists;
  }

  //Get Transaksi
  Future<List<TransaksiDetailModel>> getTransaksiDetaiilCategory(
      Map<String, dynamic> map) async {
    List<TransaksiDetailModel> lists = [];
    var database = await getDatabase();
    VarianModel? varian;
    String sql =
        "SELECT transaksiDetail.id, transaksiDetail.idTransaksi, transaksiDetail.idProduct, transaksiDetail.idVarian, SUM(CASE WHEN transaksiDetail.idVarian IS NOT NULL THEN transaksiDetail.qty * varian.stokVarian ELSE transaksiDetail.qty END) AS qty, SUM(transaksiDetail.hargaModal * transaksiDetail.qty) AS hargaModal, SUM(transaksiDetail.hargaProduct * transaksiDetail.qty) AS hargaProduct, SUM(transaksiDetail.totalDiskon) AS totalDiskon, transaksiDetail.created FROM transaksiDetail LEFT JOIN transaksi ON transaksi.id = transaksiDetail.idTransaksi LEFT JOIN varian ON varian.id = transaksiDetail.idVarian LEFT JOIN products ON products.id = transaksiDetail.idProduct";
    var noOrder = map['no_order'];
    var tanggal = map['tanggal'];
    if (noOrder != "") {
      sql +=
          " WHERE transaksi.orderId LIKE '%$noOrder%' AND transaksi.created LIKE '%$tanggal%'";
    } else {
      sql += " WHERE transaksi.created LIKE '$tanggal%'";
    }
    sql +=
        " GROUP BY products.idCategory ORDER BY transaksiDetail.idTransaksi ASC";
    List<Map<String, dynamic>> result = await database.rawQuery(sql);
    double totalQty = 0;
    double totalHargaModal = 0;
    double totalHarga = 0;
    double totalDiskon = 0;
    for (var i = 0; i < result.length; i++) {
      int idProd = int.parse("${result[i]['idProduct']}");

      var prod = await showProduct(idProd);
      if (result[i]['idVarian'] != null) {
        int idVar = int.parse("${result[i]['idVarian']}");
        varian = await showVarian(idVar);
      }
      totalQty += double.parse("${result[i]['qty']}");
      totalHargaModal += double.parse("${result[i]['hargaModal']}");
      totalHarga += double.parse("${result[i]['hargaProduct']}");
      if (result[i]['totalDiskon'] != null) {
        totalDiskon += double.parse("${result[i]['totalDiskon']}");
      }
      lists.add(TransaksiDetailModel(
          id: result[i]['id'],
          idTransaksi: result[i]['idTransaksi'],
          idProduct: result[i]['idProduct'],
          idVarian: result[i]['idVarian'],
          qty: "${result[i]['qty']}",
          hargaModal: "${result[i]['hargaModal']}",
          hargaProduct: "${result[i]['hargaProduct']}",
          totalDiskon: "${result[i]['totalDiskon']}",
          created: result[i]['created'],
          product: prod,
          varian: varian));
    }
    if (result.isNotEmpty) {
      lists.add(TransaksiDetailModel(
        idTransaksi: "",
        idProduct: "",
        idVarian: "",
        qty: totalQty.toInt().toString(),
        hargaModal: totalHargaModal.toInt().toString(),
        hargaProduct: totalHarga.toInt().toString(),
        totalDiskon: (totalDiskon.toInt() == 0)
            ? "null"
            : totalDiskon.toInt().toString(),
        product: ProductsModel(
            namaBarang: "",
            idCategory: 1,
            idVarian: 1,
            deskripsi: "",
            harga: "",
            sku: "",
            hargaModal: "",
            stock: "",
            createdAt: "",
            categori: CategoryModel(nama: "Total")),
      ));
    }
    // print("Ini ${lists.length}");
    return lists;
  }

  //Get Transaksi
  Future<List<TransaksiDetailModel>> getTransaksDetailiByIdTrans(
      int idTrans) async {
    List<TransaksiDetailModel> lists = [];
    var database = await getDatabase();
    VarianModel? varian;
    List<Map<String, dynamic>> result = await database.query("transaksiDetail",
        where: "idTransaksi = ?", whereArgs: [idTrans]);
    for (var i = 0; i < result.length; i++) {
      int idProd = int.parse("${result[i]['idProduct']}");

      var prod = await showProduct(idProd);
      if (result[i]['idVarian'] != null) {
        int idVar = int.parse("${result[i]['idVarian']}");
        varian = await showVarian(idVar);
      }
      lists.add(TransaksiDetailModel(
          id: result[i]['id'],
          idTransaksi: result[i]['idTransaksi'],
          idProduct: result[i]['idProduct'],
          idVarian: result[i]['idVarian'],
          qty: result[i]['qty'],
          hargaModal: result[i]['hargaModal'],
          hargaProduct: result[i]['hargaProduct'],
          totalDiskon: result[i]['totalDiskon'],
          created: result[i]['created'],
          product: prod,
          varian: varian));
    }
    // print("Ini ${lists.length}");
    return lists;
  }

  //Get Transaksi
  Future<TransaksiDetailModel?> showTransaksDetailProduct(
      String date, String idProduct) async {
    TransaksiDetailModel? lists;
    var database = await getDatabase();
    String sql =
        "SELECT transaksiDetail.id, transaksiDetail.idTransaksi, transaksiDetail.idProduct, transaksiDetail.idVarian, SUM(CASE WHEN transaksiDetail.idVarian IS NOT NULL THEN transaksiDetail.qty * varian.stokVarian ELSE transaksiDetail.qty END) AS qty, SUM(transaksiDetail.hargaModal * transaksiDetail.qty) AS hargaModal, SUM(transaksiDetail.hargaProduct * transaksiDetail.qty) AS hargaProduct, SUM(transaksiDetail.totalDiskon) AS totalDiskon, transaksiDetail.created FROM transaksiDetail LEFT JOIN transaksi ON transaksi.id = transaksiDetail.idTransaksi LEFT JOIN varian ON varian.id = transaksiDetail.idVarian LEFT JOIN products ON products.id = transaksiDetail.idProduct WHERE transaksi.created LIKE '%$date%' AND transaksiDetail.idProduct = '$idProduct' GROUP BY transaksiDetail.idProduct";
    List<Map<String, dynamic>> result = await database.rawQuery(sql);
    if (result.isNotEmpty) {
      var data = result.first;
      lists = TransaksiDetailModel(
        id: data['id'],
        idTransaksi: data['idTransaksi'],
        idProduct: data['idProduct'],
        idVarian: data['idVarian'],
        qty: data['qty'].toString(),
        hargaModal: data['hargaModal'].toString(),
        hargaProduct: data['hargaProduct'].toString(),
        totalDiskon: data['totalDiskon'].toString(),
        created: data['created'],
      );
    }
    // print("Ini ${lists.length}");
    return lists;
  }

  // create transaksi detail
  Future<int> insertTransaksiDetail(TransaksiDetailModel detail) async {
    try {
      var database = await getDatabase();
      int id = await database.insert("transaksiDetail", detail.toJson());
      return id;
    } catch (e) {
      // print("$e");
    }
    return 0;
  }

  //Delete Discount
  Future<int> deleteTrans(int idTransaksi) async {
    try {
      var database = await getDatabase();
      int id = await database
          .delete("transaksi", where: "id = ?", whereArgs: [idTransaksi]);
      await database.delete("transaksiDetail",
          where: "idTransaksi = ?", whereArgs: [idTransaksi]);
      return id;
    } catch (e) {
      // print("$e");
    }
    return 0;
  }

  //Get receipt
  Future<ReceiptModel?> getReceipt() async {
    ReceiptModel? lists;
    var database = await getDatabase();
    List<Map<String, dynamic>> result =
        await database.query("receipt", limit: 1);
    if (result.isNotEmpty) {
      var dat = result.first;
      lists = ReceiptModel(
        id: dat['id'],
        namaToko: dat['namaToko'],
        alamat: dat['alamat'],
        provinsi: dat['provinsi'],
        kota: dat['kota'],
        kodePos: dat['kodePos'],
        phone: dat['phone'],
        notes: dat['notes'],
        created: dat['created'],
      );
    }
    // print("Ini ${lists.length}");
    return lists;
  }

  // create receipt
  Future<int> insertReceipt(ReceiptModel receipt) async {
    try {
      var database = await getDatabase();
      int id = await database.insert("receipt", receipt.toJson());
      return id;
    } catch (e) {
      // print("$e");
    }
    return 0;
  }

  //Update Cart product
  Future<int> updateReceipt(ReceiptModel cart) async {
    try {
      var database = await getDatabase();
      int id = await database.rawUpdate(
          "update receipt set namaToko = ?, alamat = ?, provinsi = ?, kota = ?, kodePos = ?, phone = ?, notes = ? where id = ?",
          [
            cart.namaToko,
            cart.alamat,
            cart.provinsi,
            cart.kota,
            cart.kodePos,
            cart.phone,
            cart.notes,
            cart.id
          ]);
      return id;
    } catch (e) {
      // print("$e");
    }
    return 0;
  }

  //Get gula
  Future<List<GulaModel>> getGula() async {
    List<GulaModel> lists = [];
    var database = await getDatabase();
    List<Map<String, dynamic>> result = await database.query("gula");
    for (var i = 0; i < result.length; i++) {
      lists.add(GulaModel(
          id: result[i]['id'],
          type: result[i]['type'],
          priceBeli: result[i]['priceBeli'],
          priceJual: result[i]['priceJual'],
          created: result[i]['created']));
    }
    // print("Ini ${lists.length}");
    return lists;
  }

  // create gula
  Future<int> insertGula(GulaModel gula) async {
    try {
      var database = await getDatabase();
      int id = await database.insert("gula", gula.toJson());
      return id;
    } catch (e) {
      // print("$e");
    }
    return 0;
  }

  //Update Cart product
  Future<int> updateGula(GulaModel cart) async {
    try {
      var database = await getDatabase();
      int id = await database.rawUpdate(
          "update gula set type = ?, priceBeli = ?, priceJual = ?, created = ? where id = ?",
          [cart.type, cart.priceBeli, cart.priceJual, cart.created, cart.id]);
      return id;
    } catch (e) {
      // print("$e");
    }
    return 0;
  }

  //Delete Discount
  Future<int> deleteGula(int idGula) async {
    try {
      var database = await getDatabase();
      int id =
          await database.delete("gula", where: "id = ?", whereArgs: [idGula]);
      return id;
    } catch (e) {
      // print("$e");
    }
    return 0;
  }

  //Get Hutang Gula
  Future<List<DebtSugarModel>> getDebtSugar() async {
    List<DebtSugarModel> lists = [];
    List<DebtSugarDetailModel>? detail;
    var database = await getDatabase();
    String sql =
        "SELECT hutang.id, hutang.idCustomer, hutang.nominal, hutang.created, customer.nama, customer.phone, customer.email, customer.created AS date FROM hutang LEFT JOIN customer ON customer.id = hutang.idCustomer ORDER BY customer.nama ASC";
    List<Map<String, dynamic>> result = await database.rawQuery(sql);
    for (var i = 0; i < result.length; i++) {
      detail = await getDetailDebtSugarIdhutang(result[i]['id']);
      String status = "";
      String nominal = result[i]['nominal'];
      if (nominal.isNotEmpty) {
        if (int.parse(nominal) > 0) {
          status = "Hutang";
        } else {
          status = "Lunas";
        }
      }
      lists.add(DebtSugarModel(
          id: result[i]['id'],
          idCustomer: result[i]['idCustomer'],
          nominal: result[i]['nominal'],
          created: result[i]['created'],
          sugarDetail: detail,
          customerModel: CustomerModel(
              nama: result[i]['nama'],
              phone: result[i]['phone'],
              email: result[i]['email'],
              created: result[i]['date']),
          status: status));
    }
    // print("Ini ${lists.length}");
    return lists;
  }

  //Get Hutang Gula
  Future<List<DebtSugarModel>> getDebtSugarByName(String name) async {
    List<DebtSugarModel> lists = [];
    List<DebtSugarDetailModel>? detail;
    var database = await getDatabase();
    String sql =
        "SELECT hutang.id, hutang.idCustomer, hutang.nominal, hutang.created, customer.nama, customer.phone, customer.email, customer.created AS date FROM hutang LEFT JOIN customer ON customer.id = hutang.idCustomer WHERE customer.nama LIKE '%$name%' ORDER BY customer.nama ASC";
    List<Map<String, dynamic>> result = await database.rawQuery(sql);
    for (var i = 0; i < result.length; i++) {
      detail = await getDetailDebtSugarIdhutang(result[i]['id']);
      String status = "";
      String nominal = result[i]['nominal'];
      if (nominal.isNotEmpty) {
        if (int.parse(nominal) > 0) {
          status = "Hutang";
        } else {
          status = "Lunas";
        }
      }
      lists.add(DebtSugarModel(
          id: result[i]['id'],
          idCustomer: result[i]['idCustomer'],
          nominal: result[i]['nominal'],
          created: result[i]['created'],
          sugarDetail: detail,
          customerModel: CustomerModel(
              nama: result[i]['nama'],
              phone: result[i]['phone'],
              email: result[i]['email'],
              created: result[i]['date']),
          status: status));
    }
    // print("Ini ${lists.length}");
    return lists;
  }

  // create hutang
  Future<int> insertDebtSugar(DebtSugarModel debt) async {
    try {
      var database = await getDatabase();
      int id = await database.insert("hutang", debt.toJson());
      if (debt.sugarDetail != null) {
        debt.sugarDetail?.forEach((sugar) async {
          sugar.idHutang = id.toString();
          await insertDebtSugarDetail(sugar);
        });
      }
      return id;
    } catch (e) {
      // print("$e");
    }
    return 0;
  }

  //Update hutang gula
  Future<int> updateDebtSugar(DebtSugarModel debt) async {
    try {
      var database = await getDatabase();
      int id = await database.rawUpdate(
          "update hutang set nominal = ? where idCustomer = ?",
          [debt.nominal, debt.idCustomer]);
      return id;
    } catch (e) {
      // print("$e");
    }
    return 0;
  }

  //Delete hutang gula
  Future<int> deleteDebtSugar(int diSugar) async {
    try {
      var database = await getDatabase();
      int id = await database
          .delete("hutang", where: "id = ?", whereArgs: [diSugar]);
      await database
          .delete("hutangDetail", where: "idHutang = ?", whereArgs: [diSugar]);
      return id;
    } catch (e) {
      // print("$e");
    }
    return 0;
  }

  //Get Hutang Gula detail by id hutang
  Future<List<DebtSugarDetailModel>> getDetailDebtSugarIdhutang(
      int idHutang) async {
    List<DebtSugarDetailModel> lists = [];
    var database = await getDatabase();
    List<Map<String, dynamic>> result = await database.query("hutangDetail",
        where: "idHutang = ?", whereArgs: [idHutang], orderBy: "created DESC");
    for (var i = 0; i < result.length; i++) {
      lists.add(DebtSugarDetailModel(
        id: result[i]['id'],
        idHutang: result[i]['idHutang'],
        type: result[i]['type'],
        nominal: result[i]['nominal'],
        note: result[i]['note'],
        created: result[i]['created'],
      ));
    }
    // print("Ini ${lists.length}");
    return lists;
  }

  // create hutang
  Future<int> insertDebtSugarDetail(DebtSugarDetailModel debt) async {
    try {
      var database = await getDatabase();
      int id = await database.insert("hutangDetail", debt.toJson());

      return id;
    } catch (e) {
      // print("$e");
    }
    return 0;
  }

  // create hutang
  Future<int> tambahDebtSugarDetail(DebtSugarModel debt) async {
    try {
      var database = await getDatabase();
      int id = 0;
      debt.sugarDetail?.forEach((deb) async {
        id = await database.insert("hutangDetail", deb.toJson());
      });
      await database.rawUpdate(
          "update hutang set nominal = ? where idCustomer = ?",
          [debt.nominal, debt.idCustomer]);
      return id;
    } catch (e) {
      // print("$e");
    }
    return 0;
  }

  //Get Hutang Harian
  Future<List<DebtWatchModel>> getDebtWatch() async {
    List<DebtWatchModel> lists = [];
    List<DebtWatchDetailModel>? detail;
    var database = await getDatabase();
    String sql =
        "SELECT kasbon.id, kasbon.idCustomer, kasbon.nominal, kasbon.created, customer.nama, customer.phone, customer.email, customer.created AS date FROM kasbon LEFT JOIN customer ON customer.id = kasbon.idCustomer ORDER BY customer.nama ASC";
    List<Map<String, dynamic>> result = await database.rawQuery(sql);
    for (var i = 0; i < result.length; i++) {
      detail = await getDetailDebtWatchIdkasbon(result[i]['id']);
      String status = "";
      String nominal = result[i]['nominal'];
      if (nominal.isNotEmpty) {
        if (int.parse(nominal) > 0) {
          status = "Hutang";
        } else {
          status = "Lunas";
        }
      }
      lists.add(DebtWatchModel(
          id: result[i]['id'],
          idCustomer: result[i]['idCustomer'],
          nominal: result[i]['nominal'],
          created: result[i]['created'],
          kasbonDetail: detail,
          customerModel: CustomerModel(
              nama: result[i]['nama'],
              phone: result[i]['phone'],
              email: result[i]['email'],
              created: result[i]['date']),
          status: status));
    }
    // print("Ini ${lists.length}");
    return lists;
  }

  //Get Hutang Harian
  Future<List<DebtWatchModel>> getDebtWatchByName(String name) async {
    List<DebtWatchModel> lists = [];
    List<DebtWatchDetailModel>? detail;
    var database = await getDatabase();
    String sql =
        "SELECT kasbon.id, kasbon.idCustomer, kasbon.nominal, kasbon.created, customer.nama, customer.phone, customer.email, customer.created AS date FROM kasbon LEFT JOIN customer ON customer.id = kasbon.idCustomer WHERE customer.nama LIKE '%$name%' ORDER BY customer.nama ASC";
    List<Map<String, dynamic>> result = await database.rawQuery(sql);
    for (var i = 0; i < result.length; i++) {
      detail = await getDetailDebtWatchIdkasbon(result[i]['id']);
      String status = "";
      String nominal = result[i]['nominal'];
      if (nominal.isNotEmpty) {
        if (int.parse(nominal) > 0) {
          status = "Hutang";
        } else {
          status = "Lunas";
        }
      }
      lists.add(DebtWatchModel(
          id: result[i]['id'],
          idCustomer: result[i]['idCustomer'],
          nominal: result[i]['nominal'],
          created: result[i]['created'],
          kasbonDetail: detail,
          customerModel: CustomerModel(
              nama: result[i]['nama'],
              phone: result[i]['phone'],
              email: result[i]['email'],
              created: result[i]['date']),
          status: status));
    }
    // print("Ini ${lists.length}");
    return lists;
  }

  // create hutang
  Future<int> insertDebtWatch(DebtWatchModel debt) async {
    try {
      var database = await getDatabase();
      int id = await database.insert("kasbon", debt.toJson());
      if (debt.kasbonDetail != null) {
        debt.kasbonDetail?.forEach((sugar) async {
          sugar.idKasbon = id.toString();
          await insertDebtWatchDetail(sugar);
        });
      }
      return id;
    } catch (e) {
      // print("$e");
    }
    return 0;
  }

  //Update hutang gula
  Future<int> updateDebtwatch(DebtWatchModel debt) async {
    try {
      var database = await getDatabase();
      int id = await database.rawUpdate(
          "update kasbon set nominal = ? where idCustomer = ?",
          [debt.nominal, debt.idCustomer]);
      return id;
    } catch (e) {
      // print("$e");
    }
    return 0;
  }

  //Delete hutang gula
  Future<int> deleteDebtWatch(int idKasbon) async {
    try {
      var database = await getDatabase();
      int id = await database
          .delete("kasbon", where: "id = ?", whereArgs: [idKasbon]);
      await database
          .delete("kasbonDetail", where: "idKasbon = ?", whereArgs: [idKasbon]);
      return id;
    } catch (e) {
      // print("$e");
    }
    return 0;
  }

  // create hutang
  Future<int> insertDebtWatchDetail(DebtWatchDetailModel watch) async {
    try {
      var database = await getDatabase();
      int id = await database.insert("kasbonDetail", watch.toJson());
      return id;
    } catch (e) {
      // print("$e");
    }
    return 0;
  }

  // create hutang
  Future<int> tambahDebtWatchDetail(DebtWatchModel debt) async {
    try {
      var database = await getDatabase();
      int id = 0;
      debt.kasbonDetail?.forEach((deb) async {
        id = await database.insert("kasbonDetail", deb.toJson());
      });
      await database.rawUpdate(
          "update kasbon set nominal = ? where idCustomer = ?",
          [debt.nominal, debt.idCustomer]);
      return id;
    } catch (e) {
      // print("$e");
    }
    return 0;
  }

  //Get Hutang Gula detail by id hutang
  Future<List<DebtWatchDetailModel>> getDetailDebtWatchIdkasbon(
      int idKasbon) async {
    List<DebtWatchDetailModel> lists = [];
    var database = await getDatabase();
    List<Map<String, dynamic>> result = await database.query("kasbonDetail",
        where: "idKasbon = ?", whereArgs: [idKasbon], orderBy: "created DESC");
    for (var i = 0; i < result.length; i++) {
      lists.add(DebtWatchDetailModel(
        id: result[i]['id'],
        idKasbon: result[i]['idKasbon'],
        type: result[i]['type'],
        nominal: result[i]['nominal'],
        note: result[i]['note'],
        created: result[i]['created'],
      ));
    }
    // print("Ini ${lists.length}");
    return lists;
  }

  //Get Order
  Future<List<OrderModel>?> getOrder(String date) async {
    List<OrderModel> lists = [];
    var database = await getDatabase();

    String sql =
        "SELECT pembelianBarang.id, pembelianBarang.idSuplier, pembelianBarang.noFaktur, pembelianBarang.nominal, pembelianBarang.status, pembelianBarang.created, suplier.id AS supId, suplier.name, suplier.email, suplier.phone, suplier.created AS supCreated FROM pembelianBarang LEFT JOIN suplier ON pembelianBarang.idSuplier = suplier.id WHERE pembelianBarang.created LIKE '%$date%' ORDER BY pembelianBarang.created DESC";
    List<Map<String, dynamic>> result = await database.rawQuery(sql);
    if (result.isNotEmpty) {
      for (var i = 0; i < result.length; i++) {
        String idPembelian = "${result[i]['id']}";
        var detail = await getOrderDetailPembelian(idPembelian);
        lists.add(OrderModel(
            id: result[i]['id'],
            idSuplier: result[i]['idSuplier'],
            noFaktur: result[i]['noFaktur'],
            nominal: result[i]['nominal'],
            status: result[i]['status'],
            created: result[i]['created'],
            detail: detail,
            suplier: SuplierModel(
              id: result[i]['supId'],
              name: result[i]['name'],
              phone: result[i]['phone'],
              email: result[i]['email'],
              created: result[i]['supCreated'],
            )));
      }
    }
    // print("Ini ${lists.length}");
    return lists;
  }

  //Get Order
  Future<List<OrderModel>?> getOrderSuplier(String suplier) async {
    List<OrderModel> lists = [];
    var database = await getDatabase();
    String sql =
        "SELECT pembelianBarang.id AS pembId, pembelianBarang.idSuplier, pembelianBarang.noFaktur, pembelianBarang.nominal, pembelianBarang.status, pembelianBarang.created AS pembCreated, suplier.id AS supId, suplier.name, suplier.email, suplier.phone, suplier.created AS supCreated FROM pembelianBarang LEFT JOIN suplier ON pembelianBarang.idSuplier = suplier.id WHERE suplier.name LIKE '%$suplier%' ORDER BY pembelianBarang.created DESC";
    List<Map<String, dynamic>> result = await database.rawQuery(sql);
    if (result.isNotEmpty) {
      for (var i = 0; i < result.length; i++) {
        String idPembelian = "${result[i]['id']}";
        var detail = await getOrderDetailPembelian(idPembelian);
        lists.add(OrderModel(
            id: result[i]['pembId'],
            idSuplier: result[i]['idSuplier'],
            noFaktur: result[i]['noFaktur'],
            nominal: result[i]['nominal'],
            status: result[i]['status'],
            created: result[i]['pembCreated'],
            detail: detail,
            suplier: SuplierModel(
              id: result[i]['supId'],
              name: result[i]['name'],
              phone: result[i]['phone'],
              email: result[i]['email'],
              created: result[i]['supCreated'],
            )));
      }
    }
    // print("Ini ${lists.length}");
    return lists;
  }

  // create order
  Future<int> insertOrder(OrderModel order) async {
    try {
      var database = await getDatabase();
      int id = await database.insert("pembelianBarang", order.toJson());
      if (order.detail != null) {
        order.detail?.forEach((details) async {
          details.idPembelian = id.toString();
          await insertOrderDetail(details);
        });
      }
      return id;
    } catch (e) {
      // print("$e");
    }
    return 0;
  }

  //Update hutang gula
  Future<int> updateOrder(OrderModel order) async {
    try {
      var database = await getDatabase();
      int id = await database.rawUpdate(
          "update pembelianBarang set status = ? where id = ?",
          [order.status, order.id]);
      return id;
    } catch (e) {
      // print("$e");
    }
    return 0;
  }

  //Delete hutang gula
  Future<int> deleteOrder(int idPembelian) async {
    try {
      var database = await getDatabase();
      int id = await database
          .delete("pembelianBarang", where: "id = ?", whereArgs: [idPembelian]);
      await database.delete("pembelianBarangDetail",
          where: "idPembelian = ?", whereArgs: [idPembelian]);
      return id;
    } catch (e) {
      // print("$e");
    }
    return 0;
  }

  //Get Order Detail
  Future<List<OrderDetailModel>?> getOrderDetail(String date) async {
    List<OrderDetailModel> lists = [];
    var database = await getDatabase();
    List<Map<String, dynamic>> result = await database.query(
        "pembelianBarangDetail",
        where: "created LIKE ?",
        whereArgs: ['%$date%']);
    if (result.isNotEmpty) {
      for (var i = 0; i < result.length; i++) {
        int idProduct = int.parse("${result[i]['idProduct']}");
        var product = await showProduct(idProduct);
        var transaksi =
            await showTransaksDetailProduct(date, idProduct.toString());
        lists.add(OrderDetailModel(
          id: result[i]['id'],
          idPembelian: result[i]['idPembelian'],
          idProduct: result[i]['idProduct'],
          qty: result[i]['qty'],
          stockBarang: result[i]['stockBarang'],
          created: result[i]['created'],
          product: product,
          orderDetail: transaksi,
        ));
      }
    }
    // print("Ini ${lists.length}");
    return lists;
  }

  //Get Order Detail
  Future<List<OrderDetailModel>?> getOrderDetailPembelian(
      String idPembelian) async {
    List<OrderDetailModel> lists = [];
    var database = await getDatabase();
    List<Map<String, dynamic>> result = await database.query(
        "pembelianBarangDetail",
        where: "idPembelian = ?",
        whereArgs: [idPembelian]);
    if (result.isNotEmpty) {
      for (var i = 0; i < result.length; i++) {
        lists.add(OrderDetailModel(
          id: result[i]['id'],
          idPembelian: result[i]['idPembelian'],
          idProduct: result[i]['idProduct'],
          qty: result[i]['qty'],
          created: result[i]['created'],
        ));
      }
    }
    // print("Ini ${lists.length}");
    return lists;
  }

  // create order
  Future<int> insertOrderDetail(OrderDetailModel order) async {
    try {
      var database = await getDatabase();
      int id = await database.insert("pembelianBarangDetail", order.toJson());
      return id;
    } catch (e) {
      // print("$e");
    }
    return 0;
  }

  //Get Suplier
  Future<List<SuplierModel>?> getSuplier() async {
    List<SuplierModel> lists = [];
    var database = await getDatabase();
    List<Map<String, dynamic>> result =
        await database.query("suplier", orderBy: "name ASC");
    if (result.isNotEmpty) {
      for (var i = 0; i < result.length; i++) {
        lists.add(SuplierModel(
          id: result[i]['id'],
          name: result[i]['name'],
          email: result[i]['email'],
          phone: result[i]['phone'],
          created: result[i]['created'],
        ));
      }
    }
    // print("Ini ${lists.length}");
    return lists;
  }

  //Get Suplier
  Future<List<SuplierModel>?> getSuplierName(String name) async {
    List<SuplierModel> lists = [];
    var database = await getDatabase();
    List<Map<String, dynamic>> result = await database.query("suplier",
        where: "name LIKE ?", whereArgs: ['%$name%'], orderBy: "name ASC");
    if (result.isNotEmpty) {
      for (var i = 0; i < result.length; i++) {
        lists.add(SuplierModel(
          id: result[i]['id'],
          name: result[i]['name'],
          email: result[i]['email'],
          phone: result[i]['phone'],
          created: result[i]['created'],
        ));
      }
    }
    // print("Ini ${lists.length}");
    return lists;
  }

  // create order
  Future<int> insertSuplier(SuplierModel suplier) async {
    try {
      var database = await getDatabase();
      int id = await database.insert("suplier", suplier.toJson());
      return id;
    } catch (e) {
      // print("$e");
    }
    return 0;
  }

  //Update Cart product
  Future<int> updateSuplier(SuplierModel suplier) async {
    try {
      var database = await getDatabase();
      int id = await database.rawUpdate(
          "update suplier set name = ?, email = ?, phone = ? where id = ?",
          [suplier.name, suplier.email, suplier.phone, suplier.id]);
      return id;
    } catch (e) {
      // print("$e");
    }
    return 0;
  }

  //Delete hutang gula
  Future<int> deleteSuplier(int idSuplier) async {
    try {
      var database = await getDatabase();
      int id = await database
          .delete("suplier", where: "id = ?", whereArgs: [idSuplier]);
      return id;
    } catch (e) {
      // print("$e");
    }
    return 0;
  }

  //Get Suplier
  Future<List<ShiftModel>?> getShift() async {
    List<ShiftModel> lists = [];
    var database = await getDatabase();
    String sql =
        "WITH TransaksiSummary AS (SELECT shiftId, SUM(CAST(totalHarga AS INT)) AS totTrans, SUM(CAST(totalKasbon AS INT)) AS totalKasbon, SUM(CASE WHEN weightGula IS NOT NULL AND priceBeliGula IS NOT NULL THEN CAST(weightGula AS REAL) * CAST(priceBeliGula AS REAL) ELSE 0 END) AS totalGula, SUM(CAST(setorKasbon AS INT)) AS setorKasbon, SUM(CAST(setorGula AS INT)) AS SetorHutang FROM transaksi GROUP BY shiftId), FinanceSummary AS (SELECT shiftId, SUM(CASE WHEN type = 'Pengeluaran' THEN CAST(nominal AS INT) ELSE 0 END) AS totPengeluaran, SUM(CASE WHEN type = 'Pemasukan' THEN CAST(nominal AS INT) ELSE 0 END) AS totPemasukan FROM finance GROUP BY shiftId) SELECT shift.id AS idShift, shift.modal, shift.startShift, shift.endShift, shift.totalUang, shift.selisih, shift.created, COALESCE(ts.totTrans, 0) AS totTrans, COALESCE(ts.totalKasbon, 0) AS totalKasbon, COALESCE(ts.totalGula, 0) AS totalGula, COALESCE(ts.setorKasbon, 0) AS setorKasbon, COALESCE(ts.SetorHutang, 0) AS SetorHutang, COALESCE(fs.totPengeluaran, 0) AS totPengeluaran, COALESCE(fs.totPemasukan, 0) AS totPemasukan FROM shift LEFT JOIN TransaksiSummary ts ON ts.shiftId = shift.id LEFT JOIN FinanceSummary fs ON fs.shiftId = shift.id WHERE shift.endShift NOT NULL ORDER BY shift.created DESC";
    List<Map<String, dynamic>> result = await database.rawQuery(sql);
    if (result.isNotEmpty) {
      for (var i = 0; i < result.length; i++) {
        var data = result[i];
        if (data['idShift'] != null) {
          int setor = 0;
          double totalGula = (data['totalGula'] != null)
              ? double.parse(data['totalGula'].toString())
              : 0.0;
          int total = totalGula.toInt();
          if (data['SetorHutang'] != null) {
            setor = setor + int.parse(data['SetorHutang'].toString());
          }
          if (data['setorKasbon'] != null) {
            setor = setor + int.parse(data['setorKasbon'].toString());
          }
          lists.add(ShiftModel(
            id: data['idShift'],
            modal: data['modal'],
            startShift: data['startShift'],
            endShift: data['endShift'],
            totalUang: data['totalUang'],
            selisih: data['selisih'],
            created: data['created'],
            totalTransaksi:
                (data['totTrans'] != null) ? data['totTrans'].toString() : null,
            totalKasbon: (data['totalKasbon'] != null)
                ? data['totalKasbon'].toString()
                : null,
            totalSetor: setor.toString(),
            totalGula: total.toString(),
            totalPengeluaran: data['totPengeluaran'].toString(),
            totalPemasukan: data['totPemasukan'].toString(),
          ));
        }
      }
    }
    // print("Ini ${lists.length}");
    return lists;
  }

  //Get Suplier
  Future<ShiftModel?> showShift(String date) async {
    ShiftModel? lists;
    var database = await getDatabase();
    String sql =
        "WITH TransaksiSummary AS (SELECT shiftId, SUM(CAST(totalHarga AS INT)) AS totTrans, SUM(CAST(totalKasbon AS INT)) AS totalKasbon, SUM(CASE WHEN weightGula IS NOT NULL AND priceBeliGula IS NOT NULL THEN CAST(weightGula AS REAL) * CAST(priceBeliGula AS REAL) ELSE 0 END) AS totalGula, SUM(CAST(setorKasbon AS INT)) AS setorKasbon, SUM(CAST(setorGula AS INT)) AS SetorHutang FROM transaksi GROUP BY shiftId), FinanceSummary AS (SELECT shiftId, SUM(CASE WHEN type = 'Pengeluaran' THEN CAST(nominal AS INT) ELSE 0 END) AS totPengeluaran, SUM(CASE WHEN type = 'Pemasukan' THEN CAST(nominal AS INT) ELSE 0 END) AS totPemasukan FROM finance GROUP BY shiftId) SELECT shift.id AS idShift, shift.modal, shift.startShift, shift.endShift, shift.totalUang, shift.selisih, shift.created, COALESCE(ts.totTrans, 0) AS totTrans, COALESCE(ts.totalKasbon, 0) AS totalKasbon, COALESCE(ts.totalGula, 0) AS totalGula, COALESCE(ts.setorKasbon, 0) AS setorKasbon, COALESCE(ts.SetorHutang, 0) AS SetorHutang, COALESCE(fs.totPengeluaran, 0) AS totPengeluaran, COALESCE(fs.totPemasukan, 0) AS totPemasukan FROM shift LEFT JOIN TransaksiSummary ts ON ts.shiftId = shift.id LEFT JOIN FinanceSummary fs ON fs.shiftId = shift.id WHERE shift.created LIKE '%$date%' AND shift.endShift IS NULL";
    List<Map<String, dynamic>> result = await database.rawQuery(sql);
    if (result.isNotEmpty) {
      var data = result.first;
      int setor = 0;
      double totalGula = (data['totalGula'] != null)
          ? double.parse(data['totalGula'].toString())
          : 0.0;
      int total = totalGula.toInt();
      if (data['SetorHutang'] != null) {
        setor = setor + int.parse(data['SetorHutang'].toString());
      }
      if (data['setorKasbon'] != null) {
        setor = setor + int.parse(data['setorKasbon'].toString());
      }
      lists = ShiftModel(
        id: data['idShift'],
        modal: data['modal'],
        startShift: data['startShift'],
        endShift: data['endShift'],
        totalUang: data['totalUang'],
        selisih: data['selisih'],
        created: data['created'],
        totalTransaksi:
            (data['totTrans'] != null) ? data['totTrans'].toString() : null,
        totalKasbon: (data['totalKasbon'] != null)
            ? data['totalKasbon'].toString()
            : null,
        totalSetor: setor.toString(),
        totalGula: total.toString(),
        totalPengeluaran: data['totPengeluaran'].toString(),
        totalPemasukan: data['totPemasukan'].toString(),
      );
    }
    // print("Ini ${lists.length}");
    return lists;
  }

  // create order
  Future<int> insertShift(ShiftModel shift) async {
    try {
      var database = await getDatabase();
      int id = await database.insert("shift", shift.toJson());
      return id;
    } catch (e) {
      // print("$e");
    }
    return 0;
  }

  //Update Cart product
  Future<int> updateShift(ShiftModel shift) async {
    try {
      var database = await getDatabase();
      int id = await database.rawUpdate(
          "update shift set modal = ?, startShift = ?, endShift = ?, totalUang = ?, selisih = ?  where id = ?",
          [
            shift.modal,
            shift.startShift,
            shift.endShift,
            shift.totalUang,
            shift.selisih,
            shift.id
          ]);
      return id;
    } catch (e) {
      // print("$e");
    }
    return 0;
  }

  //Get Suplier
  Future<List<FinanceModel>?> getFinance(Map<String, dynamic> map) async {
    List<FinanceModel> lists = [];
    var database = await getDatabase();
    String sql = "SELECT * FROM finance";
    var search = map['search'];
    var tanggal = map['tanggal'];
    if (search != "") {
      sql += " WHERE note LIKE '%$search%'";
    } else {
      sql += " WHERE created LIKE '%$tanggal%'";
    }
    sql += " ORDER BY created DESC";
    List<Map<String, dynamic>> result = await database.rawQuery(sql);
    if (result.isNotEmpty) {
      for (var i = 0; i < result.length; i++) {
        lists.add(FinanceModel(
          id: result[i]['id'],
          shiftId: result[i]['shiftId'],
          type: result[i]['type'],
          nominal: result[i]['nominal'],
          note: result[i]['note'],
          created: result[i]['created'],
        ));
      }
    }
    // print("Ini ${lists.length}");
    return lists;
  }

  // create order
  Future<int> insertFinance(FinanceModel finance) async {
    try {
      var database = await getDatabase();
      int id = await database.insert("finance", finance.toJson());
      return id;
    } catch (e) {
      // print("$e");
    }
    return 0;
  }

  //Get Suplier
  Future<List<AdjustmentModel>?> getAdjustment() async {
    List<AdjustmentModel> lists = [];
    var database = await getDatabase();
    List<Map<String, dynamic>> result =
        await database.query("adjustment", orderBy: "created DESC");
    if (result.isNotEmpty) {
      for (var i = 0; i < result.length; i++) {
        lists.add(AdjustmentModel(
          id: result[i]['id'],
          note: result[i]['note'],
          created: result[i]['created'],
        ));
      }
    }
    // print("Ini ${lists.length}");
    return lists;
  }

  //Get Order Detail
  Future<List<AdjustmentModelDetail>?> getOrderDetailAdjustment(
      String date) async {
    List<AdjustmentModelDetail> lists = [];
    var database = await getDatabase();
    String sql =
        "SELECT adjustmentDetail.id AS detId, adjustmentDetail.idAdjustment, adjustmentDetail.idProduct,adjustmentDetail.hargaModal,adjustmentDetail.stock, adjustmentDetail.adjustment,adjustmentDetail.created AS detCreated, adjustment.note FROM adjustmentDetail LEFT JOIN adjustment ON adjustmentDetail.idAdjustment = adjustment.id WHERE adjustmentDetail.created LIKE '%$date%'";
    List<Map<String, dynamic>> result = await database.rawQuery(sql);
    if (result.isNotEmpty) {
      for (var i = 0; i < result.length; i++) {
        int idProduct = int.parse(result[i]['idProduct']);
        var product = await showProduct(idProduct);
        lists.add(AdjustmentModelDetail(
          id: result[i]['detId'],
          idAdjustment: result[i]['idAdjustment'],
          idProduct: result[i]['idProduct'],
          hargaModal: result[i]['hargaModal'],
          stock: result[i]['stock'],
          adjustment: result[i]['adjustment'],
          created: result[i]['detCreated'],
          product: product,
          adjustmentModel:
              AdjustmentModel(note: result[i]['note'], created: null),
        ));
      }
    }
    // print("Ini ${lists.length}");
    return lists;
  }

  // create order
  Future<bool> insertAdjustment(AdjustmentModel adj) async {
    try {
      var database = await getDatabase();
      int id = await database.insert("adjustment", adj.toJson());
      if (adj.detail!.isNotEmpty) {
        for (var data in adj.detail!) {
          data.idAdjustment = id.toString();
          await insertAdjustmentDetail(data);
        }
      }
      return true;
    } catch (e) {
      // print("$e");
    }
    return false;
  }

  // create order
  Future<bool> insertAdjustmentDetail(AdjustmentModelDetail adj) async {
    try {
      var database = await getDatabase();
      await database.insert("adjustmentDetail", adj.toJson());
      return true;
    } catch (e) {
      // print("$e");
    }
    return false;
  }
}

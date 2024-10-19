import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kasir_dekstop/bloc/category/category_bloc.dart';
import 'package:kasir_dekstop/bloc/product/product_bloc.dart';
import 'package:kasir_dekstop/bloc/request_variant/request_variant_bloc.dart';
import 'package:kasir_dekstop/helper/number_format.dart';
import 'package:kasir_dekstop/models/product_models.dart';
import 'package:kasir_dekstop/models/varian_model.dart';
import 'package:kasir_dekstop/models/varian_reesponse_model.dart';
import 'package:kasir_dekstop/page/ofiice/library/widget/add_harga_modal.dart';
import 'package:kasir_dekstop/page/ofiice/library/widget/add_stok.dart';
import 'package:kasir_dekstop/page/ofiice/library/widget/add_varian.dart';
import 'package:kasir_dekstop/page/ofiice/library/widget/categori.dart';
import 'package:kasir_dekstop/widget/bottom_nav.dart';
import 'package:kasir_dekstop/widget/sidebar.dart';
import 'package:pluto_grid/pluto_grid.dart';

class ItemLibraryScreen extends StatefulWidget {
  static String routeName = '/ofice/item-library';
  const ItemLibraryScreen({super.key});

  @override
  State<ItemLibraryScreen> createState() => _ItemLibraryScreenState();
}

class _ItemLibraryScreenState extends State<ItemLibraryScreen> {
  TextEditingController? txtNamaBarang;
  TextEditingController? txtCategory;
  TextEditingController? txtDeskripsi;
  TextEditingController? txtHarga;
  TextEditingController? txtSku;
  TextEditingController? txtModal;
  TextEditingController? txtStok;
  TextEditingController? txtSeach;
  List<VarianModel> varian = [];
  String? kategori;
  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(GetProducts());
    context.read<CategoryBloc>().add(GetCategory());
    txtNamaBarang = TextEditingController();
    txtCategory = TextEditingController();
    txtDeskripsi = TextEditingController();
    txtHarga = TextEditingController();
    txtSku = TextEditingController();
    txtModal = TextEditingController();
    txtStok = TextEditingController();
    txtSeach = TextEditingController();
  }

  late PlutoGridStateManager stateManager;

  @override
  Widget build(BuildContext context) {
    List<dynamic> buttonNaf = [
      {
        'name': "Home",
        'route': "/home",
        'icon': const Icon(
          Icons.home,
          color: Colors.purple,
        ),
        'active': "false"
      },
      {
        'name': "Dashboard",
        'route': "/ofice/dashboard",
        'icon': const Icon(
          Icons.dashboard,
          color: Colors.purple,
        ),
        'active': "true"
      }
    ];
    final productBlock = BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is ProductLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is ProductSuccess) {
          return PlutoGrid(
            columns: [
              PlutoColumn(
                readOnly: true,
                title: "Sku",
                field: "sku",
                type: PlutoColumnType.text(),
              ),
              PlutoColumn(
                readOnly: true,
                title: "Name",
                field: "name",
                type: PlutoColumnType.text(),
              ),
              PlutoColumn(
                readOnly: true,
                title: "Category",
                field: "category",
                type: PlutoColumnType.text(),
              ),
              PlutoColumn(
                readOnly: true,
                title: "Stock",
                field: "stock",
                type: PlutoColumnType.text(),
              ),
              PlutoColumn(
                readOnly: true,
                title: "Harga Jual",
                field: "jual",
                type: PlutoColumnType.text(),
              ),
              PlutoColumn(
                readOnly: true,
                title: "Harga Beli",
                field: "beli",
                type: PlutoColumnType.text(),
              ),
              PlutoColumn(
                readOnly: true,
                title: "Harga Promo",
                field: "promo",
                type: PlutoColumnType.text(),
              ),
              PlutoColumn(
                readOnly: true,
                title: "Diskon",
                field: "diskon",
                type: PlutoColumnType.text(),
              ),
              PlutoColumn(
                readOnly: true,
                title: "Min Belanja",
                field: "min",
                type: PlutoColumnType.text(),
              ),
              PlutoColumn(
                readOnly: true,
                title: "Aksi",
                field: "aksi",
                width: 100,
                type: PlutoColumnType.text(),
                renderer: (rendererContext) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          txtNamaBarang!.text = state
                              .product![rendererContext.row.sortIdx].namaBarang;
                          if (state.product![rendererContext.row.sortIdx]
                                  .categori !=
                              null) {
                            txtCategory!.text =
                                "${state.product![rendererContext.row.sortIdx].idCategory}";
                          }
                          txtDeskripsi!.text = state
                              .product![rendererContext.row.sortIdx].deskripsi;
                          txtHarga!.text = NumberFormats.convertToIdr(state
                              .product![rendererContext.row.sortIdx].harga
                              .replaceAll('.', ''));
                          txtModal!.text = NumberFormats.convertToIdr(state
                              .product![rendererContext.row.sortIdx].hargaModal
                              .replaceAll('.', ''));
                          txtSku!.text =
                              state.product![rendererContext.row.sortIdx].sku;
                          txtStok!.text =
                              state.product![rendererContext.row.sortIdx].stock;
                          state.product![rendererContext.row.sortIdx].varian
                              ?.forEach((val) {
                            varian.add(VarianModel(
                              id: val.id.toString(),
                              namaVarian: val.namaVarian,
                              hargaVarian: val.hargaVarian,
                              skuVarian: val.skuVarian,
                              stokVarian: val.stokVarian,
                              hargaModalVarian: val.hargaModalVarian,
                            ));
                          });
                          context
                              .read<RequestVariantBloc>()
                              .add(GetVarianList(formVarian: varian));
                          modalEdit(context,
                              state.product![rendererContext.row.sortIdx]);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(20)),
                          child: const Icon(
                            Icons.edit_outlined,
                            color: Colors.white,
                            size: 15,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      InkWell(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text(
                                      "Apa anda yakin ingin menghapus ?"),
                                  content: const Text(
                                      "data yang dihapus tidak dapat dikembalikan"),
                                  actions: [
                                    BlocConsumer<ProductBloc, ProductState>(
                                      listener: (context, states) {
                                        if (states is ProductDeleteSuccess) {
                                          Navigator.of(context).pop();
                                        }
                                      },
                                      builder: (context, states) {
                                        if (states is ProductLoading) {
                                          return ElevatedButton(
                                            onPressed: () {},
                                            style: ElevatedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                fixedSize: const Size(70, 40),
                                                backgroundColor:
                                                    const Color(0XFF2334A6)),
                                            child: Text(
                                              "Ya",
                                              style:
                                                  GoogleFonts.playfairDisplay(
                                                      color: const Color(
                                                          0XFFFFFFFF),
                                                      fontSize: 20),
                                            ),
                                          );
                                        }
                                        return ElevatedButton(
                                          onPressed: () {
                                            var model = state.product![
                                                rendererContext.row.sortIdx];
                                            context.read<ProductBloc>().add(
                                                DeleteProduct(
                                                    productsModel: model));
                                            context
                                                .read<ProductBloc>()
                                                .add(GetProducts());
                                          },
                                          style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              fixedSize: const Size(70, 40),
                                              backgroundColor:
                                                  const Color(0XFF2334A6)),
                                          child: Text(
                                            "Ya",
                                            style: GoogleFonts.playfairDisplay(
                                                color: const Color(0XFFFFFFFF),
                                                fontSize: 20),
                                          ),
                                        );
                                      },
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          fixedSize: const Size(100, 40),
                                          backgroundColor:
                                              const Color(0xFFC0C2D1)),
                                      child: Text(
                                        "Tidak",
                                        style: GoogleFonts.playfairDisplay(
                                            color: const Color(0xFF252323),
                                            fontSize: 20),
                                      ),
                                    )
                                  ],
                                );
                              });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(20)),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: 15,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
            rows: [
              for (var i = 0; i < state.product!.length; i++)
                PlutoRow(cells: {
                  "sku": PlutoCell(value: state.product![i].sku),
                  "name": PlutoCell(value: state.product![i].namaBarang),
                  "category": PlutoCell(
                      value: (state.product![i].categori == null)
                          ? "-"
                          : "${state.product![i].categori!.nama}"),
                  "stock": PlutoCell(value: state.product![i].stock),
                  "jual": PlutoCell(
                      value:
                          NumberFormats.convertToIdr(state.product![i].harga)),
                  "beli": PlutoCell(
                      value: NumberFormats.convertToIdr(
                          state.product![i].hargaModal)),
                  "promo": PlutoCell(
                      value: (state.product![i].promoProducts != null)
                          ? NumberFormats.convertToIdr(
                              state.product![i].promoProducts!.hargaPromo!)
                          : "0"),
                  "diskon": PlutoCell(
                      value: (state.product![i].promoProducts != null)
                          ? "${state.product![i].promoProducts!.discount!}%"
                          : "0"),
                  "min": PlutoCell(
                      value: (state.product![i].promoProducts != null)
                          ? state.product![i].promoProducts!.minBelanja!
                          : "0"),
                  "aksi": PlutoCell(value: "aksi"),
                }),
            ],
            onLoaded: (PlutoGridOnLoadedEvent event) {
              stateManager = event.stateManager;
              stateManager.setShowColumnFilter(false);
            },
            createFooter: (stateManager) {
              stateManager.setPageSize(20, notify: false); // default 40
              return PlutoPagination(stateManager);
            },
          );
        }
        return const Center(
          child: Text("data tidak ditemukan"),
        );
      },
    );
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(color: Color(0xFFF5F1F1)),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  const SideBar(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(30),
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Item Library",
                              style: GoogleFonts.playfairDisplay(
                                  fontSize: 30, fontWeight: FontWeight.w600),
                            ),
                            Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      fixedSize: const Size(200, 50),
                                      backgroundColor: const Color(0XFF2334A6)),
                                  child: Text(
                                    "Import / Export",
                                    style: GoogleFonts.playfairDisplay(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                ElevatedButton(
                                  onPressed: () {
                                    context.read<RequestVariantBloc>().add(
                                        GetVarianList(formVarian: const []));
                                    modalAdd(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      fixedSize: const Size(150, 50),
                                      backgroundColor: const Color(0XFF2334A6)),
                                  child: Text(
                                    "Add Item",
                                    style: GoogleFonts.playfairDisplay(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        padding:
                            const EdgeInsets.only(top: 15, left: 5, right: 35),
                        child: Row(
                          children: [
                            Container(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 10),
                              width: MediaQuery.of(context).size.width * 0.21,
                              height: 35,
                              child: TextField(
                                controller: txtSeach,
                                minLines: 1,
                                keyboardType: TextInputType.text,
                                onSubmitted: (value) {
                                  context.read<ProductBloc>().add(
                                      GetProductsByName(
                                          type: "search",
                                          nama: txtSeach!.text));
                                },
                                maxLines: null,
                                readOnly: false,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "Search",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 10),
                                  isDense: true,
                                ),
                                style: const TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.1,
                              child: ElevatedButton(
                                onPressed: () {
                                  context.read<ProductBloc>().add(
                                      GetProductsByName(
                                          type: "search",
                                          nama: txtSeach!.text));
                                },
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    fixedSize: const Size(10, 35),
                                    backgroundColor: const Color(0XFF2334A6)),
                                child: Text(
                                  "Search",
                                  style: GoogleFonts.playfairDisplay(
                                      color: const Color(0XFFFFFFFF),
                                      fontSize: 16),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: 420,
                        padding: const EdgeInsets.all(20.0),
                        child: productBlock,
                      )
                    ],
                  )
                ],
              ),
            ),
            BottomNav(
              buttonNav: buttonNaf,
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> modalAdd(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // header
                Container(
                  height: 100,
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: const Color(0xFFFAF5F5))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          varian = [];
                          context
                              .read<RequestVariantBloc>()
                              .add(GetVarianList(formVarian: const []));
                          txtNamaBarang!.clear();
                          txtCategory!.clear();
                          txtDeskripsi!.clear();
                          txtHarga!.clear();
                          txtModal!.clear();
                          txtSku!.clear();
                          txtStok!.clear();
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            fixedSize: const Size(150, 70),
                            backgroundColor: const Color(0XFFFFFFFF)),
                        child: Text(
                          "Cancel",
                          style: GoogleFonts.playfairDisplay(
                              color: const Color(0XFF2334A6), fontSize: 20),
                        ),
                      ),
                      BlocConsumer<ProductBloc, ProductState>(
                        listener: (context, state) {
                          if (state is ProductCreateSuccess) {
                            List<VarianModel> reqVarian = [];
                            if (varian.isNotEmpty) {
                              for (var element in varian) {
                                reqVarian.add(VarianModel(
                                  namaVarian: element.namaVarian,
                                  hargaVarian:
                                      element.hargaVarian.replaceAll('.', ''),
                                  skuVarian: element.skuVarian,
                                  stokVarian: element.stokVarian,
                                  hargaModalVarian: element.hargaModalVarian
                                      .replaceAll('.', ''),
                                ));
                              }
                              context.read<RequestVariantBloc>().add(
                                  CreateVarian(
                                      formVarian: reqVarian,
                                      idBarang: state.id));
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  backgroundColor: Colors.blue,
                                  content: Text('Success Menambah Product')),
                            );
                            txtNamaBarang!.clear();
                            txtCategory!.clear();
                            txtDeskripsi!.clear();
                            txtHarga!.clear();
                            txtModal!.clear();
                            txtSku!.clear();
                            txtStok!.clear();
                            varian = [];
                            Navigator.of(context).pop();
                          }
                        },
                        builder: (context, state) {
                          if (state is ProductLoading) {
                            return ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  fixedSize: const Size(150, 70),
                                  backgroundColor: const Color(0XFF2334A6)),
                              child: Text(
                                "Save",
                                style: GoogleFonts.playfairDisplay(
                                    color: const Color(0XFFFFFFFF),
                                    fontSize: 20),
                              ),
                            );
                          }
                          return ElevatedButton(
                            onPressed: () {
                              int id = int.parse(txtCategory!.text);
                              ProductsModel req = ProductsModel(
                                  namaBarang: txtNamaBarang!.text,
                                  idCategory: id,
                                  idVarian: 0,
                                  deskripsi: txtDeskripsi!.text,
                                  harga: txtHarga!.text.replaceAll('.', ''),
                                  sku: txtSku!.text,
                                  hargaModal:
                                      txtModal!.text.replaceAll('.', ''),
                                  stock: txtStok!.text,
                                  createdAt: DateTime.now().toIso8601String());
                              context
                                  .read<ProductBloc>()
                                  .add(CreateProduct(productsModel: req));
                              context.read<ProductBloc>().add(GetProducts());
                            },
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                fixedSize: const Size(150, 70),
                                backgroundColor: const Color(0XFF2334A6)),
                            child: Text(
                              "Save",
                              style: GoogleFonts.playfairDisplay(
                                  color: const Color(0XFFFFFFFF), fontSize: 20),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                // body,
                const SizedBox(height: 15),
                Expanded(
                    child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(20),
                  color: Colors.white,
                  child: ListView(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Nama Barang",
                            style: GoogleFonts.playfairDisplay(fontSize: 20),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: txtNamaBarang,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                contentPadding: const EdgeInsets.only(
                                    left: 35, top: 8, bottom: 15),
                                fillColor: Colors.white,
                                hintText: "Nama Barang",
                                hintStyle:
                                    const TextStyle(color: Color(0XFFAA9D9D))),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Category",
                            style: GoogleFonts.playfairDisplay(fontSize: 20),
                          ),
                          const SizedBox(height: 10),
                          Categori(txtCategory: txtCategory)
                        ],
                      ),
                      const SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Deskripsi",
                            style: GoogleFonts.playfairDisplay(fontSize: 20),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: txtDeskripsi,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              contentPadding: const EdgeInsets.only(
                                  left: 35, top: 8, bottom: 15),
                              fillColor: Colors.white,
                              hintText: "Deskripsi",
                              hintStyle:
                                  const TextStyle(color: Color(0XFFAA9D9D)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Pricing",
                        style: GoogleFonts.playfairDisplay(fontSize: 20),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.37,
                            child: TextField(
                              controller: txtHarga,
                              keyboardType: TextInputType.number,
                              onChanged: (val) {
                                setState(() {
                                  if (val.isNotEmpty) {
                                    val = val.replaceAll('.', '');
                                  } else {
                                    val = '';
                                  }
                                });
                                txtHarga!.value = TextEditingValue(
                                  text: NumberFormats.convertToIdr(val),
                                  selection: TextSelection.fromPosition(
                                    TextPosition(
                                        offset: NumberFormats.convertToIdr(val)
                                            .length),
                                  ),
                                );
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                contentPadding: const EdgeInsets.only(
                                    left: 35, top: 8, bottom: 15),
                                fillColor: Colors.white,
                                hintText: "Harga",
                                hintStyle:
                                    const TextStyle(color: Color(0XFFAA9D9D)),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.37,
                            child: TextField(
                              controller: txtSku,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                contentPadding: const EdgeInsets.only(
                                    left: 35, top: 8, bottom: 15),
                                fillColor: Colors.white,
                                hintText: "Sku",
                                hintStyle:
                                    const TextStyle(color: Color(0XFFAA9D9D)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          if (varian.isEmpty) {
                            var varianModel = VarianModel();
                            varian.add(varianModel);
                            context
                                .read<RequestVariantBloc>()
                                .add(GetVarianList(formVarian: varian));
                          } else {
                            for (var element in varian) {
                              element.hargaModalVarian =
                                  element.hargaModalVarian.replaceAll('.', '');
                              element.hargaVarian =
                                  element.hargaVarian.replaceAll('.', '');
                            }
                          }
                          modalVariant(context);
                        },
                        style: ElevatedButton.styleFrom(
                          fixedSize:
                              Size(MediaQuery.of(context).size.width * 1, 40),
                          backgroundColor: const Color(0XFF2334A6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: Text(
                          "Add Variant",
                          textAlign: TextAlign.start,
                          style: GoogleFonts.playfairDisplay(
                              fontSize: 16, color: Colors.white),
                        ),
                      ),
                      BlocBuilder<RequestVariantBloc, RequestVariantState>(
                        builder: (context, state) {
                          if (state is RequestVariantList) {
                            return Column(
                              children: state.formVarian.map((val) {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          bottom:
                                              BorderSide(color: Colors.black),
                                        ),
                                      ),
                                      padding: const EdgeInsets.all(10),
                                      margin: const EdgeInsets.all(10),
                                      width: MediaQuery.of(context).size.width *
                                          0.15,
                                      child: Text(val.namaVarian),
                                    ),
                                    Container(
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          bottom:
                                              BorderSide(color: Colors.black),
                                        ),
                                      ),
                                      padding: const EdgeInsets.all(10),
                                      margin: const EdgeInsets.all(10),
                                      width: MediaQuery.of(context).size.width *
                                          0.15,
                                      child: Text(NumberFormats.convertToIdr(
                                          val.hargaVarian.replaceAll('.', ''))),
                                    ),
                                    Container(
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          bottom:
                                              BorderSide(color: Colors.black),
                                        ),
                                      ),
                                      padding: const EdgeInsets.all(10),
                                      margin: const EdgeInsets.all(10),
                                      width: MediaQuery.of(context).size.width *
                                          0.15,
                                      child: Text(val.skuVarian),
                                    ),
                                  ],
                                );
                              }).toList(),
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Inventory",
                        style: GoogleFonts.playfairDisplay(fontSize: 20),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          modalStock(context);
                        },
                        style: ElevatedButton.styleFrom(
                          fixedSize:
                              Size(MediaQuery.of(context).size.width * 1, 40),
                          backgroundColor: const Color(0XFF2334A6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: Text(
                          "Manage Stock",
                          style: GoogleFonts.playfairDisplay(
                              fontSize: 16, color: Colors.white),
                        ),
                      ),
                      BlocBuilder<RequestVariantBloc, RequestVariantState>(
                        builder: (context, state) {
                          if (state is RequestVariantList) {
                            return Column(
                              children: state.formVarian.map((val) {
                                return (val.stokVarian.isNotEmpty)
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            decoration: const BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                    color: Colors.black),
                                              ),
                                            ),
                                            padding: const EdgeInsets.all(10),
                                            margin: const EdgeInsets.all(10),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.2,
                                            child: Text(val.namaVarian),
                                          ),
                                          Container(
                                            decoration: const BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                    color: Colors.black),
                                              ),
                                            ),
                                            padding: const EdgeInsets.all(10),
                                            margin: const EdgeInsets.all(10),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.2,
                                            child: Text(val.stokVarian),
                                          ),
                                        ],
                                      )
                                    : const Row();
                              }).toList(),
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Cost",
                        style: GoogleFonts.playfairDisplay(fontSize: 20),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          for (var element in varian) {
                            element.hargaModalVarian =
                                element.hargaModalVarian.replaceAll('.', '');
                            element.hargaVarian =
                                element.hargaVarian.replaceAll('.', '');
                          }
                          modalCost(context);
                        },
                        style: ElevatedButton.styleFrom(
                          fixedSize:
                              Size(MediaQuery.of(context).size.width * 1, 40),
                          backgroundColor: const Color(0XFF2334A6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: Text(
                          "Manage Cost / Harga Beli",
                          style: GoogleFonts.playfairDisplay(
                              fontSize: 16, color: Colors.white),
                        ),
                      ),
                      BlocBuilder<RequestVariantBloc, RequestVariantState>(
                        builder: (context, state) {
                          if (state is RequestVariantList) {
                            return Column(
                              children: state.formVarian.map((val) {
                                return (val.hargaModalVarian.isNotEmpty)
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            decoration: const BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                    color: Colors.black),
                                              ),
                                            ),
                                            padding: const EdgeInsets.all(10),
                                            margin: const EdgeInsets.all(10),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.2,
                                            child: Text(val.namaVarian),
                                          ),
                                          Container(
                                            decoration: const BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                    color: Colors.black),
                                              ),
                                            ),
                                            padding: const EdgeInsets.all(10),
                                            margin: const EdgeInsets.all(10),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.2,
                                            child: Text(
                                                NumberFormats.convertToIdr(val
                                                    .hargaModalVarian
                                                    .replaceAll('.', ''))),
                                          ),
                                        ],
                                      )
                                    : const Row();
                              }).toList(),
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                    ],
                  ),
                ))
              ],
            ),
          ),
        );
      },
    );
  }

  Future<dynamic> modalEdit(BuildContext context, ProductsModel product) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // header
                Container(
                  height: 100,
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: const Color(0xFFFAF5F5))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          varian = [];
                          txtNamaBarang!.clear();
                          txtCategory!.clear();
                          txtDeskripsi!.clear();
                          txtHarga!.clear();
                          txtModal!.clear();
                          txtSku!.clear();
                          txtStok!.clear();
                          context
                              .read<RequestVariantBloc>()
                              .add(GetVarianList(formVarian: const []));
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            fixedSize: const Size(150, 70),
                            backgroundColor: const Color(0XFFFFFFFF)),
                        child: Text(
                          "Cancel",
                          style: GoogleFonts.playfairDisplay(
                              color: const Color(0XFF2334A6), fontSize: 20),
                        ),
                      ),
                      BlocConsumer<ProductBloc, ProductState>(
                        listener: (context, state) {
                          if (state is ProductUpdateSuccess) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  backgroundColor: Colors.blue,
                                  content: Text('Success Menambah Product')),
                            );
                            txtNamaBarang!.clear();
                            txtCategory!.clear();
                            txtDeskripsi!.clear();
                            txtHarga!.clear();
                            txtModal!.clear();
                            txtSku!.clear();
                            txtStok!.clear();
                            Navigator.of(context).pop();
                            context.read<ProductBloc>().add(GetProducts());
                            varian = [];
                          }
                        },
                        builder: (context, state) {
                          if (state is ProductLoading) {
                            return ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  fixedSize: const Size(150, 70),
                                  backgroundColor: const Color(0XFF2334A6)),
                              child: Text(
                                "Save",
                                style: GoogleFonts.playfairDisplay(
                                    color: const Color(0XFFFFFFFF),
                                    fontSize: 20),
                              ),
                            );
                          }
                          return ElevatedButton(
                            onPressed: () {
                              List<VarianResponseModel> reqVarian = [];
                              if (varian.isNotEmpty) {
                                for (var element in varian) {
                                  int id = 0;
                                  if (element.id.isNotEmpty) {
                                    id = int.parse(element.id);
                                  }
                                  reqVarian.add(VarianResponseModel(
                                    id: id,
                                    idBarang: "0",
                                    namaVarian: element.namaVarian,
                                    hargaVarian:
                                        element.hargaVarian.replaceAll('.', ''),
                                    skuVarian: element.skuVarian,
                                    stokVarian: element.stokVarian,
                                    hargaModalVarian: element.hargaModalVarian
                                        .replaceAll('.', ''),
                                  ));
                                }
                              }
                              int id = int.parse(txtCategory!.text);
                              ProductsModel req = ProductsModel(
                                id: product.id,
                                namaBarang: txtNamaBarang!.text,
                                idCategory: id,
                                idVarian: 0,
                                deskripsi: txtDeskripsi!.text,
                                harga: txtHarga!.text.replaceAll('.', ''),
                                sku: txtSku!.text,
                                hargaModal: txtModal!.text.replaceAll('.', ''),
                                stock: txtStok!.text,
                                createdAt: DateTime.now().toIso8601String(),
                                varian: reqVarian,
                              );
                              context
                                  .read<ProductBloc>()
                                  .add(UpdateProduct(productsModel: req));
                            },
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                fixedSize: const Size(150, 70),
                                backgroundColor: const Color(0XFF2334A6)),
                            child: Text(
                              "Save",
                              style: GoogleFonts.playfairDisplay(
                                  color: const Color(0XFFFFFFFF), fontSize: 20),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                // body,
                const SizedBox(height: 15),
                Expanded(
                    child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(20),
                  color: Colors.white,
                  child: ListView(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Nama Barang",
                            style: GoogleFonts.playfairDisplay(fontSize: 20),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: txtNamaBarang,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                contentPadding: const EdgeInsets.only(
                                    left: 35, top: 8, bottom: 15),
                                fillColor: Colors.white,
                                hintText: "Nama Barang",
                                hintStyle:
                                    const TextStyle(color: Color(0XFFAA9D9D))),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Category",
                            style: GoogleFonts.playfairDisplay(fontSize: 20),
                          ),
                          const SizedBox(height: 10),
                          Categori(txtCategory: txtCategory),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Deskripsi",
                            style: GoogleFonts.playfairDisplay(fontSize: 20),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: txtDeskripsi,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              contentPadding: const EdgeInsets.only(
                                  left: 35, top: 8, bottom: 15),
                              fillColor: Colors.white,
                              hintText: "Deskripsi",
                              hintStyle:
                                  const TextStyle(color: Color(0XFFAA9D9D)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Pricing",
                        style: GoogleFonts.playfairDisplay(fontSize: 20),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.37,
                            child: TextField(
                              controller: txtHarga,
                              keyboardType: TextInputType.number,
                              onChanged: (val) {
                                setState(() {
                                  if (val.isNotEmpty) {
                                    val = val.replaceAll('.', '');
                                  } else {
                                    val = '';
                                  }
                                });
                                txtHarga!.value = TextEditingValue(
                                  text: NumberFormats.convertToIdr(val),
                                  selection: TextSelection.fromPosition(
                                    TextPosition(
                                        offset: NumberFormats.convertToIdr(val)
                                            .length),
                                  ),
                                );
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                contentPadding: const EdgeInsets.only(
                                    left: 35, top: 8, bottom: 15),
                                fillColor: Colors.white,
                                hintText: "Harga",
                                hintStyle:
                                    const TextStyle(color: Color(0XFFAA9D9D)),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.37,
                            child: TextField(
                              controller: txtSku,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                contentPadding: const EdgeInsets.only(
                                    left: 35, top: 8, bottom: 15),
                                fillColor: Colors.white,
                                hintText: "Sku",
                                hintStyle:
                                    const TextStyle(color: Color(0XFFAA9D9D)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          if (varian.isEmpty) {
                            var varianModel = VarianModel();
                            varian.add(varianModel);
                          } else {
                            for (var element in varian) {
                              element.hargaModalVarian =
                                  element.hargaModalVarian.replaceAll('.', '');
                              element.hargaVarian =
                                  element.hargaVarian.replaceAll('.', '');
                            }
                          }
                          modalVariant(context);
                        },
                        style: ElevatedButton.styleFrom(
                          fixedSize:
                              Size(MediaQuery.of(context).size.width * 1, 40),
                          backgroundColor: const Color(0XFF2334A6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: Text(
                          "Add Variant",
                          textAlign: TextAlign.start,
                          style: GoogleFonts.playfairDisplay(
                              fontSize: 16, color: Colors.white),
                        ),
                      ),
                      BlocBuilder<RequestVariantBloc, RequestVariantState>(
                        builder: (context, state) {
                          if (state is RequestVariantList) {
                            return Column(
                              children: state.formVarian.map((val) {
                                String harga =
                                    val.hargaVarian.replaceAll('.', '');
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          bottom:
                                              BorderSide(color: Colors.black),
                                        ),
                                      ),
                                      padding: const EdgeInsets.all(10),
                                      margin: const EdgeInsets.all(10),
                                      width: MediaQuery.of(context).size.width *
                                          0.15,
                                      child: Text(val.namaVarian),
                                    ),
                                    Container(
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          bottom:
                                              BorderSide(color: Colors.black),
                                        ),
                                      ),
                                      padding: const EdgeInsets.all(10),
                                      margin: const EdgeInsets.all(10),
                                      width: MediaQuery.of(context).size.width *
                                          0.15,
                                      child: Text(
                                          NumberFormats.convertToIdr(harga)),
                                    ),
                                    Container(
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          bottom:
                                              BorderSide(color: Colors.black),
                                        ),
                                      ),
                                      padding: const EdgeInsets.all(10),
                                      margin: const EdgeInsets.all(10),
                                      width: MediaQuery.of(context).size.width *
                                          0.15,
                                      child: Text(val.skuVarian),
                                    ),
                                  ],
                                );
                              }).toList(),
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Inventory",
                        style: GoogleFonts.playfairDisplay(fontSize: 20),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          modalStock(context);
                        },
                        style: ElevatedButton.styleFrom(
                          fixedSize:
                              Size(MediaQuery.of(context).size.width * 1, 40),
                          backgroundColor: const Color(0XFF2334A6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: Text(
                          "Manage Stock",
                          style: GoogleFonts.playfairDisplay(
                              fontSize: 16, color: Colors.white),
                        ),
                      ),
                      BlocBuilder<RequestVariantBloc, RequestVariantState>(
                        builder: (context, state) {
                          if (state is RequestVariantList) {
                            return Column(
                              children: state.formVarian.map((val) {
                                return (val.stokVarian.isNotEmpty)
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            decoration: const BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                    color: Colors.black),
                                              ),
                                            ),
                                            padding: const EdgeInsets.all(10),
                                            margin: const EdgeInsets.all(10),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.2,
                                            child: Text(val.namaVarian),
                                          ),
                                          Container(
                                            decoration: const BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                    color: Colors.black),
                                              ),
                                            ),
                                            padding: const EdgeInsets.all(10),
                                            margin: const EdgeInsets.all(10),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.2,
                                            child: Text(val.stokVarian),
                                          ),
                                        ],
                                      )
                                    : const Row();
                              }).toList(),
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Cost",
                        style: GoogleFonts.playfairDisplay(fontSize: 20),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          for (var element in varian) {
                            element.hargaModalVarian =
                                element.hargaModalVarian.replaceAll('.', '');
                            element.hargaVarian =
                                element.hargaVarian.replaceAll('.', '');
                          }
                          modalCost(context);
                        },
                        style: ElevatedButton.styleFrom(
                          fixedSize:
                              Size(MediaQuery.of(context).size.width * 1, 40),
                          backgroundColor: const Color(0XFF2334A6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: Text(
                          "Manage Cost / Harga Beli",
                          style: GoogleFonts.playfairDisplay(
                              fontSize: 16, color: Colors.white),
                        ),
                      ),
                      BlocBuilder<RequestVariantBloc, RequestVariantState>(
                        builder: (context, state) {
                          if (state is RequestVariantList) {
                            return Column(
                              children: state.formVarian.map((val) {
                                String harga =
                                    val.hargaModalVarian.replaceAll('.', '');
                                return (val.hargaModalVarian.isNotEmpty)
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            decoration: const BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                    color: Colors.black),
                                              ),
                                            ),
                                            padding: const EdgeInsets.all(10),
                                            margin: const EdgeInsets.all(10),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.2,
                                            child: Text(val.namaVarian),
                                          ),
                                          Container(
                                            decoration: const BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                    color: Colors.black),
                                              ),
                                            ),
                                            padding: const EdgeInsets.all(10),
                                            margin: const EdgeInsets.all(10),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.2,
                                            child: Text(
                                                NumberFormats.convertToIdr(
                                                    harga)),
                                          ),
                                        ],
                                      )
                                    : const Row();
                              }).toList(),
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                    ],
                  ),
                ))
              ],
            ),
          ),
        );
      },
    );
  }

  Future<dynamic> modalVariant(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.height * 0.6,
            child: AddVarian(list: varian),
          ),
        );
      },
    );
  }

  Future<dynamic> modalStock(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.height * 0.6,
            child: AddStok(
              list: varian,
              txtStok: txtStok,
              txtHarga: txtHarga,
            ),
          ),
        );
      },
    );
  }

  Future<dynamic> modalCost(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.height * 0.6,
            child: AddHargaModal(
              list: varian,
              txtModal: txtModal,
              txtHarga: txtHarga,
            ),
          ),
        );
      },
    );
  }
}

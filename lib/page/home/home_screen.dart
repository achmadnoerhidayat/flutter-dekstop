// ignore_for_file: avoid_print, deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kasir_dekstop/bloc/bill/bill_bloc.dart';
import 'package:kasir_dekstop/bloc/cart/cart_bloc.dart';
import 'package:kasir_dekstop/bloc/customer/customer_bloc.dart';
import 'package:kasir_dekstop/bloc/product/product_bloc.dart';
import 'package:kasir_dekstop/bloc/transaksi/transaksi_bloc.dart';
import 'package:kasir_dekstop/helper/number_format.dart';
import 'package:kasir_dekstop/models/cart_model.dart';
import 'package:kasir_dekstop/models/customer_model.dart';
import 'package:kasir_dekstop/models/transaksi_detail_model.dart';
import 'package:kasir_dekstop/models/transaksi_model.dart';
import 'package:kasir_dekstop/models/varian_reesponse_model.dart';
import 'package:kasir_dekstop/page/home/transaksi_succes.dart';
import 'package:kasir_dekstop/page/home/widget/modal_bill.dart';
import 'package:kasir_dekstop/page/home/widget/modal_tambah_bill.dart';
import 'package:kasir_dekstop/page/home/widget/modal_cart_product.dart';
import 'package:kasir_dekstop/page/home/widget/modal_gula.dart';
import 'package:kasir_dekstop/page/home/widget/modal_product.dart';
import 'package:kasir_dekstop/page/home/widget/modal_setor_gula.dart';
import 'package:kasir_dekstop/page/home/widget/modal_setor_kasbon.dart';
import 'package:kasir_dekstop/page/ofiice/customer/widget/add_customer.dart';
// import 'package:pluto_grid/pluto_grid.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:kasir_dekstop/page/ofiice/shift/shift_screen.dart';
import 'package:kasir_dekstop/util/utils.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = '/home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String type = "search";
  double total = 0.0;
  int subtotal = 0;
  int totalPayment = 0;
  int discount = 0;
  int kasbon = 0;
  List<Map<String, dynamic>>? keterangan;
  CustomerModel? totalCustomer;
  TextEditingController? txtSearch;
  TextEditingController? txtKasir;
  TextEditingController? txtPayment;
  TextEditingController? txtCustomer;
  TextEditingController? txtFaktur;
  TextEditingController? txtBarcode;
  TextEditingController? txtTotGula;
  DateTime? now = DateTime.now();
  FocusNode focusNode = FocusNode();
  FocusNode focusSearch = FocusNode();
  FocusNode tableFocus = FocusNode();
  FocusNode focusPayment = FocusNode();
  int? _selected;
  List<CartModel>? cart;
  List<FocusNode> focusNodes = [];
  List<TextEditingController> controllers = [];
  int focusqty = 0;
  bool statusQty = false;
  bool payment = false;
  void updateStatus(int? newValue) {
    setState(() {
      statusQty = true;
      _selected = newValue;
    });
  }

  @override
  void initState() {
    super.initState();
    context.read<CartBloc>().add(GetCart());
    context.read<TransaksiBloc>().add(GetNoOrder());
    txtKasir = TextEditingController();
    txtSearch = TextEditingController();
    txtPayment = TextEditingController();
    txtCustomer = TextEditingController();
    txtFaktur = TextEditingController();
    txtBarcode = TextEditingController();
    txtTotGula = TextEditingController();
    txtKasir!.text = Utils.userModel!.nama!;
    keterangan = [];
    // Daftar shortcut keyboard
    HotKeyManager.instance.register(
      HotKey(
        key: PhysicalKeyboardKey.keyG,
        modifiers: [HotKeyModifier.control],
        scope: HotKeyScope.inapp,
      ),
      keyDownHandler: (hotKey) {
        if (totalCustomer == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                backgroundColor: Colors.green,
                content: Text(
                  'Silahkan Masukan Customer',
                  style: TextStyle(color: Colors.white),
                )),
          );
        } else {
          modalGula(context);
        }
      },
      keyUpHandler: (hotKey) {
        // print(hotKey.toJson());
      },
    );

    HotKeyManager.instance.register(
      HotKey(
        key: PhysicalKeyboardKey.keyG,
        modifiers: [HotKeyModifier.control, HotKeyModifier.shift],
        scope: HotKeyScope.inapp,
      ),
      keyDownHandler: (hotKey) {
        if (totalCustomer == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                backgroundColor: Colors.green,
                content: Text(
                  'Silahkan Masukan Customer',
                  style: TextStyle(color: Colors.white),
                )),
          );
        } else {
          modalSetorGula(context);
        }
      },
      keyUpHandler: (hotKey) {
        // print(hotKey.toJson());
      },
    );

    HotKeyManager.instance.register(
      HotKey(
        key: PhysicalKeyboardKey.keyK,
        modifiers: [HotKeyModifier.control, HotKeyModifier.shift],
        scope: HotKeyScope.inapp,
      ),
      keyDownHandler: (hotKey) {
        if (totalCustomer == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                backgroundColor: Colors.green,
                content: Text(
                  'Silahkan Masukan Customer',
                  style: TextStyle(color: Colors.white),
                )),
          );
        } else {
          modalSetorKasbon(context);
        }
      },
      keyUpHandler: (hotKey) {
        // print(hotKey.toJson());
      },
    );

    HotKeyManager.instance.register(
      HotKey(
        key: PhysicalKeyboardKey.keyB,
        modifiers: [HotKeyModifier.control],
        scope: HotKeyScope.inapp,
      ),
      keyDownHandler: (hotKey) {
        modalAddBill(context);
      },
      keyUpHandler: (hotKey) {
        // print(hotKey.toJson());
      },
    );

    HotKeyManager.instance.register(
      HotKey(
        key: PhysicalKeyboardKey.keyB,
        modifiers: [HotKeyModifier.control, HotKeyModifier.shift],
        scope: HotKeyScope.inapp,
      ),
      keyDownHandler: (hotKey) {
        modalBill(context);
        context.read<BillBloc>().add(GetBill());
      },
      keyUpHandler: (hotKey) {
        // print(hotKey.toJson());
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    txtSearch!.dispose();
    txtKasir!.dispose();
    txtPayment!.dispose();
    txtCustomer!.dispose();
    txtFaktur!.dispose();
    txtBarcode!.dispose();
    txtTotGula!.dispose();
    focusNode.dispose();
    focusSearch.dispose();
    tableFocus.dispose();
    focusPayment.dispose;
    HotKeyManager.instance.unregisterAll();
  }

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
        'active': "true"
      },
      {
        'name': "Dashboard",
        'route': "/ofice/dashboard",
        'icon': const Icon(
          Icons.dashboard,
          color: Colors.purple,
        ),
        'active': "false"
      }
    ];

    final barcode = BlocConsumer<ProductBloc, ProductState>(
      listener: (context, state) {
        if (state is ProductSuccess) {
          context.read<CartBloc>().add(GetCart());
          _selected = null;
          statusQty = true;
          // focusNodes[0].requestFocus();
        }
      },
      builder: (context, state) {
        return TextField(
          controller: txtBarcode,
          focusNode: focusNode,
          onSubmitted: (value) async {
            context
                .read<ProductBloc>()
                .add(GetProductsByName(nama: value, type: 'barcode'));
          },
          decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              fillColor: Colors.white,
              prefixIcon: const Icon(Icons.qr_code_2_outlined),
              hintText: "Scan Barcode",
              contentPadding:
                  const EdgeInsets.only(left: 35, top: 8, bottom: 15),
              hintStyle: const TextStyle(color: Color(0XFFAA9D9D))),
        );
      },
    );

    final keranjang = BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        if (state is CartSuccess) {
          focusNodes = [];
          controllers = [];
          for (var ca in state.cart!) {
            String id = '0';
            if (ca.varianId != null) {
              id = ca.varianId!;
            }
            controllers.add(
                TextEditingController.fromValue(TextEditingValue(text: id)));
            focusNodes.add(FocusNode());
          }
          if (type == 'barcode') {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!statusQty) {
                txtBarcode!.text = "";
                if (!payment) {
                  focusNode.requestFocus();
                }
              } else {
                txtBarcode!.text = "";
                if (!payment) {
                  focusNodes[focusqty].requestFocus();
                }
              }
            });
          }
          if (type == 'search') {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!statusQty) {
                txtSearch!.text = "";
                if (!payment) {
                  focusSearch.requestFocus();
                }
              } else {
                txtSearch!.text = "";
                if (!payment) {
                  focusNodes[focusqty].requestFocus();
                }
              }
            });
          }
          if (_selected != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              tableFocus.requestFocus();
            });
          }
          discount = 0;
          totalPayment = 0;
          cart = state.cart;
          subtotal = 0;
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.73,
                height: MediaQuery.of(context).size.height * 0.7,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 10, left: 10),
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 90,
                            child: (type == 'search')
                                ? TextField(
                                    controller: txtSearch,
                                    focusNode: focusSearch,
                                    onSubmitted: (value) {
                                      modal(context, value);
                                      txtSearch!.clear();
                                    },
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        fillColor: Colors.white,
                                        prefixIcon: const Icon(Icons.search),
                                        hintText: "Search Barang",
                                        contentPadding: const EdgeInsets.only(
                                            left: 35, top: 8, bottom: 15),
                                        hintStyle: const TextStyle(
                                            color: Color(0XFFAA9D9D))),
                                  )
                                : barcode,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 18,
                            child: SizedBox(
                              height: 60,
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        type = 'search';
                                      });
                                    },
                                    child: Container(
                                      width: 50,
                                      margin: const EdgeInsets.only(bottom: 5),
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          color: (type == 'search')
                                              ? Colors.blue
                                              : Colors.white,
                                          border: Border.all(
                                              color: Colors.black12)),
                                      child: Icon(
                                        Icons.search,
                                        color: (type == 'search')
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        _selected = null;
                                        type = 'barcode';
                                      });
                                    },
                                    child: Container(
                                      width: 50,
                                      padding: const EdgeInsets.all(5),
                                      margin: const EdgeInsets.only(bottom: 5),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.black12,
                                        ),
                                        color: (type == 'barcode')
                                            ? Colors.blue
                                            : Colors.white,
                                      ),
                                      child: Icon(
                                        Icons.barcode_reader,
                                        color: (type == 'barcode')
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      context.read<CartBloc>().add(GetCart());
                                      context
                                          .read<TransaksiBloc>()
                                          .add(GetNoOrder());
                                    },
                                    child: Container(
                                      width: 50,
                                      padding: const EdgeInsets.all(5),
                                      margin: const EdgeInsets.only(
                                          bottom: 5, left: 5),
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: const Icon(
                                        Icons.refresh,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      height: 340,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color(0xFF575555), width: 0.5),
                        color: Colors.white,
                      ),
                      child: FocusScope(
                        child: Focus(
                          focusNode: tableFocus,
                          onKey: (node, event) {
                            if (event is RawKeyDownEvent) {
                              if (event.logicalKey ==
                                  LogicalKeyboardKey.arrowDown) {
                                setState(() {
                                  if (_selected == null) {
                                    _selected = 1;
                                  } else if (_selected! <
                                      state.cart!.length - 1) {
                                    _selected = _selected! + 1;
                                  }
                                });
                                return KeyEventResult.handled;
                              }
                              if (event.logicalKey ==
                                  LogicalKeyboardKey.arrowUp) {
                                setState(() {
                                  if (_selected == null) {
                                    _selected = 0;
                                  } else if (_selected! > 0) {
                                    _selected = _selected! - 1;
                                  }
                                });
                                return KeyEventResult.handled;
                              }
                              if (event.logicalKey ==
                                  LogicalKeyboardKey.enter) {
                                if (_selected != null) {
                                  modalCart(context, state.cart![_selected!],
                                      _selected!);
                                  setState(() {
                                    type = "search";
                                    _selected = null;
                                  });
                                }
                              }
                            }
                            return KeyEventResult.ignored;
                          },
                          child: ListView(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  DataTable(
                                    border: TableBorder.all(
                                        width: 0, color: Colors.white),
                                    showCheckboxColumn: false,
                                    headingRowColor:
                                        MaterialStateColor.resolveWith(
                                            (states) =>
                                                const Color(0xFFFFFFFF)),
                                    columns: [
                                      DataColumn(
                                          label: ConstrainedBox(
                                              constraints: const BoxConstraints(
                                                  minWidth: 100),
                                              child: const Text('Sku'))),
                                    ],
                                    rows: state.cart!.map((e) {
                                      int key = state.cart!.indexOf(e);
                                      return DataRow(
                                          color: MaterialStateProperty.all(
                                              (_selected == key)
                                                  ? const Color(0xFF9EE3E5)
                                                  : Colors.white),
                                          cells: [
                                            DataCell(Text(e.product!.sku)),
                                          ]);
                                    }).toList(),
                                  ),
                                  Expanded(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: DataTable(
                                        border: TableBorder.all(
                                            width: 0, color: Colors.white),
                                        showCheckboxColumn: false,
                                        headingRowColor:
                                            MaterialStateColor.resolveWith(
                                                (states) =>
                                                    const Color(0xFFFFFFFF)),
                                        columns: [
                                          DataColumn(
                                              label: ConstrainedBox(
                                            constraints: const BoxConstraints(
                                                minWidth: 150),
                                            child: const Text('Nama Barang'),
                                          )),
                                          DataColumn(
                                              label: ConstrainedBox(
                                                  constraints:
                                                      const BoxConstraints(
                                                          minWidth: 70),
                                                  child: const Text('Varian'))),
                                          DataColumn(
                                              label: ConstrainedBox(
                                                  constraints:
                                                      const BoxConstraints(
                                                          maxWidth: 40),
                                                  child: const Text('qty'))),
                                          DataColumn(
                                              label: ConstrainedBox(
                                                  constraints:
                                                      const BoxConstraints(
                                                          minWidth: 60),
                                                  child: const Text('Harga'))),
                                          DataColumn(
                                              label: ConstrainedBox(
                                                  constraints:
                                                      const BoxConstraints(
                                                          minWidth: 10),
                                                  child: const Text(
                                                      'Diskon Barang'))),
                                          DataColumn(
                                              label: ConstrainedBox(
                                                  constraints:
                                                      const BoxConstraints(
                                                          minWidth: 40),
                                                  child: const Text('Total'))),
                                          DataColumn(
                                              label: ConstrainedBox(
                                                  constraints:
                                                      const BoxConstraints(
                                                          maxWidth: 80),
                                                  child: const Text('Aksi'))),
                                        ],
                                        rows: state.cart!.map((e) {
                                          int key = state.cart!.indexOf(e);
                                          String promo = "";
                                          int potongan = 0;
                                          double total = 0;
                                          TextEditingController txtQty =
                                              TextEditingController.fromValue(
                                                  TextEditingValue(
                                                      text: e.qty!,
                                                      selection: TextSelection
                                                          .collapsed(
                                                              offset: e.qty!
                                                                  .length)));
                                          if (e.varianId == null) {
                                            total =
                                                int.parse(e.product!.harga) *
                                                    double.parse(e.qty!);
                                          } else {
                                            total = int.parse(
                                                    e.varian!.hargaVarian) *
                                                double.parse(e.qty!);
                                          }
                                          if (e.discountId != null) {
                                            if (e.discon!.type == 'persen') {
                                              var diskon =
                                                  int.parse(e.discon!.jumlah!) *
                                                      total /
                                                      100;
                                              var hasil = diskon;
                                              discount += hasil.toInt();
                                            }
                                          }
                                          if (e.product?.promoProducts !=
                                              null) {
                                            DateTime tanggalMulai =
                                                DateTime.parse(e
                                                    .product!
                                                    .promoProducts!
                                                    .promo!
                                                    .promoMulai!);
                                            DateTime tanggalBerakhir =
                                                DateTime.parse(e
                                                    .product!
                                                    .promoProducts!
                                                    .promo!
                                                    .promoBerakhir!);
                                            if (tanggalMulai.isBefore(now!) ||
                                                tanggalBerakhir
                                                    .isBefore(now!)) {
                                              String min =
                                                  "${e.product!.promoProducts!.minBelanja}";
                                              if (int.parse(min) ==
                                                  int.parse(e.qty!)) {
                                                promo = e.product!
                                                    .promoProducts!.hargaPromo!;
                                                int pot = total.toInt() -
                                                    int.parse(promo);
                                                discount = discount + pot;
                                                potongan = pot;
                                              }
                                            }
                                          }
                                          subtotal = int.parse(e.subtotal);
                                          totalPayment = subtotal - discount;
                                          for (var focus in focusNodes) {
                                            focus.addListener(() {
                                              if (focus.hasFocus) {
                                                txtQty.selection =
                                                    TextSelection(
                                                  baseOffset: 0,
                                                  extentOffset:
                                                      txtQty.text.length,
                                                );
                                              }
                                            });
                                          }
                                          List<VarianResponseModel> varian = [];
                                          if (e.product!.varian!.isNotEmpty) {
                                            varian.add(VarianResponseModel(
                                                id: 0,
                                                idBarang: "",
                                                namaVarian: "Pilih Varian",
                                                hargaVarian: "",
                                                skuVarian: "",
                                                stokVarian: "",
                                                hargaModalVarian: ""));
                                            e.product!.varian
                                                ?.forEach((varians) {
                                              varian.add(varians);
                                            });
                                          }
                                          return DataRow(
                                              onSelectChanged: (value) {
                                                tableFocus.requestFocus();
                                                setState(() {
                                                  _selected = key;
                                                });
                                                // modalCart(context, e);
                                              },
                                              color: MaterialStateProperty.all(
                                                  (_selected == key)
                                                      ? const Color(0xFF9EE3E5)
                                                      : Colors.white),
                                              cells: [
                                                DataCell(Text(
                                                    e.product!.namaBarang)),
                                                DataCell(
                                                  (e.product!.varian!
                                                          .isNotEmpty)
                                                      ? Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.2,
                                                          height: 46,
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10.0),
                                                          child: DropdownButton(
                                                            isExpanded: true,
                                                            underline:
                                                                const SizedBox(),
                                                            hint: const Text(
                                                                "Pilih Kategori Surat"),
                                                            dropdownColor:
                                                                Colors.white,
                                                            items: varian
                                                                .map((val) {
                                                              return DropdownMenuItem(
                                                                value:
                                                                    "${val.id}",
                                                                child: Text(val
                                                                    .namaVarian),
                                                              );
                                                            }).toList(),
                                                            onChanged: (data) {
                                                              var request = CartModel(
                                                                  id: e.id,
                                                                  productId: e
                                                                      .productId,
                                                                  qty: e.qty,
                                                                  varianId:
                                                                      data == '0'
                                                                          ? null
                                                                          : data,
                                                                  discountId: e
                                                                      .discountId,
                                                                  customerId: e
                                                                      .customerId,
                                                                  created: e
                                                                      .created);
                                                              context
                                                                  .read<
                                                                      CartBloc>()
                                                                  .add(UpdateCart(
                                                                      cart:
                                                                          request));
                                                              context
                                                                  .read<
                                                                      CartBloc>()
                                                                  .add(
                                                                      GetCart());
                                                              focusqty = key;
                                                            },
                                                            value:
                                                                controllers[key]
                                                                    .text,
                                                          ),
                                                        )
                                                      : Container(),
                                                ),
                                                DataCell(
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.black),
                                                    ),
                                                    child: TextField(
                                                      focusNode:
                                                          focusNodes[key],
                                                      controller: txtQty,
                                                      onTap: () {
                                                        setState(() {
                                                          focusqty = key;
                                                          _selected = null;
                                                          statusQty = true;
                                                        });
                                                        txtQty.selection =
                                                            TextSelection(
                                                                baseOffset: 0,
                                                                extentOffset:
                                                                    txtQty
                                                                        .value
                                                                        .text
                                                                        .length);
                                                      },
                                                      onChanged: (value) {
                                                        if (value.isEmpty) {
                                                          setState(() {
                                                            txtQty.text = '1';
                                                          });
                                                        }
                                                      },
                                                      onSubmitted: (value) {
                                                        var request = CartModel(
                                                            id: e.id,
                                                            productId:
                                                                e.productId,
                                                            qty: txtQty.text,
                                                            varianId:
                                                                e.varianId,
                                                            discountId:
                                                                e.discountId,
                                                            customerId:
                                                                e.customerId,
                                                            created: e.created);
                                                        context
                                                            .read<CartBloc>()
                                                            .add(UpdateCart(
                                                                cart: request));
                                                        context
                                                            .read<CartBloc>()
                                                            .add(GetCart());
                                                        setState(() {
                                                          focusqty = 0;
                                                          statusQty = false;
                                                        });
                                                      },
                                                      keyboardType:
                                                          TextInputType.number,
                                                      inputFormatters: [
                                                        FilteringTextInputFormatter
                                                            .digitsOnly, // Hanya menerima angka
                                                      ],
                                                      decoration:
                                                          const InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        fillColor: Colors.white,
                                                        contentPadding:
                                                            EdgeInsets.only(
                                                                left: 15,
                                                                top: 5,
                                                                bottom: 5),
                                                        hintText: "Qty",
                                                        hintStyle: TextStyle(
                                                            color: Color(
                                                                0XFFAA9D9D),
                                                            fontSize: 16),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                DataCell(Text((e.varianId !=
                                                        null)
                                                    ? NumberFormats
                                                        .convertToIdr(e.varian!
                                                            .hargaVarian)
                                                    : NumberFormats
                                                        .convertToIdr(
                                                            e.product!.harga))),
                                                DataCell(Text(
                                                    NumberFormats.convertToIdr(
                                                        potongan.toString()))),
                                                DataCell(Text(
                                                    NumberFormats.convertToIdr(
                                                        total
                                                            .toInt()
                                                            .toString()))),
                                                DataCell(IconButton(
                                                    onPressed: () {
                                                      showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              title: const Text(
                                                                  "Apa anda yakin ingin menghapus ?"),
                                                              content: const Text(
                                                                  "data yang dihapus tidak dapat dikembalikan"),
                                                              actions: [
                                                                BlocConsumer<
                                                                    CartBloc,
                                                                    CartState>(
                                                                  listener:
                                                                      (context,
                                                                          states) {
                                                                    if (states
                                                                        is RequestCartSuccess) {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                      context
                                                                          .read<
                                                                              CartBloc>()
                                                                          .add(
                                                                              GetCart());
                                                                    }
                                                                  },
                                                                  builder:
                                                                      (context,
                                                                          states) {
                                                                    return ElevatedButton(
                                                                      onPressed:
                                                                          () {
                                                                        int id =
                                                                            int.parse("${e.id}");
                                                                        context
                                                                            .read<CartBloc>()
                                                                            .add(DeleteCart(id: id));
                                                                      },
                                                                      style: ElevatedButton.styleFrom(
                                                                          shape: RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(10),
                                                                          ),
                                                                          fixedSize: const Size(70, 40),
                                                                          backgroundColor: const Color(0XFF2334A6)),
                                                                      child:
                                                                          Text(
                                                                        "Ya",
                                                                        style: GoogleFonts.playfairDisplay(
                                                                            color:
                                                                                const Color(0XFFFFFFFF),
                                                                            fontSize: 20),
                                                                      ),
                                                                    );
                                                                  },
                                                                ),
                                                                ElevatedButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                          shape:
                                                                              RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(10),
                                                                          ),
                                                                          fixedSize: const Size(
                                                                              100,
                                                                              40),
                                                                          backgroundColor:
                                                                              const Color(0xFFC0C2D1)),
                                                                  child: Text(
                                                                    "Tidak",
                                                                    style: GoogleFonts.playfairDisplay(
                                                                        color: const Color(
                                                                            0xFF252323),
                                                                        fontSize:
                                                                            20),
                                                                  ),
                                                                )
                                                              ],
                                                            );
                                                          });
                                                    },
                                                    icon: const Icon(
                                                      Icons.delete,
                                                      color: Colors.red,
                                                    ))),
                                              ]);
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 7),
                      height: 30,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.all(6),
                            margin: const EdgeInsets.only(right: 10),
                            child: const Text("CTRL+G (Beli Gula)"),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.all(6),
                            margin: const EdgeInsets.only(right: 10),
                            child: const Text("CTRL+SHIFT+G (Setor Gula)"),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.all(6),
                            margin: const EdgeInsets.only(right: 10),
                            child: const Text("CTRL+SHIFT+K (Setor Kasbon)"),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.all(6),
                            margin: const EdgeInsets.only(right: 10),
                            child: const Text("CTRL+K (Kasbon)"),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.all(6),
                            margin: const EdgeInsets.only(right: 10),
                            child: const Text("CTRL+B (Simpan Bill)"),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.all(6),
                            margin: const EdgeInsets.only(right: 10),
                            child: const Text("CTRL+SHIF+B (Lihat Bill)"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10, left: 10),
                color: Colors.white,
                width: MediaQuery.of(context).size.width * 0.26,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 200,
                      child: ListView(
                        children: keterangan!.map((e) {
                          return (e['keterangan'] != '')
                              ? ListTile(
                                  leading: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          if (e['title'] == "Beli Gula") {
                                            txtTotGula!.clear();
                                          }
                                          keterangan!.removeWhere((value) =>
                                              value['title'] == e['title']);
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.close,
                                        color: Colors.red,
                                      )),
                                  title: Text("${e['title']}",
                                      style: GoogleFonts.playfairDisplay(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500)),
                                  subtitle: Text(e['keterangan']),
                                  trailing: Text("${e['harga']}",
                                      style: GoogleFonts.play(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400)),
                                )
                              : ListTile(
                                  leading: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          if (e['title'] == "Beli Gula") {
                                            txtTotGula!.clear();
                                          }
                                          keterangan!.removeWhere((value) =>
                                              value['title'] == e['title']);
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.close,
                                        color: Colors.red,
                                      )),
                                  title: Text("${e['title']}",
                                      style: GoogleFonts.playfairDisplay(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500)),
                                  trailing: Text("${e['harga']}",
                                      style: GoogleFonts.play(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400)),
                                );
                        }).toList(),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text("Sub Total",
                                      style: GoogleFonts.playfairDisplay(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500)),
                                  const SizedBox(width: 5),
                                  Text("( ${state.cart!.length} Barang )",
                                      style: GoogleFonts.play(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400)),
                                ],
                              ),
                              Text(
                                "Rp ${NumberFormats.convertToIdr(subtotal.toString())}",
                                style: GoogleFonts.play(
                                    fontSize: 20, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Tax",
                                  style: GoogleFonts.playfairDisplay(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500)),
                              Text(
                                "Rp 0",
                                style: GoogleFonts.play(
                                    fontSize: 20, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Discount Product",
                                style: GoogleFonts.playfairDisplay(
                                    fontSize: 20, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                (discount > 0)
                                    ? "- Rp ${NumberFormats.convertToIdr(discount.toString())}"
                                    : "Rp 0",
                                style: GoogleFonts.play(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.red),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if (state.cart!.isNotEmpty) {
                          if (txtTotGula!.text.isNotEmpty) {
                            String totGula = txtTotGula!.text;
                            totGula = totGula.replaceAll('Rp ', '');
                            totGula = totGula.replaceAll('.', '');
                            txtPayment!.text =
                                NumberFormats.convertToIdr(totGula);
                          }
                          setState(() {
                            type = "search";
                            _selected = null;
                            payment = true;
                          });
                          // focusNode.unfocus();
                          // tableFocus.unfocus();
                          focusPayment.requestFocus();
                          modalPayment(context);
                        }
                      },
                      child: Container(
                        height: 95,
                        margin: const EdgeInsets.only(
                            left: 10, right: 10, bottom: 10),
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color(0XFF2334A6)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Bayar",
                              style: GoogleFonts.playfairDisplay(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                            Text(
                              "Rp ${NumberFormats.convertToIdr(totalPayment.toString())}",
                              style: GoogleFonts.play(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.73,
              height: MediaQuery.of(context).size.height * 0.7,
              child: ListView(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 10, left: 10),
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 140,
                          child: (type == 'search')
                              ? TextField(
                                  controller: txtSearch,
                                  onSubmitted: (value) {
                                    modal(context, value);
                                    txtSearch!.clear();
                                  },
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      fillColor: Colors.white,
                                      prefixIcon: const Icon(Icons.search),
                                      hintText: "Search Barang",
                                      contentPadding: const EdgeInsets.only(
                                          left: 35, top: 8, bottom: 15),
                                      hintStyle: const TextStyle(
                                          color: Color(0XFFAA9D9D))),
                                )
                              : barcode,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 18,
                          child: SizedBox(
                            height: 60,
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      type = 'search';
                                    });
                                  },
                                  child: Container(
                                    width: 50,
                                    margin: const EdgeInsets.only(bottom: 5),
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        color: (type == 'search')
                                            ? Colors.blue
                                            : Colors.white,
                                        border:
                                            Border.all(color: Colors.black12)),
                                    child: Icon(
                                      Icons.search,
                                      color: (type == 'search')
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      type = 'barcode';
                                    });
                                  },
                                  child: Container(
                                    width: 50,
                                    padding: const EdgeInsets.all(5),
                                    margin: const EdgeInsets.only(bottom: 5),
                                    color: (type == 'barcode')
                                        ? Colors.blue
                                        : Colors.white,
                                    child: Icon(
                                      Icons.barcode_reader,
                                      color: (type == 'barcode')
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 10, top: 5),
                    height: 340,
                    child: Container(),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 7),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.all(6),
                            margin: const EdgeInsets.only(right: 10),
                            child: const Text("CTRL+G (Beli Gula)"),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.all(6),
                            margin: const EdgeInsets.only(right: 10),
                            child: const Text("CTRL+SHIFT+G (Setor Gula)"),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.all(6),
                            margin: const EdgeInsets.only(right: 10),
                            child: const Text("CTRL+SHIFT+K (Setor Kasbon)"),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.all(6),
                            margin: const EdgeInsets.only(right: 10),
                            child: const Text("CTRL+K (Kasbon)"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10, left: 10),
              color: Colors.white,
              width: MediaQuery.of(context).size.width * 0.26,
              child: Column(
                children: [
                  const SizedBox(
                    height: 200,
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text("Sub Total",
                                    style: GoogleFonts.playfairDisplay(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500)),
                                const SizedBox(width: 5),
                                Text("( 0 Barang )",
                                    style: GoogleFonts.play(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400)),
                              ],
                            ),
                            Text(
                              "Rp ${NumberFormats.convertToIdr(subtotal.toString())}",
                              style: GoogleFonts.play(
                                  fontSize: 20, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Tax",
                                style: GoogleFonts.playfairDisplay(
                                    fontSize: 20, fontWeight: FontWeight.w500)),
                            Text(
                              "Rp 0",
                              style: GoogleFonts.play(
                                  fontSize: 20, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Discount Product",
                              style: GoogleFonts.playfairDisplay(
                                  fontSize: 20, fontWeight: FontWeight.w500),
                            ),
                            Text(
                              (discount > 0)
                                  ? "- Rp ${NumberFormats.convertToIdr(discount.toString())}"
                                  : "Rp 0",
                              style: GoogleFonts.play(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.red),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      height: 95,
                      margin: const EdgeInsets.only(
                          left: 10, right: 10, bottom: 10),
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0XFF2334A6)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Bayar",
                            style: GoogleFonts.playfairDisplay(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                          Text(
                            "Rp ${NumberFormats.convertToIdr(totalPayment.toString())}",
                            style: GoogleFonts.play(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        );
      },
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: MediaQuery.of(context).size.width * 1,
        color: const Color(0XFFECE6E6),
        child: Column(
          children: [
            SizedBox(
              height: 160,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Container(
                      margin:
                          const EdgeInsets.only(right: 10, top: 10, left: 5),
                      padding: const EdgeInsets.all(20),
                      color: Colors.green,
                      width: MediaQuery.of(context).size.width * .36,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Kasir",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                width:
                                    MediaQuery.of(context).size.width * 0.218,
                                height: 40,
                                child: TextField(
                                  controller: txtKasir,
                                  keyboardType: TextInputType.text,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    fillColor: Colors.white,
                                    contentPadding: const EdgeInsets.only(
                                        left: 15, top: 5, bottom: 5),
                                    hintStyle: const TextStyle(
                                      color: Color(0XFFAA9D9D),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Faktur",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500),
                              ),
                              BlocBuilder<TransaksiBloc, TransaksiState>(
                                builder: (context, state) {
                                  if (state is NoOrderSucces) {
                                    txtFaktur!.text = state.noOrder;
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      width: MediaQuery.of(context).size.width *
                                          0.218,
                                      height: 40,
                                      child: TextField(
                                        controller: txtFaktur,
                                        readOnly: true,
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          fillColor: Colors.white,
                                          contentPadding: const EdgeInsets.only(
                                              left: 15, top: 5, bottom: 5),
                                          hintStyle: const TextStyle(
                                            color: Color(0XFFAA9D9D),
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                  return Container();
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 10, top: 10),
                      padding: const EdgeInsets.all(20),
                      width: MediaQuery.of(context).size.width * .36,
                      color: Colors.green,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Customer",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                width:
                                    MediaQuery.of(context).size.width * 0.218,
                                height: 40,
                                child: TextField(
                                  controller: txtCustomer,
                                  keyboardType: TextInputType.text,
                                  onSubmitted: (value) {
                                    context
                                        .read<CustomerBloc>()
                                        .add(GetSearchCustomer(nama: value));
                                    txtCustomer!.clear();
                                    totalCustomer = null;
                                    modalCustomer(context);
                                  },
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    fillColor: Colors.white,
                                    contentPadding: const EdgeInsets.only(
                                        left: 15, top: 5, bottom: 5),
                                    hintText: "masukan customer",
                                    hintStyle: const TextStyle(
                                      color: Color(0XFFAA9D9D),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Total Gula",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                width:
                                    MediaQuery.of(context).size.width * 0.218,
                                height: 40,
                                child: TextField(
                                  readOnly: true,
                                  controller: txtTotGula,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    fillColor: Colors.white,
                                    contentPadding: const EdgeInsets.only(
                                        left: 15, top: 5, bottom: 5),
                                    hintStyle: const TextStyle(
                                      color: Color(0XFFAA9D9D),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10, right: 5),
                      color: Colors.green,
                      padding: const EdgeInsets.all(20),
                      width: MediaQuery.of(context).size.width * .257,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Jumlah Total Kasbon",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "Rp ${NumberFormats.convertToIdr(kasbon.toString())}",
                                style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w500),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: keranjang,
            ),
            Container(
              height: 70,
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  for (var i = 0; i < buttonNaf.length; i++)
                    Column(
                      children: [
                        (buttonNaf[i]['active'] == "true")
                            ? ElevatedButton(
                                onPressed: () {
                                  context.go("${buttonNaf[i]['route']}");
                                },
                                child: buttonNaf[i]['icon'],
                                style: ElevatedButton.styleFrom(
                                    // ignore: use_full_hex_values_for_flutter_colors
                                    backgroundColor: const Color(0xfffc59fed)),
                              )
                            : IconButton(
                                onPressed: () {
                                  context.go("${buttonNaf[i]['route']}");
                                },
                                icon: buttonNaf[i]['icon'],
                              ),
                        Text(
                          "${buttonNaf[i]['name']}",
                          style: const TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> modalPayment(BuildContext context) {
    int subTotal = totalPayment;
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
                Container(
                  height: 100,
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                      border: Border.all(color: const Color(0XFFD9D9D9))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          if (Navigator.of(context).canPop()) {
                            Navigator.of(context).pop();
                            setState(() {
                              payment = false;
                            });
                          } else {
                            // Optionally handle this case where there are no pages left to pop
                            print('No pages left to pop');
                          }
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
                      Row(
                        children: [
                          Text(
                            "Rp ${NumberFormats.convertToIdr("$subTotal")}",
                            style: GoogleFonts.play(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                        ],
                      ),
                      BlocConsumer<TransaksiBloc, TransaksiState>(
                        listener: (context, state) {
                          if (state is RequestSuccess) {
                            for (var dat in cart!) {
                              int id = dat.id!;
                              context.read<CartBloc>().add(DeleteCart(id: id));
                            }
                            context
                                .go("${TransaksiSucces.routeName}/${state.id}");
                          }
                        },
                        builder: (context, state) {
                          if (state is TransaksiLoading) {
                            return ElevatedButton(
                              onPressed: () {
                                if (txtPayment!.text == "") {
                                  txtPayment!.text = "0";
                                }
                                int payment = int.parse(
                                    txtPayment!.text.replaceAll('.', ''));
                                int jumlah = payment - subTotal;
                                if (jumlah < 0) {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text(
                                            "Warning",
                                            style: TextStyle(
                                                color: Colors.yellowAccent,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 24),
                                          ),
                                          content: Text(
                                            "Jumlah Pembayran Kurang Rp ${NumberFormats.convertToIdr(jumlah.toString().replaceAll('-', ''))}",
                                            style: const TextStyle(
                                                color: Colors.red,
                                                fontSize: 18),
                                          ),
                                          actions: [
                                            ElevatedButton(
                                              onPressed: () {
                                                if (Navigator.of(context)
                                                    .canPop()) {
                                                  Navigator.of(context).pop();
                                                } else {
                                                  // Optionally handle this case where there are no pages left to pop
                                                  print('No pages left to pop');
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  fixedSize:
                                                      const Size(100, 40),
                                                  backgroundColor:
                                                      const Color(0xFFC0C2D1)),
                                              child: Text(
                                                "Oke",
                                                style:
                                                    GoogleFonts.playfairDisplay(
                                                        color: const Color(
                                                            0xFF252323),
                                                        fontSize: 20),
                                              ),
                                            )
                                          ],
                                        );
                                      });
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  fixedSize: const Size(150, 70),
                                  backgroundColor: const Color(0XFF2334A6)),
                              child: Text(
                                "Change",
                                style: GoogleFonts.playfairDisplay(
                                    color: Colors.white, fontSize: 20),
                              ),
                            );
                          }
                          return ElevatedButton(
                            onPressed: () {
                              if (txtPayment!.text == "") {
                                txtPayment!.text = "0";
                              }
                              int payment = int.parse(
                                  txtPayment!.text.replaceAll('.', ''));
                              int jumlah = payment - subTotal;
                              if (jumlah < 0) {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text(
                                          "Warning",
                                          style: TextStyle(
                                              color: Colors.yellowAccent,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 24),
                                        ),
                                        content: Text(
                                          "Jumlah Pembayran Kurang Rp ${NumberFormats.convertToIdr(jumlah.toString().replaceAll('-', ''))} Mau masukan ke kasbon ?",
                                          style: const TextStyle(
                                              color: Colors.red, fontSize: 18),
                                        ),
                                        actions: [
                                          ElevatedButton(
                                            onPressed: () {
                                              if (Utils.shiftModel == null) {
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: const Text(
                                                          "Warning",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .yellowAccent,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 24),
                                                        ),
                                                        content: const Text(
                                                          "Anda Belum Memulai Shift Silahkan Input Shift Terlebih Dahulu",
                                                          style: TextStyle(
                                                              color: Colors.red,
                                                              fontSize: 18),
                                                        ),
                                                        actions: [
                                                          ElevatedButton(
                                                            onPressed: () {
                                                              if (Navigator.of(
                                                                      context)
                                                                  .canPop()) {
                                                                context.go(
                                                                    ShiftScreen
                                                                        .routeName);
                                                              } else {
                                                                // Optionally handle this case where there are no pages left to pop
                                                                print(
                                                                    'No pages left to pop');
                                                              }
                                                            },
                                                            style: ElevatedButton
                                                                .styleFrom(
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                    ),
                                                                    fixedSize:
                                                                        const Size(
                                                                            100,
                                                                            40),
                                                                    backgroundColor:
                                                                        const Color(
                                                                            0xFFC0C2D1)),
                                                            child: Text(
                                                              "Oke",
                                                              style: GoogleFonts
                                                                  .playfairDisplay(
                                                                      color: const Color(
                                                                          0xFF252323),
                                                                      fontSize:
                                                                          20),
                                                            ),
                                                          )
                                                        ],
                                                      );
                                                    });
                                                return;
                                              }
                                              if (totalCustomer == null) {
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: const Text(
                                                          "Warning",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .yellowAccent,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 24),
                                                        ),
                                                        content: const Text(
                                                          "Harap Masukan Customer Untuk Melakukan Transakisi Kasbon",
                                                          style: TextStyle(
                                                              color: Colors.red,
                                                              fontSize: 18),
                                                        ),
                                                        actions: [
                                                          ElevatedButton(
                                                            onPressed: () {
                                                              if (Navigator.of(
                                                                      context)
                                                                  .canPop()) {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              } else {
                                                                // Optionally handle this case where there are no pages left to pop
                                                                print(
                                                                    'No pages left to pop');
                                                              }
                                                            },
                                                            style: ElevatedButton
                                                                .styleFrom(
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                    ),
                                                                    fixedSize:
                                                                        const Size(
                                                                            100,
                                                                            40),
                                                                    backgroundColor:
                                                                        const Color(
                                                                            0xFFC0C2D1)),
                                                            child: Text(
                                                              "Oke",
                                                              style: GoogleFonts
                                                                  .playfairDisplay(
                                                                      color: const Color(
                                                                          0xFF252323),
                                                                      fontSize:
                                                                          20),
                                                            ),
                                                          )
                                                        ],
                                                      );
                                                    });
                                                return;
                                              }
                                              List<TransaksiDetailModel>
                                                  detail = [];
                                              for (var dat in cart!) {
                                                double total = 0;
                                                int totalDiskon = 0;
                                                if (dat.varianId == null) {
                                                  total = double.parse(
                                                          dat.product!.harga) *
                                                      double.parse(dat.qty!);
                                                } else {
                                                  total = double.parse(dat
                                                          .varian!
                                                          .hargaVarian) *
                                                      double.parse(dat.qty!);
                                                }
                                                if (dat.discountId != null) {
                                                  if (dat.discon!.type ==
                                                      'persen') {
                                                    var diskon = int.parse(dat
                                                            .discon!.jumlah!) *
                                                        total /
                                                        100;
                                                    totalDiskon =
                                                        diskon.toInt();
                                                  }
                                                }
                                                if (dat.product
                                                        ?.promoProducts !=
                                                    null) {
                                                  DateTime tanggalMulai =
                                                      DateTime.parse(dat
                                                          .product!
                                                          .promoProducts!
                                                          .promo!
                                                          .promoMulai!);
                                                  DateTime tanggalBerakhir =
                                                      DateTime.parse(dat
                                                          .product!
                                                          .promoProducts!
                                                          .promo!
                                                          .promoBerakhir!);
                                                  if (tanggalMulai
                                                          .isBefore(now!) ||
                                                      tanggalBerakhir
                                                          .isBefore(now!)) {
                                                    String min =
                                                        "${dat.product!.promoProducts!.minBelanja}";
                                                    if (int.parse(min) ==
                                                        int.parse(dat.qty!)) {
                                                      String promo = dat
                                                          .product!
                                                          .promoProducts!
                                                          .hargaPromo!;
                                                      int pot = total.toInt() -
                                                          int.parse(promo);
                                                      totalDiskon = pot;
                                                    }
                                                  }
                                                }
                                                detail.add(TransaksiDetailModel(
                                                    idTransaksi: null,
                                                    idProduct: dat.productId,
                                                    idVarian: dat.varianId,
                                                    qty: dat.qty,
                                                    hargaModal:
                                                        (dat.varianId == null)
                                                            ? dat.product!
                                                                .hargaModal
                                                            : dat.varian!
                                                                .hargaModalVarian,
                                                    hargaProduct:
                                                        (dat.varianId == null)
                                                            ? dat.product!.harga
                                                            : dat.varian!
                                                                .hargaVarian,
                                                    totalDiskon: (totalDiskon ==
                                                            0)
                                                        ? null
                                                        : totalDiskon
                                                            .toString(),
                                                    created: DateTime.now()
                                                        .toIso8601String(),
                                                    product: dat.product,
                                                    varian: dat.varian));
                                              }
                                              var dataGula = {};
                                              String? setorGula;
                                              String? setorKasbon;
                                              String? note;
                                              for (var ket in keterangan!) {
                                                if (ket['title'] ==
                                                    "Beli Gula") {
                                                  dataGula = {
                                                    "weight": ket['weight'],
                                                    "priceBeli":
                                                        ket['priceBeli'],
                                                    "priceJual":
                                                        ket['priceJual'],
                                                  };
                                                }
                                                if (ket['title'] ==
                                                    "Setor Gula") {
                                                  String gula = ket['harga'];
                                                  gula = gula.replaceAll(
                                                      'Rp ', '');
                                                  gula =
                                                      gula.replaceAll('.', '');
                                                  setorGula = int.parse(gula)
                                                      .toString();
                                                  note = ket['keterangan'];
                                                }
                                                if (ket['title'] ==
                                                    "Setor Kasbon") {
                                                  String setor = ket['harga'];
                                                  setor = setor.replaceAll(
                                                      'Rp ', '');
                                                  setor =
                                                      setor.replaceAll('.', '');
                                                  setorKasbon = setor;
                                                  note = ket['keterangan'];
                                                }
                                              }
                                              if (setorGula != null) {
                                                jumlah = jumlah -
                                                    int.parse(setorGula);
                                              }
                                              if (setorKasbon != null) {
                                                jumlah = jumlah -
                                                    int.parse(setorKasbon);
                                              }
                                              var request = TransaksiModel(
                                                  idUser: Utils.userModel!.id!
                                                      .toString(),
                                                  idCustomer: (totalCustomer != null)
                                                      ? totalCustomer!.id
                                                          .toString()
                                                      : null,
                                                  orderId: null,
                                                  shiftId: Utils.shiftModel!.id
                                                      .toString(),
                                                  totalGula: (dataGula.isNotEmpty)
                                                      ? txtPayment!.text
                                                          .replaceAll('.', '')
                                                      : null,
                                                  weightGula: (dataGula.isNotEmpty)
                                                      ? dataGula['weight']
                                                      : null,
                                                  priceBeliGula: (dataGula.isNotEmpty)
                                                      ? dataGula['priceBeli']
                                                      : null,
                                                  priceJualGula: (dataGula
                                                          .isNotEmpty)
                                                      ? dataGula['priceJual']
                                                      : null,
                                                  totalKasbon: jumlah
                                                      .toString()
                                                      .replaceAll('-', ''),
                                                  setorKasbon: setorKasbon,
                                                  noteKasbon: note,
                                                  setorGula: setorGula,
                                                  noteGula: note,
                                                  totalHarga:
                                                      subTotal.toString(),
                                                  bayar: txtPayment!.text
                                                      .replaceAll('.', ''),
                                                  kembalian: jumlah.toString(),
                                                  paymentType: "Kasbon",
                                                  created: DateTime.now()
                                                      .toIso8601String(),
                                                  detail: detail);
                                              final Map<int, double>
                                                  groupedSums = {};
                                              bool status = false;
                                              for (var item in cart!) {
                                                final idProduct =
                                                    int.parse(item.productId!);
                                                double qty = 0;
                                                if (item.varianId != null) {
                                                  qty = double.parse(item
                                                          .varian!.stokVarian) *
                                                      double.parse(item.qty!);
                                                } else {
                                                  qty = double.parse(item.qty!);
                                                }
                                                if (groupedSums
                                                    .containsKey(idProduct)) {
                                                  groupedSums[idProduct] =
                                                      (groupedSums[idProduct] ??
                                                              0) +
                                                          qty;
                                                } else {
                                                  groupedSums[idProduct] = qty;
                                                }
                                              }
                                              groupedSums
                                                  .forEach((key, value) async {
                                                var dataProduct =
                                                    cart!.firstWhere(
                                                  (element) =>
                                                      element.productId ==
                                                      key.toString(),
                                                );
                                                var stock = int.parse(
                                                        dataProduct
                                                            .product!.stock) -
                                                    value;
                                                if (stock.toInt() < 0) {
                                                  String namaBarang =
                                                      dataProduct
                                                          .product!.namaBarang;
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          title: const Text(
                                                            "Warning",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .yellowAccent,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 24),
                                                          ),
                                                          content: Text(
                                                            "$namaBarang Stock Tidak Cukup",
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .red,
                                                                    fontSize:
                                                                        18),
                                                          ),
                                                          actions: [
                                                            ElevatedButton(
                                                              onPressed: () {
                                                                if (Navigator.of(
                                                                        context)
                                                                    .canPop()) {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                } else {
                                                                  // Optionally handle this case where there are no pages left to pop
                                                                  print(
                                                                      'No pages left to pop');
                                                                }
                                                              },
                                                              style: ElevatedButton
                                                                  .styleFrom(
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(10),
                                                                      ),
                                                                      fixedSize:
                                                                          const Size(
                                                                              100,
                                                                              40),
                                                                      backgroundColor:
                                                                          const Color(
                                                                              0xFFC0C2D1)),
                                                              child: Text(
                                                                "Oke",
                                                                style: GoogleFonts
                                                                    .playfairDisplay(
                                                                        color: const Color(
                                                                            0xFF252323),
                                                                        fontSize:
                                                                            20),
                                                              ),
                                                            )
                                                          ],
                                                        );
                                                      });
                                                  status = true;
                                                  return;
                                                }
                                              });
                                              if (!status) {
                                                context
                                                    .read<TransaksiBloc>()
                                                    .add(CreateTransaksi(
                                                        trans: request));
                                              }
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
                                              "Ya",
                                              style:
                                                  GoogleFonts.playfairDisplay(
                                                      color: const Color(
                                                          0xFF252323),
                                                      fontSize: 20),
                                            ),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              if (Navigator.of(context)
                                                  .canPop()) {
                                                Navigator.of(context).pop();
                                              } else {
                                                // Optionally handle this case where there are no pages left to pop
                                                print('No pages left to pop');
                                              }
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
                                              style:
                                                  GoogleFonts.playfairDisplay(
                                                      color: const Color(
                                                          0xFF252323),
                                                      fontSize: 20),
                                            ),
                                          ),
                                        ],
                                      );
                                    });
                                return;
                              } else {
                                if (Utils.shiftModel == null) {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text(
                                            "Warning",
                                            style: TextStyle(
                                                color: Colors.yellowAccent,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 24),
                                          ),
                                          content: const Text(
                                            "Anda Belum Memulai Shift Silahkan Input Shift Terlebih Dahulu",
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 18),
                                          ),
                                          actions: [
                                            ElevatedButton(
                                              onPressed: () {
                                                if (Navigator.of(context)
                                                    .canPop()) {
                                                  context.go(
                                                      ShiftScreen.routeName);
                                                } else {
                                                  // Optionally handle this case where there are no pages left to pop
                                                  print('No pages left to pop');
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  fixedSize:
                                                      const Size(100, 40),
                                                  backgroundColor:
                                                      const Color(0xFFC0C2D1)),
                                              child: Text(
                                                "Oke",
                                                style:
                                                    GoogleFonts.playfairDisplay(
                                                        color: const Color(
                                                            0xFF252323),
                                                        fontSize: 20),
                                              ),
                                            )
                                          ],
                                        );
                                      });
                                  return;
                                }
                                List<TransaksiDetailModel> detail = [];
                                for (var dat in cart!) {
                                  double total = 0;
                                  int totalDiskon = 0;
                                  if (dat.varianId == null) {
                                    total = double.parse(dat.product!.harga) *
                                        double.parse(dat.qty!);
                                  } else {
                                    total =
                                        double.parse(dat.varian!.hargaVarian) *
                                            double.parse(dat.qty!);
                                  }
                                  if (dat.discountId != null) {
                                    if (dat.discon!.type == 'persen') {
                                      var diskon =
                                          int.parse(dat.discon!.jumlah!) *
                                              total /
                                              100;
                                      totalDiskon = diskon.toInt();
                                    }
                                  }
                                  if (dat.product?.promoProducts != null) {
                                    DateTime tanggalMulai = DateTime.parse(dat
                                        .product!
                                        .promoProducts!
                                        .promo!
                                        .promoMulai!);
                                    DateTime tanggalBerakhir = DateTime.parse(
                                        dat.product!.promoProducts!.promo!
                                            .promoBerakhir!);
                                    if (tanggalMulai.isBefore(now!) ||
                                        tanggalBerakhir.isBefore(now!)) {
                                      String min =
                                          "${dat.product!.promoProducts!.minBelanja}";
                                      if (int.parse(min) ==
                                          int.parse(dat.qty!)) {
                                        String promo = dat.product!
                                            .promoProducts!.hargaPromo!;
                                        int pot =
                                            total.toInt() - int.parse(promo);
                                        totalDiskon = pot;
                                      }
                                    }
                                  }
                                  detail.add(TransaksiDetailModel(
                                      idTransaksi: null,
                                      idProduct: dat.productId,
                                      idVarian: dat.varianId,
                                      qty: dat.qty,
                                      hargaModal: (dat.varianId == null)
                                          ? dat.product!.hargaModal
                                          : dat.varian!.hargaModalVarian,
                                      hargaProduct: (dat.varianId == null)
                                          ? dat.product!.harga
                                          : dat.varian!.hargaVarian,
                                      totalDiskon: (totalDiskon == 0)
                                          ? null
                                          : totalDiskon.toString(),
                                      created: DateTime.now().toIso8601String(),
                                      product: dat.product,
                                      varian: dat.varian));
                                }
                                var dataGula = {};
                                String? setorGula;
                                String? setorKasbon;
                                String? note;
                                for (var ket in keterangan!) {
                                  if (ket['title'] == "Beli Gula") {
                                    dataGula = {
                                      "weight": ket['weight'],
                                      "priceBeli": ket['priceBeli'],
                                      "priceJual": ket['priceJual'],
                                    };
                                  }
                                  if (ket['title'] == "Setor Gula") {
                                    String gula = ket['harga'];
                                    gula = gula.replaceAll('Rp ', '');
                                    gula = gula.replaceAll('.', '');
                                    setorGula = int.parse(gula).toString();
                                    note = ket['keterangan'];
                                  }
                                  if (ket['title'] == "Setor Kasbon") {
                                    String setor = ket['harga'];
                                    setor = setor.replaceAll('Rp ', '');
                                    setor = setor.replaceAll('.', '');
                                    setorKasbon = setor;
                                    note = ket['keterangan'];
                                  }
                                }
                                if (setorGula != null) {
                                  jumlah = jumlah - int.parse(setorGula);
                                }
                                if (setorKasbon != null) {
                                  jumlah = jumlah - int.parse(setorKasbon);
                                }
                                var request = TransaksiModel(
                                    idUser: Utils.userModel!.id!.toString(),
                                    idCustomer: (totalCustomer != null)
                                        ? totalCustomer!.id.toString()
                                        : null,
                                    orderId: null,
                                    shiftId: Utils.shiftModel!.id.toString(),
                                    totalGula: (dataGula.isNotEmpty)
                                        ? txtPayment!.text.replaceAll('.', '')
                                        : null,
                                    weightGula: (dataGula.isNotEmpty)
                                        ? dataGula['weight']
                                        : null,
                                    priceBeliGula: (dataGula.isNotEmpty)
                                        ? dataGula['priceBeli']
                                        : null,
                                    priceJualGula: (dataGula.isNotEmpty)
                                        ? dataGula['priceJual']
                                        : null,
                                    setorKasbon: setorKasbon,
                                    noteKasbon: note,
                                    setorGula: setorGula,
                                    noteGula: note,
                                    totalHarga: subTotal.toString(),
                                    bayar: txtPayment!.text.replaceAll('.', ''),
                                    kembalian: jumlah.toString(),
                                    paymentType:
                                        (dataGula.isNotEmpty) ? "Gula" : "Cash",
                                    created: DateTime.now().toIso8601String(),
                                    detail: detail);
                                final Map<int, double> groupedSums = {};
                                bool status = false;
                                for (var item in cart!) {
                                  final idProduct = int.parse(item.productId!);
                                  double qty = 0;
                                  if (item.varianId != null) {
                                    qty =
                                        double.parse(item.varian!.stokVarian) *
                                            double.parse(item.qty!);
                                  } else {
                                    qty = double.parse(item.qty!);
                                  }
                                  if (groupedSums.containsKey(idProduct)) {
                                    groupedSums[idProduct] =
                                        (groupedSums[idProduct] ?? 0) + qty;
                                  } else {
                                    groupedSums[idProduct] = qty;
                                  }
                                }
                                groupedSums.forEach((key, value) async {
                                  var dataProduct = cart!.firstWhere(
                                    (element) =>
                                        element.productId == key.toString(),
                                  );
                                  var stock =
                                      double.parse(dataProduct.product!.stock) -
                                          value;
                                  if (stock.toInt() < 0) {
                                    String namaBarang =
                                        dataProduct.product!.namaBarang;
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text(
                                              "Warning",
                                              style: TextStyle(
                                                  color: Colors.yellowAccent,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 24),
                                            ),
                                            content: Text(
                                              "$namaBarang Stock Tidak Cukup",
                                              style: const TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 18),
                                            ),
                                            actions: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  if (Navigator.of(context)
                                                      .canPop()) {
                                                    Navigator.of(context).pop();
                                                  } else {
                                                    // Optionally handle this case where there are no pages left to pop
                                                    print(
                                                        'No pages left to pop');
                                                  }
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    fixedSize:
                                                        const Size(100, 40),
                                                    backgroundColor:
                                                        const Color(
                                                            0xFFC0C2D1)),
                                                child: Text(
                                                  "Oke",
                                                  style: GoogleFonts
                                                      .playfairDisplay(
                                                          color: const Color(
                                                              0xFF252323),
                                                          fontSize: 20),
                                                ),
                                              )
                                            ],
                                          );
                                        });
                                    status = true;
                                    return;
                                  }
                                });
                                if (!status) {
                                  context
                                      .read<TransaksiBloc>()
                                      .add(CreateTransaksi(trans: request));
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                fixedSize: const Size(150, 70),
                                backgroundColor: const Color(0XFF2334A6)),
                            child: Text(
                              "Change",
                              style: GoogleFonts.playfairDisplay(
                                  color: Colors.white, fontSize: 20),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "Cash",
                              style: GoogleFonts.playfairDisplay(fontSize: 24),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  child: GridView(
                                    shrinkWrap: true,
                                    physics: const ScrollPhysics(),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount:
                                          3, // number of items in each row
                                      mainAxisExtent: 60,
                                      mainAxisSpacing:
                                          20, // spacing between columns
                                    ),
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            txtPayment!.text = "25.000";
                                          },
                                          style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              fixedSize: const Size(150, 70),
                                              backgroundColor:
                                                  const Color(0XFFFFFFFF)),
                                          child: Text(
                                            "Rp 25.000",
                                            style: GoogleFonts.play(
                                                color: const Color(0XFF2334A6),
                                                fontSize: 18),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            txtPayment!.text = "50.000";
                                          },
                                          style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              fixedSize: const Size(150, 70),
                                              backgroundColor:
                                                  const Color(0XFFFFFFFF)),
                                          child: Text(
                                            "Rp 50.000",
                                            style: GoogleFonts.play(
                                                color: const Color(0XFF2334A6),
                                                fontSize: 18),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            txtPayment!.text = "100.000";
                                          },
                                          style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              fixedSize: const Size(150, 70),
                                              backgroundColor:
                                                  const Color(0XFFFFFFFF)),
                                          child: Text(
                                            "Rp 100.000",
                                            style: GoogleFonts.play(
                                                color: const Color(0XFF2334A6),
                                                fontSize: 18),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            txtPayment!.text = "125.000";
                                          },
                                          style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              fixedSize: const Size(150, 70),
                                              backgroundColor:
                                                  const Color(0XFFFFFFFF)),
                                          child: Text(
                                            "Rp 125.000",
                                            style: GoogleFonts.play(
                                                color: const Color(0XFF2334A6),
                                                fontSize: 18),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            txtPayment!.text = "150.000";
                                          },
                                          style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              fixedSize: const Size(150, 70),
                                              backgroundColor:
                                                  const Color(0XFFFFFFFF)),
                                          child: Text(
                                            "Rp 150.000",
                                            style: GoogleFonts.play(
                                                color: const Color(0XFF2334A6),
                                                fontSize: 18),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            txtPayment!.text = "200.000";
                                          },
                                          style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              fixedSize: const Size(150, 70),
                                              backgroundColor:
                                                  const Color(0XFFFFFFFF)),
                                          child: Text(
                                            "Rp 200.000",
                                            style: GoogleFonts.play(
                                                color: const Color(0XFF2334A6),
                                                fontSize: 18),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  color: Colors.white,
                                  child: BlocConsumer<TransaksiBloc,
                                      TransaksiState>(
                                    listener: (context, state) {
                                      if (state is RequestSuccess) {
                                        for (var dat in cart!) {
                                          int id = dat.id!;
                                          context
                                              .read<CartBloc>()
                                              .add(DeleteCart(id: id));
                                        }
                                        context.go(
                                            "${TransaksiSucces.routeName}/${state.id}");
                                      }
                                    },
                                    builder: (context, state) {
                                      return TextField(
                                        focusNode: focusPayment,
                                        controller: txtPayment,
                                        onChanged: (val) {
                                          setState(() {
                                            if (val.isNotEmpty) {
                                              val = val.replaceAll('.', '');
                                            } else {
                                              val = '';
                                            }
                                          });
                                          txtPayment!.value = TextEditingValue(
                                            text:
                                                NumberFormats.convertToIdr(val),
                                            selection:
                                                TextSelection.fromPosition(
                                              TextPosition(
                                                  offset: NumberFormats
                                                          .convertToIdr(val)
                                                      .length),
                                            ),
                                          );
                                        },
                                        onSubmitted: (value) {
                                          if (txtPayment!.text == "") {
                                            txtPayment!.text = "0";
                                          }
                                          int payment = int.parse(txtPayment!
                                              .text
                                              .replaceAll('.', ''));
                                          int jumlah = payment - subTotal;
                                          if (jumlah < 0) {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                      "Warning",
                                                      style: TextStyle(
                                                          color: Colors
                                                              .yellowAccent,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 24),
                                                    ),
                                                    content: Text(
                                                      "Jumlah Pembayran Kurang Rp ${NumberFormats.convertToIdr(jumlah.toString().replaceAll('-', ''))} Mau masukan ke kasbon ?",
                                                      style: const TextStyle(
                                                          color: Colors.red,
                                                          fontSize: 18),
                                                    ),
                                                    actions: [
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          if (Utils
                                                                  .shiftModel ==
                                                              null) {
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return AlertDialog(
                                                                    title:
                                                                        const Text(
                                                                      "Warning",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .yellowAccent,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              24),
                                                                    ),
                                                                    content:
                                                                        const Text(
                                                                      "Anda Belum Memulai Shift Silahkan Input Shift Terlebih Dahulu",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .red,
                                                                          fontSize:
                                                                              18),
                                                                    ),
                                                                    actions: [
                                                                      ElevatedButton(
                                                                        onPressed:
                                                                            () {
                                                                          if (Navigator.of(context)
                                                                              .canPop()) {
                                                                            context.go(ShiftScreen.routeName);
                                                                          } else {
                                                                            // Optionally handle this case where there are no pages left to pop
                                                                            print('No pages left to pop');
                                                                          }
                                                                        },
                                                                        style: ElevatedButton.styleFrom(
                                                                            shape: RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(10),
                                                                            ),
                                                                            fixedSize: const Size(100, 40),
                                                                            backgroundColor: const Color(0xFFC0C2D1)),
                                                                        child:
                                                                            Text(
                                                                          "Oke",
                                                                          style: GoogleFonts.playfairDisplay(
                                                                              color: const Color(0xFF252323),
                                                                              fontSize: 20),
                                                                        ),
                                                                      )
                                                                    ],
                                                                  );
                                                                });
                                                            return;
                                                          }
                                                          if (totalCustomer ==
                                                              null) {
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return AlertDialog(
                                                                    title:
                                                                        const Text(
                                                                      "Warning",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .yellowAccent,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              24),
                                                                    ),
                                                                    content:
                                                                        const Text(
                                                                      "Harap Masukan Customer Untuk Melakukan Transakisi Kasbon",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .red,
                                                                          fontSize:
                                                                              18),
                                                                    ),
                                                                    actions: [
                                                                      ElevatedButton(
                                                                        onPressed:
                                                                            () {
                                                                          if (Navigator.of(context)
                                                                              .canPop()) {
                                                                            Navigator.of(context).pop();
                                                                          } else {
                                                                            // Optionally handle this case where there are no pages left to pop
                                                                            print('No pages left to pop');
                                                                          }
                                                                        },
                                                                        style: ElevatedButton.styleFrom(
                                                                            shape: RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(10),
                                                                            ),
                                                                            fixedSize: const Size(100, 40),
                                                                            backgroundColor: const Color(0xFFC0C2D1)),
                                                                        child:
                                                                            Text(
                                                                          "Oke",
                                                                          style: GoogleFonts.playfairDisplay(
                                                                              color: const Color(0xFF252323),
                                                                              fontSize: 20),
                                                                        ),
                                                                      )
                                                                    ],
                                                                  );
                                                                });
                                                            return;
                                                          }
                                                          List<TransaksiDetailModel>
                                                              detail = [];
                                                          for (var dat
                                                              in cart!) {
                                                            double total = 0;
                                                            int totalDiskon = 0;
                                                            if (dat.varianId ==
                                                                null) {
                                                              total = double.parse(dat
                                                                      .product!
                                                                      .harga) *
                                                                  double.parse(
                                                                      dat.qty!);
                                                            } else {
                                                              total = double.parse(dat
                                                                      .varian!
                                                                      .hargaVarian) *
                                                                  double.parse(
                                                                      dat.qty!);
                                                            }
                                                            if (dat.discountId !=
                                                                null) {
                                                              if (dat.discon!
                                                                      .type ==
                                                                  'persen') {
                                                                var diskon =
                                                                    int.parse(dat
                                                                            .discon!
                                                                            .jumlah!) *
                                                                        total /
                                                                        100;
                                                                totalDiskon =
                                                                    diskon
                                                                        .toInt();
                                                              }
                                                            }
                                                            if (dat.product
                                                                    ?.promoProducts !=
                                                                null) {
                                                              DateTime
                                                                  tanggalMulai =
                                                                  DateTime.parse(dat
                                                                      .product!
                                                                      .promoProducts!
                                                                      .promo!
                                                                      .promoMulai!);
                                                              DateTime
                                                                  tanggalBerakhir =
                                                                  DateTime.parse(dat
                                                                      .product!
                                                                      .promoProducts!
                                                                      .promo!
                                                                      .promoBerakhir!);
                                                              if (tanggalMulai
                                                                      .isBefore(
                                                                          now!) ||
                                                                  tanggalBerakhir
                                                                      .isBefore(
                                                                          now!)) {
                                                                String min =
                                                                    "${dat.product!.promoProducts!.minBelanja}";
                                                                if (int.parse(
                                                                        min) ==
                                                                    int.parse(dat
                                                                        .qty!)) {
                                                                  String promo = dat
                                                                      .product!
                                                                      .promoProducts!
                                                                      .hargaPromo!;
                                                                  int pot = total
                                                                          .toInt() -
                                                                      int.parse(
                                                                          promo);
                                                                  totalDiskon =
                                                                      pot;
                                                                }
                                                              }
                                                            }
                                                            detail.add(TransaksiDetailModel(
                                                                idTransaksi:
                                                                    null,
                                                                idProduct: dat
                                                                    .productId,
                                                                idVarian: dat
                                                                    .varianId,
                                                                qty: dat.qty,
                                                                hargaModal: (dat.varianId == null)
                                                                    ? dat.product!
                                                                        .hargaModal
                                                                    : dat.varian!
                                                                        .hargaModalVarian,
                                                                hargaProduct: (dat
                                                                            .varianId ==
                                                                        null)
                                                                    ? dat
                                                                        .product!
                                                                        .harga
                                                                    : dat
                                                                        .varian!
                                                                        .hargaVarian,
                                                                totalDiskon: (totalDiskon == 0)
                                                                    ? null
                                                                    : totalDiskon
                                                                        .toString(),
                                                                created:
                                                                    DateTime.now()
                                                                        .toIso8601String(),
                                                                product:
                                                                    dat.product,
                                                                varian: dat.varian));
                                                          }
                                                          var dataGula = {};
                                                          String? setorGula;
                                                          String? setorKasbon;
                                                          String? note;
                                                          for (var ket
                                                              in keterangan!) {
                                                            if (ket['title'] ==
                                                                "Beli Gula") {
                                                              dataGula = {
                                                                "weight": ket[
                                                                    'weight'],
                                                                "priceBeli": ket[
                                                                    'priceBeli'],
                                                                "priceJual": ket[
                                                                    'priceJual'],
                                                              };
                                                            }
                                                            if (ket['title'] ==
                                                                "Setor Gula") {
                                                              String gula =
                                                                  ket['harga'];
                                                              gula = gula
                                                                  .replaceAll(
                                                                      'Rp ',
                                                                      '');
                                                              gula = gula
                                                                  .replaceAll(
                                                                      '.', '');
                                                              setorGula = int
                                                                      .parse(
                                                                          gula)
                                                                  .toString();
                                                              note = ket[
                                                                  'keterangan'];
                                                            }
                                                            if (ket['title'] ==
                                                                "Setor Kasbon") {
                                                              String setor =
                                                                  ket['harga'];
                                                              setor = setor
                                                                  .replaceAll(
                                                                      'Rp ',
                                                                      '');
                                                              setor = setor
                                                                  .replaceAll(
                                                                      '.', '');
                                                              setorKasbon =
                                                                  setor;
                                                              note = ket[
                                                                  'keterangan'];
                                                            }
                                                          }
                                                          if (setorGula !=
                                                              null) {
                                                            jumlah = jumlah -
                                                                int.parse(
                                                                    setorGula);
                                                          }
                                                          if (setorKasbon !=
                                                              null) {
                                                            jumlah = jumlah -
                                                                int.parse(
                                                                    setorKasbon);
                                                          }
                                                          var request = TransaksiModel(
                                                              idUser: Utils
                                                                  .userModel!
                                                                  .id!
                                                                  .toString(),
                                                              idCustomer: (totalCustomer != null)
                                                                  ? totalCustomer!.id
                                                                      .toString()
                                                                  : null,
                                                              orderId: null,
                                                              shiftId: Utils
                                                                  .shiftModel!
                                                                  .id
                                                                  .toString(),
                                                              totalGula: (dataGula.isNotEmpty)
                                                                  ? txtPayment!.text
                                                                      .replaceAll(
                                                                          '.', '')
                                                                  : null,
                                                              weightGula: (dataGula.isNotEmpty)
                                                                  ? dataGula[
                                                                      'weight']
                                                                  : null,
                                                              priceBeliGula:
                                                                  (dataGula.isNotEmpty)
                                                                      ? dataGula['priceBeli']
                                                                      : null,
                                                              priceJualGula: (dataGula.isNotEmpty) ? dataGula['priceJual'] : null,
                                                              totalKasbon: jumlah.toString().replaceAll('-', ''),
                                                              setorKasbon: setorKasbon,
                                                              noteKasbon: note,
                                                              setorGula: setorGula,
                                                              noteGula: note,
                                                              totalHarga: subTotal.toString(),
                                                              bayar: txtPayment!.text.replaceAll('.', ''),
                                                              kembalian: jumlah.toString(),
                                                              paymentType: "Kasbon",
                                                              created: DateTime.now().toIso8601String(),
                                                              detail: detail);
                                                          final Map<int, double>
                                                              groupedSums = {};
                                                          bool status = false;
                                                          for (var item
                                                              in cart!) {
                                                            final idProduct =
                                                                int.parse(item
                                                                    .productId!);
                                                            double qty = 0;
                                                            if (item.varianId !=
                                                                null) {
                                                              qty = double.parse(item
                                                                      .varian!
                                                                      .stokVarian) *
                                                                  double.parse(
                                                                      item.qty!);
                                                            } else {
                                                              qty = double
                                                                  .parse(item
                                                                      .qty!);
                                                            }
                                                            if (groupedSums
                                                                .containsKey(
                                                                    idProduct)) {
                                                              groupedSums[
                                                                      idProduct] =
                                                                  (groupedSums[
                                                                              idProduct] ??
                                                                          0) +
                                                                      qty;
                                                            } else {
                                                              groupedSums[
                                                                      idProduct] =
                                                                  qty;
                                                            }
                                                          }
                                                          groupedSums.forEach(
                                                              (key,
                                                                  value) async {
                                                            var dataProduct =
                                                                cart!
                                                                    .firstWhere(
                                                              (element) =>
                                                                  element
                                                                      .productId ==
                                                                  key.toString(),
                                                            );
                                                            var stock = int.parse(
                                                                    dataProduct
                                                                        .product!
                                                                        .stock) -
                                                                value;
                                                            if (stock.toInt() <
                                                                0) {
                                                              String
                                                                  namaBarang =
                                                                  dataProduct
                                                                      .product!
                                                                      .namaBarang;
                                                              showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return AlertDialog(
                                                                      title:
                                                                          const Text(
                                                                        "Warning",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.yellowAccent,
                                                                            fontWeight: FontWeight.bold,
                                                                            fontSize: 24),
                                                                      ),
                                                                      content:
                                                                          Text(
                                                                        "$namaBarang Stock Tidak Cukup",
                                                                        style: const TextStyle(
                                                                            color:
                                                                                Colors.red,
                                                                            fontSize: 18),
                                                                      ),
                                                                      actions: [
                                                                        ElevatedButton(
                                                                          onPressed:
                                                                              () {
                                                                            if (Navigator.of(context).canPop()) {
                                                                              Navigator.of(context).pop();
                                                                            } else {
                                                                              // Optionally handle this case where there are no pages left to pop
                                                                              print('No pages left to pop');
                                                                            }
                                                                          },
                                                                          style: ElevatedButton.styleFrom(
                                                                              shape: RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.circular(10),
                                                                              ),
                                                                              fixedSize: const Size(100, 40),
                                                                              backgroundColor: const Color(0xFFC0C2D1)),
                                                                          child:
                                                                              Text(
                                                                            "Oke",
                                                                            style:
                                                                                GoogleFonts.playfairDisplay(color: const Color(0xFF252323), fontSize: 20),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    );
                                                                  });
                                                              status = true;
                                                              return;
                                                            }
                                                          });
                                                          if (!status) {
                                                            context
                                                                .read<
                                                                    TransaksiBloc>()
                                                                .add(CreateTransaksi(
                                                                    trans:
                                                                        request));
                                                          }
                                                        },
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                ),
                                                                fixedSize:
                                                                    const Size(
                                                                        100,
                                                                        40),
                                                                backgroundColor:
                                                                    const Color(
                                                                        0xFFC0C2D1)),
                                                        child: Text(
                                                          "Ya",
                                                          style: GoogleFonts
                                                              .playfairDisplay(
                                                                  color: const Color(
                                                                      0xFF252323),
                                                                  fontSize: 20),
                                                        ),
                                                      ),
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          if (Navigator.of(
                                                                  context)
                                                              .canPop()) {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          } else {
                                                            // Optionally handle this case where there are no pages left to pop
                                                            print(
                                                                'No pages left to pop');
                                                          }
                                                        },
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                ),
                                                                fixedSize:
                                                                    const Size(
                                                                        100,
                                                                        40),
                                                                backgroundColor:
                                                                    const Color(
                                                                        0xFFC0C2D1)),
                                                        child: Text(
                                                          "Tidak",
                                                          style: GoogleFonts
                                                              .playfairDisplay(
                                                                  color: const Color(
                                                                      0xFF252323),
                                                                  fontSize: 20),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                });
                                            return;
                                          } else {
                                            if (Utils.shiftModel == null) {
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: const Text(
                                                        "Warning",
                                                        style: TextStyle(
                                                            color: Colors
                                                                .yellowAccent,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 24),
                                                      ),
                                                      content: const Text(
                                                        "Anda Belum Memulai Shift Silahkan Input Shift Terlebih Dahulu",
                                                        style: TextStyle(
                                                            color: Colors.red,
                                                            fontSize: 18),
                                                      ),
                                                      actions: [
                                                        ElevatedButton(
                                                          onPressed: () {
                                                            if (Navigator.of(
                                                                    context)
                                                                .canPop()) {
                                                              context.go(
                                                                  ShiftScreen
                                                                      .routeName);
                                                            } else {
                                                              // Optionally handle this case where there are no pages left to pop
                                                              print(
                                                                  'No pages left to pop');
                                                            }
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                  ),
                                                                  fixedSize:
                                                                      const Size(
                                                                          100,
                                                                          40),
                                                                  backgroundColor:
                                                                      const Color(
                                                                          0xFFC0C2D1)),
                                                          child: Text(
                                                            "Oke",
                                                            style: GoogleFonts
                                                                .playfairDisplay(
                                                                    color: const Color(
                                                                        0xFF252323),
                                                                    fontSize:
                                                                        20),
                                                          ),
                                                        )
                                                      ],
                                                    );
                                                  });
                                              return;
                                            }
                                            List<TransaksiDetailModel> detail =
                                                [];
                                            for (var dat in cart!) {
                                              double total = 0;
                                              int totalDiskon = 0;
                                              if (dat.varianId == null) {
                                                total = double.parse(
                                                        dat.product!.harga) *
                                                    double.parse(dat.qty!);
                                              } else {
                                                total = double.parse(dat
                                                        .varian!.hargaVarian) *
                                                    double.parse(dat.qty!);
                                              }
                                              if (dat.discountId != null) {
                                                if (dat.discon!.type ==
                                                    'persen') {
                                                  var diskon = int.parse(
                                                          dat.discon!.jumlah!) *
                                                      total /
                                                      100;
                                                  totalDiskon = diskon.toInt();
                                                }
                                              }
                                              if (dat.product?.promoProducts !=
                                                  null) {
                                                DateTime tanggalMulai =
                                                    DateTime.parse(dat
                                                        .product!
                                                        .promoProducts!
                                                        .promo!
                                                        .promoMulai!);
                                                DateTime tanggalBerakhir =
                                                    DateTime.parse(dat
                                                        .product!
                                                        .promoProducts!
                                                        .promo!
                                                        .promoBerakhir!);
                                                if (tanggalMulai
                                                        .isBefore(now!) ||
                                                    tanggalBerakhir
                                                        .isBefore(now!)) {
                                                  String min =
                                                      "${dat.product!.promoProducts!.minBelanja}";
                                                  if (int.parse(min) ==
                                                      int.parse(dat.qty!)) {
                                                    String promo = dat
                                                        .product!
                                                        .promoProducts!
                                                        .hargaPromo!;
                                                    int pot = total.toInt() -
                                                        int.parse(promo);
                                                    totalDiskon = pot;
                                                  }
                                                }
                                              }
                                              detail.add(TransaksiDetailModel(
                                                  idTransaksi: null,
                                                  idProduct: dat.productId,
                                                  idVarian: dat.varianId,
                                                  qty: dat.qty,
                                                  hargaModal: (dat.varianId ==
                                                          null)
                                                      ? dat.product!.hargaModal
                                                      : dat.varian!
                                                          .hargaModalVarian,
                                                  hargaProduct: (dat.varianId ==
                                                          null)
                                                      ? dat.product!.harga
                                                      : dat.varian!.hargaVarian,
                                                  totalDiskon: (totalDiskon ==
                                                          0)
                                                      ? null
                                                      : totalDiskon.toString(),
                                                  created: DateTime.now()
                                                      .toIso8601String(),
                                                  product: dat.product,
                                                  varian: dat.varian));
                                            }
                                            var dataGula = {};
                                            String? setorGula;
                                            String? setorKasbon;
                                            String? note;
                                            for (var ket in keterangan!) {
                                              if (ket['title'] == "Beli Gula") {
                                                dataGula = {
                                                  "weight": ket['weight'],
                                                  "priceBeli": ket['priceBeli'],
                                                  "priceJual": ket['priceJual'],
                                                };
                                              }
                                              if (ket['title'] ==
                                                  "Setor Gula") {
                                                String gula = ket['harga'];
                                                gula =
                                                    gula.replaceAll('Rp ', '');
                                                gula = gula.replaceAll('.', '');
                                                setorGula =
                                                    int.parse(gula).toString();
                                                note = ket['keterangan'];
                                              }
                                              if (ket['title'] ==
                                                  "Setor Kasbon") {
                                                String setor = ket['harga'];
                                                setor =
                                                    setor.replaceAll('Rp ', '');
                                                setor =
                                                    setor.replaceAll('.', '');
                                                setorKasbon = setor;
                                                note = ket['keterangan'];
                                              }
                                            }
                                            if (setorGula != null) {
                                              jumlah =
                                                  jumlah - int.parse(setorGula);
                                            }
                                            if (setorKasbon != null) {
                                              jumlah = jumlah -
                                                  int.parse(setorKasbon);
                                            }
                                            var request = TransaksiModel(
                                                idUser: Utils.userModel!.id!
                                                    .toString(),
                                                idCustomer:
                                                    (totalCustomer != null)
                                                        ? totalCustomer!.id
                                                            .toString()
                                                        : null,
                                                orderId: null,
                                                shiftId: Utils.shiftModel!.id
                                                    .toString(),
                                                totalGula: (dataGula.isNotEmpty)
                                                    ? txtPayment!.text
                                                        .replaceAll('.', '')
                                                    : null,
                                                weightGula: (dataGula.isNotEmpty)
                                                    ? dataGula['weight']
                                                    : null,
                                                priceBeliGula:
                                                    (dataGula.isNotEmpty)
                                                        ? dataGula['priceBeli']
                                                        : null,
                                                priceJualGula:
                                                    (dataGula.isNotEmpty)
                                                        ? dataGula['priceJual']
                                                        : null,
                                                setorKasbon: setorKasbon,
                                                noteKasbon: note,
                                                setorGula: setorGula,
                                                noteGula: note,
                                                totalHarga: subTotal.toString(),
                                                bayar: txtPayment!.text
                                                    .replaceAll('.', ''),
                                                kembalian: jumlah.toString(),
                                                paymentType: (dataGula.isNotEmpty)
                                                    ? "Gula"
                                                    : "Cash",
                                                created: DateTime.now()
                                                    .toIso8601String(),
                                                detail: detail);
                                            final Map<int, double> groupedSums =
                                                {};
                                            bool status = false;
                                            for (var item in cart!) {
                                              final idProduct =
                                                  int.parse(item.productId!);
                                              double qty = 0;
                                              if (item.varianId != null) {
                                                qty = double.parse(item
                                                        .varian!.stokVarian) *
                                                    double.parse(item.qty!);
                                              } else {
                                                qty = double.parse(item.qty!);
                                              }
                                              if (groupedSums
                                                  .containsKey(idProduct)) {
                                                groupedSums[idProduct] =
                                                    (groupedSums[idProduct] ??
                                                            0) +
                                                        qty;
                                              } else {
                                                groupedSums[idProduct] = qty;
                                              }
                                            }
                                            groupedSums
                                                .forEach((key, value) async {
                                              var dataProduct =
                                                  cart!.firstWhere(
                                                (element) =>
                                                    element.productId ==
                                                    key.toString(),
                                              );
                                              var stock = double.parse(
                                                      dataProduct
                                                          .product!.stock) -
                                                  value;
                                              if (stock.toInt() < 0) {
                                                String namaBarang = dataProduct
                                                    .product!.namaBarang;
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: const Text(
                                                          "Warning",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .yellowAccent,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 24),
                                                        ),
                                                        content: Text(
                                                          "$namaBarang Stock Tidak Cukup",
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .red,
                                                                  fontSize: 18),
                                                        ),
                                                        actions: [
                                                          ElevatedButton(
                                                            onPressed: () {
                                                              if (Navigator.of(
                                                                      context)
                                                                  .canPop()) {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              } else {
                                                                // Optionally handle this case where there are no pages left to pop
                                                                print(
                                                                    'No pages left to pop');
                                                              }
                                                            },
                                                            style: ElevatedButton
                                                                .styleFrom(
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                    ),
                                                                    fixedSize:
                                                                        const Size(
                                                                            100,
                                                                            40),
                                                                    backgroundColor:
                                                                        const Color(
                                                                            0xFFC0C2D1)),
                                                            child: Text(
                                                              "Oke",
                                                              style: GoogleFonts
                                                                  .playfairDisplay(
                                                                      color: const Color(
                                                                          0xFF252323),
                                                                      fontSize:
                                                                          20),
                                                            ),
                                                          )
                                                        ],
                                                      );
                                                    });
                                                status = true;
                                                return;
                                              }
                                            });
                                            if (!status) {
                                              context.read<TransaksiBloc>().add(
                                                  CreateTransaksi(
                                                      trans: request));
                                            }
                                          }
                                        },
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                        ],
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            contentPadding:
                                                const EdgeInsets.only(
                                                    left: 35,
                                                    top: 8,
                                                    bottom: 15),
                                            fillColor: Colors.white,
                                            hintText: "Rp 25.000",
                                            hintStyle: const TextStyle(
                                                color: Color(0XFFAA9D9D))),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "EDC",
                              style: GoogleFonts.playfairDisplay(fontSize: 24),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  child: GridView(
                                    shrinkWrap: true,
                                    physics: const ScrollPhysics(),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount:
                                          3, // number of items in each row
                                      mainAxisExtent: 80,
                                      mainAxisSpacing:
                                          20, // spacing between columns
                                    ),
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            if (Navigator.of(context)
                                                .canPop()) {
                                              Navigator.of(context).pop();
                                            } else {
                                              // Optionally handle this case where there are no pages left to pop
                                              print('No pages left to pop');
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              fixedSize: const Size(150, 70),
                                              backgroundColor:
                                                  const Color(0XFFFFFFFF)),
                                          child: Text(
                                            "BCA",
                                            style: GoogleFonts.play(
                                                color: const Color(0XFF2334A6),
                                                fontSize: 20),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            if (Navigator.of(context)
                                                .canPop()) {
                                              Navigator.of(context).pop();
                                            } else {
                                              // Optionally handle this case where there are no pages left to pop
                                              print('No pages left to pop');
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              fixedSize: const Size(150, 70),
                                              backgroundColor:
                                                  const Color(0XFFFFFFFF)),
                                          child: Text(
                                            "MANDIRI",
                                            style: GoogleFonts.play(
                                                color: const Color(0XFF2334A6),
                                                fontSize: 20),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            if (Navigator.of(context)
                                                .canPop()) {
                                              Navigator.of(context).pop();
                                            } else {
                                              // Optionally handle this case where there are no pages left to pop
                                              print('No pages left to pop');
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              fixedSize: const Size(150, 70),
                                              backgroundColor:
                                                  const Color(0XFFFFFFFF)),
                                          child: Text(
                                            "BRI",
                                            style: GoogleFonts.play(
                                                color: const Color(0XFF2334A6),
                                                fontSize: 20),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            if (Navigator.of(context)
                                                .canPop()) {
                                              Navigator.of(context).pop();
                                            } else {
                                              // Optionally handle this case where there are no pages left to pop
                                              print('No pages left to pop');
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              fixedSize: const Size(150, 70),
                                              backgroundColor:
                                                  const Color(0XFFFFFFFF)),
                                          child: Text(
                                            "BNI",
                                            style: GoogleFonts.play(
                                                color: const Color(0XFF2334A6),
                                                fontSize: 20),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            if (Navigator.of(context)
                                                .canPop()) {
                                              Navigator.of(context).pop();
                                            } else {
                                              // Optionally handle this case where there are no pages left to pop
                                              print('No pages left to pop');
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              fixedSize: const Size(150, 70),
                                              backgroundColor:
                                                  const Color(0XFFFFFFFF)),
                                          child: Text(
                                            "BJB",
                                            style: GoogleFonts.play(
                                                color: const Color(0XFF2334A6),
                                                fontSize: 20),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            if (Navigator.of(context)
                                                .canPop()) {
                                              Navigator.of(context).pop();
                                            } else {
                                              // Optionally handle this case where there are no pages left to pop
                                              print('No pages left to pop');
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              fixedSize: const Size(150, 70),
                                              backgroundColor:
                                                  const Color(0XFFFFFFFF)),
                                          child: Text(
                                            "BKPD",
                                            style: GoogleFonts.play(
                                                color: const Color(0XFF2334A6),
                                                fontSize: 20),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  color: Colors.white,
                                  child: TextField(
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        contentPadding: const EdgeInsets.only(
                                            left: 35, top: 8, bottom: 15),
                                        fillColor: Colors.white,
                                        hintText: "Masukan Catatan",
                                        hintStyle: const TextStyle(
                                            color: Color(0XFFAA9D9D))),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<dynamic> modalCustomer(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.8,
            child: BlocBuilder<CustomerBloc, CustomerState>(
              builder: (context, state) {
                if (state is! CustomerSuccess) {
                  return Container();
                }
                total = state.custModel.length.toDouble();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // header
                    Container(
                      height: 100,
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      decoration: BoxDecoration(
                          border: Border.all(color: const Color(0XFFD9D9D9))),
                      child: Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              if (Navigator.of(context).canPop()) {
                                Navigator.of(context).pop();
                              } else {
                                // Optionally handle this case where there are no pages left to pop
                                print('No pages left to pop');
                              }
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
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  total.toString().replaceAll('.0', ''),
                                  style: GoogleFonts.play(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  "Customer",
                                  style: GoogleFonts.playfairDisplay(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // body
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      color: Colors.white,
                      child: TextField(
                        keyboardType: TextInputType.text,
                        onSubmitted: (value) {
                          context
                              .read<CustomerBloc>()
                              .add(GetSearchCustomer(nama: value));
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            contentPadding: const EdgeInsets.only(
                                left: 35, top: 8, bottom: 15),
                            fillColor: Colors.white,
                            hintText: "Search",
                            hintStyle:
                                const TextStyle(color: Color(0XFFAA9D9D))),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 25),
                      color: Colors.white,
                      child: ElevatedButton(
                        onPressed: () {
                          modalAddCustomer(context);
                        },
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            fixedSize:
                                Size(MediaQuery.of(context).size.width * 1, 50),
                            backgroundColor: const Color(0XFF2334A6)),
                        child: Text(
                          "Tambah Customer",
                          style: GoogleFonts.playfairDisplay(
                              color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 1,
                          padding: const EdgeInsets.all(2.0),
                          child: DataTable(
                            border:
                                TableBorder.all(width: 0, color: Colors.white),
                            showCheckboxColumn: false,
                            headingRowColor: MaterialStateColor.resolveWith(
                                (states) => const Color(0xFFC2BEBE)),
                            columns: [
                              DataColumn(
                                label: ConstrainedBox(
                                  constraints: const BoxConstraints(),
                                  child: Text(
                                    "Name",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.playfairDisplay(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0XFF000000)),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: ConstrainedBox(
                                  constraints: const BoxConstraints(),
                                  child: Text(
                                    "Phone",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.playfairDisplay(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0XFF000000)),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: ConstrainedBox(
                                  constraints: const BoxConstraints(),
                                  child: Text(
                                    "Email",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.playfairDisplay(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0XFF000000)),
                                  ),
                                ),
                              ),
                            ],
                            rows: state.custModel.map((e) {
                              return DataRow(
                                color: MaterialStateProperty.all(Colors.white),
                                onSelectChanged: (value) {
                                  setState(() {
                                    kasbon = 0;
                                    if (e.kasbon != null) {
                                      kasbon = int.parse(e.kasbon!.nominal!);
                                    }
                                    txtCustomer!.text = e.nama!;
                                    totalCustomer = CustomerModel(
                                        id: e.id,
                                        nama: e.nama,
                                        phone: e.phone,
                                        email: e.email,
                                        created: e.created);
                                  });
                                  if (Navigator.of(context).canPop()) {
                                    Navigator.of(context).pop();
                                  } else {
                                    // Optionally handle this case where there are no pages left to pop
                                    print('No pages left to pop');
                                  }
                                },
                                cells: [
                                  DataCell(ConstrainedBox(
                                    constraints: const BoxConstraints(),
                                    child: Text(
                                      e.nama!,
                                      style: GoogleFonts.playfairDisplay(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400,
                                          color: const Color(0XFF000000)),
                                    ),
                                  )),
                                  DataCell(ConstrainedBox(
                                    constraints: const BoxConstraints(),
                                    child: Text(
                                      e.phone!,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.play(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400,
                                          color: const Color(0XFF000000)),
                                    ),
                                  )),
                                  DataCell(ConstrainedBox(
                                    constraints: const BoxConstraints(),
                                    child: Text(
                                      e.email!,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.playfairDisplay(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400,
                                          color: const Color(0XFF000000)),
                                    ),
                                  )),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future<dynamic> modalAddCustomer(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            height: MediaQuery.of(context).size.height * 0.6,
            child: const AddCustomer(),
          ),
        );
      },
    );
  }

  Future<dynamic> modal(BuildContext context, String? namaProduct) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            height: MediaQuery.of(context).size.height * 0.8,
            child: ModalProduct(
              namaProduct: namaProduct,
              onToggle: updateStatus,
            ),
          ),
        );
      },
    );
  }

  Future<dynamic> modalCart(BuildContext context, CartModel cart, int index) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.8,
            child: ModalCartProduct(
              cart: cart,
              onToggle: updateStatus,
              index: index,
            ),
          ),
        );
      },
    );
  }

  Future<dynamic> modalGula(BuildContext context) async {
    final result = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            height: MediaQuery.of(context).size.height * 0.5,
            child: ModalGula(
              txtTotGula: txtTotGula,
              keterangan: keterangan,
            ),
          ),
        );
      },
    );

    // Memproses nilai balik dari dialog (ModalGula)
    if (result != null && result) {
      setState(() {
        // Tidak perlu melakukan apa pun khusus jika hanya membutuhkan perubahan pada keterangan
      });
    }
  }

  Future<dynamic> modalSetorGula(BuildContext context) async {
    final result = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            height: MediaQuery.of(context).size.height * 0.5,
            child: ModalSetorGula(
              keterangan: keterangan,
            ),
          ),
        );
      },
    );

    // Memproses nilai balik dari dialog (ModalGula)
    if (result != null && result) {
      setState(() {
        // Tidak perlu melakukan apa pun khusus jika hanya membutuhkan perubahan pada keterangan
      });
    }
  }

  Future<dynamic> modalSetorKasbon(BuildContext context) async {
    final result = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            height: MediaQuery.of(context).size.height * 0.5,
            child: ModalSetorKasbon(
              keterangan: keterangan,
            ),
          ),
        );
      },
    );

    // Memproses nilai balik dari dialog (ModalGula)
    if (result != null && result) {
      setState(() {
        // Tidak perlu melakukan apa pun khusus jika hanya membutuhkan perubahan pada keterangan
      });
    }
  }

  Future<dynamic> modalAddBill(BuildContext context) async {
    final result = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            height: MediaQuery.of(context).size.height * 0.5,
            child: ModalTambahBill(
              keterangan: cart,
            ),
          ),
        );
      },
    );

    // Memproses nilai balik dari dialog (ModalGula)
    if (result != null && result) {
      setState(() {
        // Tidak perlu melakukan apa pun khusus jika hanya membutuhkan perubahan pada keterangan
      });
    }
  }

  Future<dynamic> modalBill(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            height: MediaQuery.of(context).size.height * 0.8,
            child: const ModalBill(),
          ),
        );
      },
    );
  }

  Future<dynamic> modalKasbon(BuildContext context) async {
    final result = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            height: MediaQuery.of(context).size.height * 0.5,
            child: ModalGula(
              txtTotGula: txtTotGula,
              keterangan: keterangan,
            ),
          ),
        );
      },
    );

    // Memproses nilai balik dari dialog (ModalGula)
    if (result != null && result) {
      setState(() {
        // Tidak perlu melakukan apa pun khusus jika hanya membutuhkan perubahan pada keterangan
      });
    }
  }
}

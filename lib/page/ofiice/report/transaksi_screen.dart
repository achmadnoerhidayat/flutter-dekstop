import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:kasir_dekstop/bloc/customer/customer_bloc.dart';
import 'package:kasir_dekstop/bloc/transaksi/transaksi_bloc.dart';
import 'package:kasir_dekstop/helper/number_format.dart';
import 'package:kasir_dekstop/models/transaksi_model.dart';
import 'package:kasir_dekstop/widget/bottom_nav.dart';
import 'package:kasir_dekstop/widget/dashead_line.dart';
import 'package:kasir_dekstop/widget/sidebar.dart';
import 'package:pdf/pdf.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class TransaksiScreen extends StatefulWidget {
  static String routeName = '/ofice/report/transaksi';
  const TransaksiScreen({super.key});

  @override
  State<TransaksiScreen> createState() => _TransaksiScreenState();
}

class _TransaksiScreenState extends State<TransaksiScreen> {
  DateTime? _date = DateTime.now();
  TextEditingController? tanggal;
  TextEditingController? orderId;
  bool struk = false;
  TransaksiModel? transaksiModel;
  int discount = 0;
  int subtotal = 0;
  DateTime? now = DateTime.now();
  SingleValueDropDownController? txtCustomer;
  @override
  void initState() {
    super.initState();
    context.read<TransaksiBloc>().add(GetTrans());
    context.read<CustomerBloc>().add(GetCustomer());
    tanggal = TextEditingController();
    orderId = TextEditingController();
    tanggal!.text = DateFormat("yyyy-MM-dd").format(_date!).toString();
    txtCustomer = SingleValueDropDownController();
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
    final transaksi = BlocBuilder<TransaksiBloc, TransaksiState>(
      builder: (context, state) {
        if (state is TransaksiLoading) {
          return SizedBox(
            width: MediaQuery.of(context).size.width * 0.45,
            height: 200,
            child: const Center(child: CircularProgressIndicator()),
          );
        }
        if (state is TransaksiSuccess) {
          return SizedBox(
            width: MediaQuery.of(context).size.width * 0.45,
            height: 500,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: PlutoGrid(
                    columns: [
                      PlutoColumn(
                        readOnly: true,
                        title: "No",
                        field: "no",
                        width: 65.0,
                        type: PlutoColumnType.text(),
                      ),
                      PlutoColumn(
                        readOnly: true,
                        title: "No Order",
                        field: "order",
                        type: PlutoColumnType.text(),
                      ),
                      PlutoColumn(
                        readOnly: true,
                        title: "Kasir",
                        field: "kasir",
                        type: PlutoColumnType.text(),
                      ),
                      PlutoColumn(
                          readOnly: true,
                          title: "Customer",
                          field: "customer",
                          type: PlutoColumnType.text()),
                      PlutoColumn(
                          readOnly: true,
                          title: "Gross Sales",
                          field: "gross",
                          type: PlutoColumnType.text()),
                      PlutoColumn(
                          readOnly: true,
                          title: "Payment Type",
                          field: "payment",
                          type: PlutoColumnType.text()),
                      PlutoColumn(
                          readOnly: true,
                          title: "Date",
                          field: "date",
                          type: PlutoColumnType.text()),
                      PlutoColumn(
                        readOnly: true,
                        title: "Aksi",
                        field: "aksi",
                        type: PlutoColumnType.text(),
                        renderer: (rendererContext) {
                          return IconButton(
                            icon: const Icon(
                              Icons.remove_red_eye,
                            ),
                            onPressed: () {
                              setState(() {
                                discount = 0;
                                subtotal = 0;
                                transaksiModel = state
                                    .transaksi[rendererContext.row.sortIdx];
                              });
                            },
                            iconSize: 18,
                            color: Colors.red,
                            padding: const EdgeInsets.all(0),
                          );
                        },
                      ),
                    ],
                    rows: state.transaksi.map((detail) {
                      int key = state.transaksi.indexOf(detail);
                      int no = key + 1;
                      return PlutoRow(
                        cells: {
                          "no": PlutoCell(value: no.toString()),
                          "order": PlutoCell(value: detail.orderId),
                          "kasir": PlutoCell(
                              value: (detail.user != null)
                                  ? detail.user!.nama
                                  : ""),
                          "customer": PlutoCell(
                              value: (detail.idCustomer != null)
                                  ? "${detail.customer!.nama}"
                                  : ""),
                          "gross": PlutoCell(
                              value:
                                  "Rp ${NumberFormats.convertToIdr(detail.totalHarga!)}"),
                          "payment": PlutoCell(value: "${detail.paymentType}"),
                          "date": PlutoCell(
                              value: NumberFormats.getFormattedDate(
                                  DateTime.parse(detail.created!))),
                          "aksi": PlutoCell(value: "akse"),
                        },
                      );
                    }).toList(),
                    onLoaded: (PlutoGridOnLoadedEvent event) {
                      stateManager = event.stateManager;
                      stateManager.setShowColumnFilter(false);
                    },
                  ),
                ),
                (transaksiModel != null)
                    ? Container(
                        width: MediaQuery.of(context).size.width * 0.35,
                        height: MediaQuery.of(context).size.height * 1,
                        padding: const EdgeInsets.all(20),
                        color: Colors.white,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    alignment: Alignment.topLeft,
                                    onPressed: () async {
                                      printStruk();
                                    },
                                    icon: const Icon(Icons.print),
                                  ),
                                  IconButton(
                                    alignment: Alignment.topRight,
                                    onPressed: () {
                                      setState(() {
                                        transaksiModel = null;
                                      });
                                    },
                                    icon: const Icon(Icons.close),
                                  ),
                                ],
                              ),
                              Text(
                                (transaksiModel!.receipt != null)
                                    ? "${transaksiModel!.receipt!.namaToko}"
                                    : "Nama Toko",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 27),
                              ),
                              Text(
                                (transaksiModel!.receipt != null)
                                    ? "${transaksiModel!.receipt!.alamat} ${transaksiModel!.receipt!.kota} ${transaksiModel!.receipt!.provinsi} ${transaksiModel!.receipt!.kodePos}"
                                    : "Jln -- ",
                                style: const TextStyle(
                                    fontSize: 14, color: Color(0xFF868282)),
                              ),
                              Text(
                                (transaksiModel!.receipt != null)
                                    ? "${transaksiModel!.receipt!.phone}"
                                    : "081224738582",
                                style: const TextStyle(
                                    fontSize: 14, color: Color(0xFF868282)),
                              ),
                              const SizedBox(height: 20),
                              Container(
                                margin: const EdgeInsets.only(
                                    bottom: 5, left: 7, right: 7),
                                child: const DashedLine(
                                  dashWidth: 2.0,
                                  dashSpace: 10.0,
                                  color: Color(0xFF312E2E),
                                ),
                              ),
                              Container(
                                alignment: Alignment.topLeft,
                                margin:
                                    const EdgeInsets.only(bottom: 5, left: 5),
                                child: Text(
                                  NumberFormats.getFormatDay(
                                      DateTime.parse(transaksiModel!.created!)),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              Row(
                                children: [
                                  Container(
                                      width: 64,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: const Text("No Order")),
                                  Text(transaksiModel!.orderId!),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  Container(
                                      width: 64,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: const Text("Kasir")),
                                  const Text("Maulida"),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  Container(
                                      width: 64,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: const Text("Customer")),
                                  Text((transaksiModel!.idCustomer != null)
                                      ? "${transaksiModel!.customer!.nama}"
                                      : "Umum"),
                                ],
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                    bottom: 5, left: 7, right: 7, top: 15),
                                child: const DashedLine(
                                  dashWidth: 2.0,
                                  dashSpace: 10.0,
                                  color: Color(0xFF312E2E),
                                ),
                              ),
                              Column(
                                children: transaksiModel!.detail!.map((e) {
                                  String promo = "";
                                  int potongan = 0;
                                  double total = 0;
                                  if (e.idVarian == null) {
                                    total = double.parse(e.product!.harga) *
                                        double.parse(e.qty!);
                                  } else {
                                    total =
                                        double.parse(e.varian!.hargaVarian) *
                                            double.parse(e.qty!);
                                  }
                                  if (e.totalDiskon != null) {
                                    discount += int.parse(e.totalDiskon!);
                                  }
                                  if (e.product?.promoProducts != null) {
                                    DateTime tanggalMulai = DateTime.parse(e
                                        .product!
                                        .promoProducts!
                                        .promo!
                                        .promoMulai!);
                                    DateTime tanggalBerakhir = DateTime.parse(e
                                        .product!
                                        .promoProducts!
                                        .promo!
                                        .promoBerakhir!);
                                    if (tanggalMulai.isBefore(now!) ||
                                        tanggalBerakhir.isBefore(now!)) {
                                      String min =
                                          "${e.product!.promoProducts!.minBelanja}";
                                      if (int.parse(min) == int.parse(e.qty!)) {
                                        promo = e.product!.promoProducts!
                                            .hargaPromo!;
                                        int pot =
                                            total.toInt() - int.parse(promo);
                                        potongan = pot;
                                      }
                                    }
                                  }
                                  subtotal += total.toInt();
                                  return Container(
                                    width:
                                        MediaQuery.of(context).size.width * 1,
                                    padding: const EdgeInsets.only(
                                        right: 10, left: 5, bottom: 5),
                                    decoration: const BoxDecoration(
                                        color: Colors.white),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                e.product!.namaBarang,
                                                style:
                                                    GoogleFonts.playfairDisplay(
                                                        fontSize: 14),
                                              ),
                                              (e.idVarian == null)
                                                  ? Text(
                                                      '${e.qty} X ${NumberFormats.convertToIdr(e.product!.harga)}',
                                                      style: GoogleFonts.play(
                                                          fontSize: 14),
                                                    )
                                                  : Text(
                                                      '${e.qty} ${e.varian!.namaVarian} X ${NumberFormats.convertToIdr(e.varian!.hargaVarian)}',
                                                      style: GoogleFonts.play(
                                                          fontSize: 14),
                                                    ),
                                              (promo != "")
                                                  ? Text("Promo: $potongan",
                                                      style: GoogleFonts.play(
                                                          fontSize: 14))
                                                  : const SizedBox.shrink(),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.1,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              (promo != "")
                                                  ? Column(
                                                      children: [
                                                        Text(
                                                          "Rp ${NumberFormats.convertToIdr(total.toString())}",
                                                          textAlign:
                                                              TextAlign.right,
                                                          style: GoogleFonts.play(
                                                              fontSize: 14,
                                                              color: Colors.red,
                                                              decoration:
                                                                  TextDecoration
                                                                      .lineThrough),
                                                        ),
                                                        Text(
                                                          "Rp ${NumberFormats.convertToIdr(promo.toString())}",
                                                          textAlign:
                                                              TextAlign.right,
                                                          style:
                                                              GoogleFonts.play(
                                                                  fontSize: 14),
                                                        ),
                                                      ],
                                                    )
                                                  : Expanded(
                                                      child: Text(
                                                        "Rp ${NumberFormats.convertToIdr(total.toString())}",
                                                        overflow:
                                                            TextOverflow.fade,
                                                        textAlign:
                                                            TextAlign.right,
                                                        style: GoogleFonts.play(
                                                            fontSize: 14),
                                                      ),
                                                    ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                    left: 10, right: 7, top: 10, bottom: 7),
                                child: const DashedLine(
                                  dashWidth: 2.0,
                                  dashSpace: 10.0,
                                  color: Color(0xFF312E2E),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 120,
                                    alignment: Alignment.topLeft,
                                    margin: const EdgeInsets.only(left: 5),
                                    child: Text("Total",
                                        style: GoogleFonts.playfairDisplay(
                                          fontSize: 14,
                                        )),
                                  ),
                                  const Text("="),
                                  Container(
                                    width: 120,
                                    alignment: Alignment.topRight,
                                    margin: const EdgeInsets.only(right: 5),
                                    child: Text(
                                        NumberFormats.convertToIdr(
                                            subtotal.toString()),
                                        style: GoogleFonts.play(
                                          fontSize: 14,
                                        )),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 120,
                                    alignment: Alignment.topLeft,
                                    margin: const EdgeInsets.only(left: 5),
                                    child: Text("Discount",
                                        style: GoogleFonts.playfairDisplay(
                                          fontSize: 14,
                                        )),
                                  ),
                                  const Text("="),
                                  Container(
                                    width: 120,
                                    alignment: Alignment.topRight,
                                    margin: const EdgeInsets.only(right: 5),
                                    child: Text(
                                        NumberFormats.convertToIdr(
                                            discount.toString()),
                                        style: GoogleFonts.play(
                                          fontSize: 14,
                                        )),
                                  ),
                                ],
                              ),
                              (transaksiModel!.weightGula != null)
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: 120,
                                          alignment: Alignment.topLeft,
                                          margin:
                                              const EdgeInsets.only(left: 5),
                                          child: Text("Berat Gula",
                                              style:
                                                  GoogleFonts.playfairDisplay(
                                                fontSize: 14,
                                              )),
                                        ),
                                        const Text("="),
                                        Container(
                                          width: 120,
                                          alignment: Alignment.topRight,
                                          margin:
                                              const EdgeInsets.only(right: 5),
                                          child:
                                              Text(transaksiModel!.weightGula!,
                                                  style: GoogleFonts.play(
                                                    fontSize: 14,
                                                  )),
                                        ),
                                      ],
                                    )
                                  : const SizedBox.shrink(),
                              (transaksiModel!.priceBeliGula != null)
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: 120,
                                          alignment: Alignment.topLeft,
                                          margin:
                                              const EdgeInsets.only(left: 5),
                                          child: Text("Harga Gula",
                                              style:
                                                  GoogleFonts.playfairDisplay(
                                                fontSize: 14,
                                              )),
                                        ),
                                        const Text("="),
                                        Container(
                                          width: 120,
                                          alignment: Alignment.topRight,
                                          margin:
                                              const EdgeInsets.only(right: 5),
                                          child: Text(
                                              NumberFormats.convertToIdr(
                                                  transaksiModel!
                                                      .priceBeliGula!),
                                              style: GoogleFonts.play(
                                                fontSize: 14,
                                              )),
                                        ),
                                      ],
                                    )
                                  : const SizedBox.shrink(),
                              (transaksiModel!.setorGula != null)
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: 120,
                                          alignment: Alignment.topLeft,
                                          margin:
                                              const EdgeInsets.only(left: 5),
                                          child: Text("Setor Gula",
                                              style:
                                                  GoogleFonts.playfairDisplay(
                                                fontSize: 14,
                                              )),
                                        ),
                                        const Text("="),
                                        Container(
                                          width: 120,
                                          alignment: Alignment.topRight,
                                          margin:
                                              const EdgeInsets.only(right: 5),
                                          child: Text(
                                              NumberFormats.convertToIdr(
                                                  transaksiModel!.setorGula!),
                                              style: GoogleFonts.play(
                                                fontSize: 14,
                                              )),
                                        ),
                                      ],
                                    )
                                  : const SizedBox.shrink(),
                              (transaksiModel!.setorKasbon != null)
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: 120,
                                          alignment: Alignment.topLeft,
                                          margin:
                                              const EdgeInsets.only(left: 5),
                                          child: Text("Setor Kasbon",
                                              style:
                                                  GoogleFonts.playfairDisplay(
                                                fontSize: 14,
                                              )),
                                        ),
                                        const Text("="),
                                        Container(
                                          width: 120,
                                          alignment: Alignment.topRight,
                                          margin:
                                              const EdgeInsets.only(right: 5),
                                          child: Text(
                                              NumberFormats.convertToIdr(
                                                  transaksiModel!.setorKasbon!),
                                              style: GoogleFonts.play(
                                                fontSize: 14,
                                              )),
                                        ),
                                      ],
                                    )
                                  : const SizedBox.shrink(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 120,
                                    alignment: Alignment.topLeft,
                                    margin: const EdgeInsets.only(left: 5),
                                    child: Text("Bayar",
                                        style: GoogleFonts.playfairDisplay(
                                          fontSize: 14,
                                        )),
                                  ),
                                  const Text("="),
                                  Container(
                                    width: 120,
                                    alignment: Alignment.topRight,
                                    margin: const EdgeInsets.only(right: 5),
                                    child: Text(
                                        NumberFormats.convertToIdr(
                                            transaksiModel!.bayar!),
                                        style: GoogleFonts.play(
                                          fontSize: 14,
                                        )),
                                  ),
                                ],
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                    left: 7, right: 7, top: 15, bottom: 7),
                                child: const DashedLine(
                                  dashWidth: 2.0,
                                  dashSpace: 10.0,
                                  color: Color(0xFF312E2E),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 120,
                                    alignment: Alignment.topLeft,
                                    margin: const EdgeInsets.only(left: 5),
                                    child: Text("Kembali",
                                        style: GoogleFonts.playfairDisplay(
                                          fontSize: 14,
                                        )),
                                  ),
                                  const Text("="),
                                  Container(
                                    width: 120,
                                    alignment: Alignment.topRight,
                                    margin: const EdgeInsets.only(right: 5),
                                    child: Text(
                                        NumberFormats.convertToIdr(
                                            transaksiModel!.kembalian!),
                                        style: GoogleFonts.play(
                                          fontSize: 14,
                                        )),
                                  ),
                                ],
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 20),
                                child: Text(
                                  (transaksiModel!.receipt != null)
                                      ? "${transaksiModel!.receipt!.notes}"
                                      : "Terimakasih atas kunjungan anda barang yang telah dibeli tidak bisa dikembalikan kecuali ada perjanjian",
                                  textAlign: TextAlign.center,
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    : const SizedBox()
              ],
            ),
          );
        }
        return Container(
          height: 380,
          width: MediaQuery.of(context).size.width * .45,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'asset/not_found.png',
                width: 300,
                height: 200,
              ),
              Text(
                "Data Tidak Ditemukan !!",
                style: GoogleFonts.playfairDisplay(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
        );
      },
    );
    final customer = BlocBuilder<CustomerBloc, CustomerState>(
      builder: (context, state) {
        if (state is CustomerSuccess) {
          return DropDownTextField(
            controller: txtCustomer,
            clearOption: true,
            enableSearch: true,
            clearIconProperty: IconProperty(color: Colors.red),
            searchTextStyle: const TextStyle(color: Colors.black),
            textFieldDecoration: InputDecoration(
              labelText: 'Pilih Customer',
              labelStyle: const TextStyle(color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: Colors.blue, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: Colors.grey, width: 2),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: Colors.grey, width: 2),
              ),
            ),
            searchDecoration: const InputDecoration(hintText: "Search Suplier"),
            dropDownItemCount: 6,
            dropDownList: state.custModel.map((e) {
              return DropDownValueModel(name: e.nama!, value: e.nama!);
            }).toList(),
            onChanged: (value) {
              if (value is DropDownValueModel) {
                Map<String, dynamic> request = {
                  "no_order": "",
                  "tanggal": "",
                  "cutomer_id": value.value,
                };
                context
                    .read<TransaksiBloc>()
                    .add(GetSearchTrans(params: request));
              }
            },
          );
        }
        return DropDownTextField(
          controller: txtCustomer,
          clearOption: true,
          enableSearch: true,
          clearIconProperty: IconProperty(color: Colors.red),
          searchTextStyle: const TextStyle(color: Colors.black),
          textFieldDecoration: InputDecoration(
            labelText: 'Pilih Customer',
            labelStyle: const TextStyle(color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(color: Colors.blue, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(color: Colors.grey, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(color: Colors.grey, width: 2),
            ),
          ),
          searchDecoration: const InputDecoration(hintText: "Search Suplier"),
          dropDownItemCount: 6,
          dropDownList: const [],
          onChanged: (value) {},
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
                              "Transaksi",
                              style: GoogleFonts.playfairDisplay(
                                  fontSize: 30, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 20.0, bottom: 10),
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.25,
                              child: TextField(
                                controller: orderId,
                                minLines: 1,
                                keyboardType: TextInputType.text,
                                maxLines: null,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "Search Transaksi",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 10),
                                  isDense: true,
                                ),
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.2,
                              child: customer,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.20,
                              child: TextField(
                                controller: tanggal,
                                minLines: 1,
                                keyboardType: TextInputType.text,
                                maxLines: null,
                                readOnly: true,
                                onTap: () async {
                                  DateTime? pickerdate = await showDatePicker(
                                      context: context,
                                      initialDate: _date,
                                      firstDate: DateTime(_date!.year - 200),
                                      lastDate: DateTime(_date!.year + 100));
                                  if (pickerdate != null) {
                                    setState(() {
                                      _date = pickerdate;
                                      String dateStr = DateFormat("yyyy-MM-dd")
                                          .format(_date!)
                                          .toString();
                                      tanggal?.text = dateStr;
                                    });
                                  }
                                },
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "tanggal",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 10),
                                  isDense: true,
                                ),
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.1,
                              child: ElevatedButton(
                                onPressed: () {
                                  Map<String, dynamic> request = {
                                    "no_order": (orderId?.text != null)
                                        ? orderId!.text
                                        : " ",
                                    "tanggal": tanggal!.text,
                                    "cutomer_id":
                                        (txtCustomer?.dropDownValue?.value !=
                                                null)
                                            ? txtCustomer?.dropDownValue?.value
                                            : "",
                                  };
                                  context
                                      .read<TransaksiBloc>()
                                      .add(GetSearchTrans(params: request));
                                },
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    fixedSize: const Size(10, 50),
                                    backgroundColor: const Color(0XFF2334A6)),
                                child: Text(
                                  "Search",
                                  style: GoogleFonts.playfairDisplay(
                                      color: const Color(0XFFFFFFFF),
                                      fontSize: 20),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.zero,
                          scrollDirection: Axis.vertical,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            padding: const EdgeInsets.only(
                                left: 20.0, right: 20.0, bottom: 20.0),
                            child: transaksi,
                          ),
                        ),
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

  Future<void> printStruk() async {
    final doc = pw.Document();
    subtotal = 0;
    discount = 0;
    doc.addPage(pw.Page(
      pageFormat: const PdfPageFormat(48 * PdfPageFormat.mm, double.infinity),
      build: (pw.Context context) {
        return pw.Container(
            color: PdfColors.white,
            margin: const pw.EdgeInsets.only(bottom: 20),
            child: pw.Column(
              children: [
                pw.SizedBox(height: 15),
                pw.Text(
                  (transaksiModel!.receipt != null)
                      ? "${transaksiModel!.receipt!.namaToko}"
                      : "Nama Toko",
                  style: pw.TextStyle(
                      fontSize: 12, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 3),
                pw.Text(
                  textAlign: pw.TextAlign.center,
                  (transaksiModel!.receipt != null)
                      ? "${transaksiModel!.receipt!.alamat} ${transaksiModel!.receipt!.kota} ${transaksiModel!.receipt!.provinsi} ${transaksiModel!.receipt!.kodePos}"
                      : "Jln -- ",
                  style: const pw.TextStyle(fontSize: 7.2),
                ),
                pw.Text(
                  (transaksiModel!.receipt != null)
                      ? "${transaksiModel!.receipt!.phone}"
                      : "081224738582",
                  style: const pw.TextStyle(fontSize: 7.2),
                ),
                pw.SizedBox(height: 20),
                pw.Container(
                  margin:
                      const pw.EdgeInsets.only(bottom: 5, left: 5, right: 5),
                  decoration: const pw.BoxDecoration(
                    border: pw.Border(
                      bottom: pw.BorderSide(
                        color: PdfColors.black,
                        width: 0.8,
                        style: pw.BorderStyle.dashed,
                      ),
                    ),
                  ),
                ),
                pw.Container(
                  alignment: pw.Alignment.topLeft,
                  margin: const pw.EdgeInsets.only(bottom: 5, left: 5),
                  child: pw.Text(
                      NumberFormats.getFormatDay(
                          DateTime.parse(transaksiModel!.created!)),
                      textAlign: pw.TextAlign.start,
                      style: const pw.TextStyle(fontSize: 8.5)),
                ),
                pw.Row(
                  children: [
                    pw.Container(
                        width: 64,
                        margin: const pw.EdgeInsets.symmetric(horizontal: 5),
                        child: pw.Text("No Order",
                            style: const pw.TextStyle(fontSize: 8.5))),
                    pw.Text(transaksiModel!.orderId!,
                        style: const pw.TextStyle(fontSize: 8.5)),
                  ],
                ),
                pw.SizedBox(height: 5),
                pw.Row(
                  children: [
                    pw.Container(
                        width: 64,
                        margin: const pw.EdgeInsets.symmetric(horizontal: 5),
                        child: pw.Text("Kasir",
                            style: const pw.TextStyle(fontSize: 8.5))),
                    pw.Text("Maulida",
                        style: const pw.TextStyle(fontSize: 8.5)),
                  ],
                ),
                pw.SizedBox(height: 5),
                pw.Row(
                  children: [
                    pw.Container(
                        width: 64,
                        margin: const pw.EdgeInsets.symmetric(horizontal: 5),
                        child: pw.Text("Customer",
                            style: const pw.TextStyle(fontSize: 8.5))),
                    pw.Text(
                        (transaksiModel!.idCustomer != null)
                            ? "${transaksiModel!.customer!.nama}"
                            : "Umum",
                        style: const pw.TextStyle(fontSize: 8.5)),
                  ],
                ),
                pw.Container(
                  margin: const pw.EdgeInsets.only(
                      top: 10, bottom: 2, left: 5, right: 5),
                  decoration: const pw.BoxDecoration(
                    border: pw.Border(
                      bottom: pw.BorderSide(
                        color: PdfColors.black,
                        width: 0.8,
                        style: pw.BorderStyle.dashed,
                      ),
                    ),
                  ),
                ),
                pw.Column(
                  children: transaksiModel!.detail!.map((e) {
                    String promo = "";
                    int potongan = 0;
                    double total = 0;
                    if (e.idVarian == null) {
                      total =
                          double.parse(e.product!.harga) * double.parse(e.qty!);
                    } else {
                      total = double.parse(e.varian!.hargaVarian) *
                          double.parse(e.qty!);
                    }
                    if (e.totalDiskon != null) {
                      discount += int.parse(e.totalDiskon!);
                    }
                    if (e.product?.promoProducts != null) {
                      DateTime tanggalMulai = DateTime.parse(
                          e.product!.promoProducts!.promo!.promoMulai!);
                      DateTime tanggalBerakhir = DateTime.parse(
                          e.product!.promoProducts!.promo!.promoBerakhir!);
                      if (tanggalMulai.isBefore(now!) ||
                          tanggalBerakhir.isBefore(now!)) {
                        String min = "${e.product!.promoProducts!.minBelanja}";
                        if (int.parse(min) == int.parse(e.qty!)) {
                          promo = e.product!.promoProducts!.hargaPromo!;
                          int pot = total.toInt() - int.parse(promo);
                          potongan = pot;
                        }
                      }
                    }
                    subtotal += total.toInt();
                    return pw.Container(
                      padding: const pw.EdgeInsets.only(
                          left: 5, right: 5, bottom: 3),
                      child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.SizedBox(
                            width: 100,
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  e.product!.namaBarang,
                                  style: const pw.TextStyle(fontSize: 8.5),
                                ),
                                (e.idVarian == null)
                                    ? pw.Text(
                                        '${e.qty} X ${NumberFormats.convertToIdr(e.product!.harga)}',
                                        style:
                                            const pw.TextStyle(fontSize: 8.5),
                                      )
                                    : pw.Text(
                                        '${e.qty} ${e.varian!.namaVarian} X ${NumberFormats.convertToIdr(e.varian!.hargaVarian)}',
                                        style:
                                            const pw.TextStyle(fontSize: 8.5),
                                      ),
                                (promo != "")
                                    ? pw.Text("Promo: $potongan",
                                        style:
                                            const pw.TextStyle(fontSize: 8.5))
                                    : pw.SizedBox.shrink(),
                              ],
                            ),
                          ),
                          pw.SizedBox(
                            child: pw.Row(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              mainAxisAlignment: pw.MainAxisAlignment.end,
                              children: [
                                (promo != "")
                                    ? pw.Column(
                                        children: [
                                          pw.Text(
                                            NumberFormats.convertToIdr(
                                                total.toString()),
                                            textAlign: pw.TextAlign.right,
                                            style: const pw.TextStyle(
                                                fontSize: 8.5,
                                                color: PdfColors.red,
                                                decoration: pw.TextDecoration
                                                    .lineThrough),
                                          ),
                                          pw.Text(
                                            NumberFormats.convertToIdr(
                                                promo.toString()),
                                            textAlign: pw.TextAlign.right,
                                            style: const pw.TextStyle(
                                                fontSize: 8.5),
                                          ),
                                        ],
                                      )
                                    : pw.Text(
                                        NumberFormats.convertToIdr(
                                            total.toString()),
                                        textAlign: pw.TextAlign.right,
                                        style:
                                            const pw.TextStyle(fontSize: 8.5),
                                      ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                pw.Container(
                  margin: const pw.EdgeInsets.only(
                      top: 10, bottom: 10, left: 5, right: 5),
                  decoration: const pw.BoxDecoration(
                    border: pw.Border(
                      bottom: pw.BorderSide(
                        color: PdfColors.black,
                        width: 0.8,
                        style: pw.BorderStyle.dashed,
                      ),
                    ),
                  ),
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Container(
                      width: 60,
                      alignment: pw.Alignment.topLeft,
                      margin: const pw.EdgeInsets.only(left: 5),
                      child: pw.Text("Total",
                          style: const pw.TextStyle(
                            fontSize: 8.5,
                          )),
                    ),
                    pw.Text("="),
                    pw.Container(
                      width: 60,
                      alignment: pw.Alignment.topRight,
                      margin: const pw.EdgeInsets.only(right: 5),
                      child: pw.Text(
                          NumberFormats.convertToIdr(subtotal.toString()),
                          style: const pw.TextStyle(
                            fontSize: 8.5,
                          )),
                    ),
                  ],
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Container(
                      width: 60,
                      alignment: pw.Alignment.topLeft,
                      margin: const pw.EdgeInsets.only(left: 5),
                      child: pw.Text("Discount",
                          style: const pw.TextStyle(
                            fontSize: 8.5,
                          )),
                    ),
                    pw.Text("="),
                    pw.Container(
                      width: 60,
                      alignment: pw.Alignment.topRight,
                      margin: const pw.EdgeInsets.only(right: 5),
                      child: pw.Text(
                          NumberFormats.convertToIdr(discount.toString()),
                          style: const pw.TextStyle(
                            fontSize: 8.5,
                          )),
                    ),
                  ],
                ),
                (transaksiModel!.weightGula != null)
                    ? pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Container(
                            width: 60,
                            alignment: pw.Alignment.topLeft,
                            margin: const pw.EdgeInsets.only(left: 5),
                            child: pw.Text("Berat Gula",
                                style: const pw.TextStyle(
                                  fontSize: 8.5,
                                )),
                          ),
                          pw.Text("="),
                          pw.Container(
                            width: 60,
                            alignment: pw.Alignment.topRight,
                            margin: const pw.EdgeInsets.only(right: 5),
                            child: pw.Text(transaksiModel!.weightGula!,
                                style: const pw.TextStyle(
                                  fontSize: 8.5,
                                )),
                          ),
                        ],
                      )
                    : pw.SizedBox.shrink(),
                (transaksiModel!.priceBeliGula != null)
                    ? pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Container(
                            width: 60,
                            alignment: pw.Alignment.topLeft,
                            margin: const pw.EdgeInsets.only(left: 5),
                            child: pw.Text("Harga Gula",
                                style: const pw.TextStyle(
                                  fontSize: 8.5,
                                )),
                          ),
                          pw.Text("="),
                          pw.Container(
                            width: 60,
                            alignment: pw.Alignment.topRight,
                            margin: const pw.EdgeInsets.only(right: 5),
                            child: pw.Text(
                                NumberFormats.convertToIdr(
                                    transaksiModel!.priceBeliGula!),
                                style: const pw.TextStyle(
                                  fontSize: 8.5,
                                )),
                          ),
                        ],
                      )
                    : pw.SizedBox.shrink(),
                (transaksiModel!.setorGula != null)
                    ? pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Container(
                            width: 60,
                            alignment: pw.Alignment.topLeft,
                            margin: const pw.EdgeInsets.only(left: 5),
                            child: pw.Text("Setor Gula",
                                style: const pw.TextStyle(
                                  fontSize: 8.5,
                                )),
                          ),
                          pw.Text("="),
                          pw.Container(
                            width: 60,
                            alignment: pw.Alignment.topRight,
                            margin: const pw.EdgeInsets.only(right: 5),
                            child: pw.Text(
                                NumberFormats.convertToIdr(
                                    transaksiModel!.setorGula!),
                                style: const pw.TextStyle(
                                  fontSize: 8.5,
                                )),
                          ),
                        ],
                      )
                    : pw.SizedBox.shrink(),
                (transaksiModel!.setorKasbon != null)
                    ? pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Container(
                            width: 60,
                            alignment: pw.Alignment.topLeft,
                            margin: const pw.EdgeInsets.only(left: 5),
                            child: pw.Text("Setor Kasbon",
                                style: const pw.TextStyle(
                                  fontSize: 8.5,
                                )),
                          ),
                          pw.Text("="),
                          pw.Container(
                            width: 60,
                            alignment: pw.Alignment.topRight,
                            margin: const pw.EdgeInsets.only(right: 5),
                            child: pw.Text(
                                NumberFormats.convertToIdr(
                                    transaksiModel!.setorKasbon!),
                                style: const pw.TextStyle(
                                  fontSize: 8.5,
                                )),
                          ),
                        ],
                      )
                    : pw.SizedBox.shrink(),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Container(
                      width: 60,
                      alignment: pw.Alignment.topLeft,
                      margin: const pw.EdgeInsets.only(left: 5),
                      child: pw.Text("Bayar",
                          style: const pw.TextStyle(
                            fontSize: 8.5,
                          )),
                    ),
                    pw.Text("="),
                    pw.Container(
                      width: 60,
                      alignment: pw.Alignment.topRight,
                      margin: const pw.EdgeInsets.only(right: 5),
                      child: pw.Text(
                          NumberFormats.convertToIdr(transaksiModel!.bayar!),
                          style: const pw.TextStyle(
                            fontSize: 8.5,
                          )),
                    ),
                  ],
                ),
                pw.Container(
                  margin: const pw.EdgeInsets.only(
                      top: 10, bottom: 10, left: 5, right: 5),
                  decoration: const pw.BoxDecoration(
                    border: pw.Border(
                      bottom: pw.BorderSide(
                        color: PdfColors.black,
                        width: 0.8,
                        style: pw.BorderStyle.dashed,
                      ),
                    ),
                  ),
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Container(
                      width: 60,
                      alignment: pw.Alignment.topLeft,
                      margin: const pw.EdgeInsets.only(left: 5),
                      child: pw.Text("Kembali",
                          style: const pw.TextStyle(
                            fontSize: 8.5,
                          )),
                    ),
                    pw.Text("="),
                    pw.Container(
                      width: 60,
                      alignment: pw.Alignment.topRight,
                      margin: const pw.EdgeInsets.only(right: 5),
                      child: pw.Text(
                          NumberFormats.convertToIdr(
                              transaksiModel!.kembalian!),
                          style: const pw.TextStyle(
                            fontSize: 8.5,
                          )),
                    ),
                  ],
                ),
                pw.Container(
                  margin: const pw.EdgeInsets.symmetric(
                      horizontal: 15, vertical: 20),
                  child: pw.Text(
                      (transaksiModel!.receipt != null)
                          ? "${transaksiModel!.receipt!.notes}"
                          : "Terimakasih atas kunjungan anda barang yang telah dibeli tidak bisa dikembalikan kecuali ada perjanjian",
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(fontSize: 8.5)),
                ),
              ],
            ));
      },
    ));

    final printers = await Printing.listPrinters();
    Printer? defaultPrint;
    for (var printer in printers) {
      if (printer.name.contains("POS58 Printer")) {
        defaultPrint = printer;
        break;
      }
    }
    if (defaultPrint == null && printers.isNotEmpty) {
      defaultPrint = printers.first;
    }
    if (defaultPrint != null) {
      try {
        String noOrder = transaksiModel!.orderId!.replaceAll('/', '-');
        await Printing.directPrintPdf(
            printer: defaultPrint,
            name: "struk-$noOrder",
            onLayout: (PdfPageFormat format) async => doc.save());
        // print(data);
      } catch (e) {
        // print('Error during printing: $e');
      }
    }
    // print(defaultPrint);
    // Printing.layoutPdf(onLayout: (PdfPageFormat format) async => doc.save());
    // final file = File('D:/struk.pdf');
    // await file.writeAsBytes(await doc.save());
  }
}

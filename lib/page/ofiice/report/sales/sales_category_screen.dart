import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:kasir_dekstop/bloc/transaksi/transaksi_bloc.dart';
import 'package:kasir_dekstop/helper/number_format.dart';
import 'package:kasir_dekstop/widget/bottom_nav.dart';
import 'package:kasir_dekstop/widget/sidebar.dart';
import 'package:kasir_dekstop/widget/sidebar_sales.dart';
import 'package:pluto_grid/pluto_grid.dart';

class SalesCategoryScreen extends StatefulWidget {
  static String routeName = '/ofice/report/sales-category';
  const SalesCategoryScreen({super.key});

  @override
  State<SalesCategoryScreen> createState() => _SalesCategoryScreenState();
}

class _SalesCategoryScreenState extends State<SalesCategoryScreen> {
  TextEditingController? tanggal;
  TextEditingController? orderId;
  DateTime? _date = DateTime.now();
  String today = DateTime.now().toIso8601String().substring(0, 10);
  @override
  void initState() {
    super.initState();
    Map<String, dynamic> request = {
      "no_order": (orderId?.text != null) ? orderId!.text : "",
      "tanggal": today,
    };
    context
        .read<TransaksiBloc>()
        .add(GetTransaksiDetailCategory(params: request));
    tanggal = TextEditingController();
    orderId = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    tanggal!.dispose();
    orderId!.dispose();
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
        if (state is TransaksiDetailLoading) {
          return SizedBox(
            width: MediaQuery.of(context).size.width * 0.45,
            height: 200,
            child: const Center(child: CircularProgressIndicator()),
          );
        }
        if (state is TransaksiDetailSuccess) {
          return SizedBox(
            width: MediaQuery.of(context).size.width * 0.45,
            height: 400,
            child: PlutoGrid(
              columns: [
                PlutoColumn(
                  readOnly: true,
                  title: "Category",
                  field: "name",
                  type: PlutoColumnType.text(),
                ),
                PlutoColumn(
                    readOnly: true,
                    title: "Item Sold",
                    field: "sold",
                    type: PlutoColumnType.text()),
                PlutoColumn(
                    readOnly: true,
                    title: "Gross Sales",
                    field: "sales",
                    type: PlutoColumnType.text()),
                PlutoColumn(
                    readOnly: true,
                    title: "Discount",
                    field: "discount",
                    type: PlutoColumnType.text()),
                PlutoColumn(
                    readOnly: true,
                    title: "Net Sales",
                    field: "net",
                    type: PlutoColumnType.text()),
                PlutoColumn(
                    readOnly: true,
                    title: "Gros Profit",
                    field: "gros",
                    type: PlutoColumnType.text()),
                PlutoColumn(
                    readOnly: true,
                    title: "Margin",
                    field: "margin",
                    type: PlutoColumnType.text()),
              ],
              rows: state.transaksiDetail.map((detail) {
                int diskon = 0;
                if (detail.totalDiskon != "null") {
                  diskon = int.parse(detail.totalDiskon!);
                }
                var grosSales = double.parse(detail.hargaProduct!);
                var purchase = double.parse(detail.hargaModal!);
                var netSales = grosSales - diskon;
                var grosProfit = grosSales - purchase - diskon;
                var margin = (grosProfit / purchase) * 100;
                return PlutoRow(
                  cells: {
                    'name': PlutoCell(value: detail.product!.categori!.nama),
                    'sold': PlutoCell(value: detail.qty),
                    'sales': PlutoCell(
                        value:
                            "Rp ${NumberFormats.convertToIdr(grosSales.toString())}"),
                    'discount': PlutoCell(
                        value: (detail.totalDiskon != "null")
                            ? "Rp ${NumberFormats.convertToIdr(detail.totalDiskon!)}"
                            : "Rp 0"),
                    'net': PlutoCell(
                        value:
                            "Rp ${NumberFormats.convertToIdr(netSales.toString())}"),
                    'gros': PlutoCell(
                        value:
                            "Rp ${NumberFormats.convertToIdr(grosProfit.toString())}"),
                    'margin': PlutoCell(value: "${margin.toInt().toString()}%"),
                  },
                );
              }).toList(),
              onLoaded: (PlutoGridOnLoadedEvent event) {
                stateManager = event.stateManager;
                stateManager.setShowColumnFilter(false);
              },
              configuration: const PlutoGridConfiguration(),
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
                              "Sales",
                              style: GoogleFonts.playfairDisplay(
                                  fontSize: 30, fontWeight: FontWeight.w600),
                            ),
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
                              padding: const EdgeInsets.only(left: 20),
                              width: MediaQuery.of(context).size.width * 0.2,
                              height: 35,
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
                                      Map<String, dynamic> request = {
                                        "no_order": (orderId?.text != null)
                                            ? orderId!.text
                                            : " ",
                                        "tanggal": dateStr,
                                      };
                                      context.read<TransaksiBloc>().add(
                                          GetTransaksiDetailCategory(
                                              params: request));
                                    });
                                  }
                                },
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "tanggal",
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
                            Container(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 10),
                              width: MediaQuery.of(context).size.width * 0.21,
                              height: 35,
                              child: TextField(
                                controller: orderId,
                                minLines: 1,
                                keyboardType: TextInputType.text,
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
                                  Map<String, dynamic> request = {
                                    "no_order": (orderId?.text != null)
                                        ? orderId!.text
                                        : " ",
                                    "tanggal": tanggal!.text,
                                  };
                                  context.read<TransaksiBloc>().add(
                                      GetTransaksiDetailCategory(
                                          params: request));
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
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  child: const SidebarSales(type: 'category'),
                                ),
                                transaksi,
                              ],
                            ),
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
}

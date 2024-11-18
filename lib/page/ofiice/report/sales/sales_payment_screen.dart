import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:kasir_dekstop/bloc/transaksi/transaksi_bloc.dart';
import 'package:kasir_dekstop/helper/number_format.dart';
import 'package:kasir_dekstop/widget/bottom_nav.dart';
import 'package:kasir_dekstop/widget/sidebar.dart';
import 'package:kasir_dekstop/widget/sidebar_sales.dart';

class SalesPaymentScreen extends StatefulWidget {
  static String routeName = '/ofice/report/sales-payment';
  const SalesPaymentScreen({super.key});

  @override
  State<SalesPaymentScreen> createState() => _SalesPaymentScreenState();
}

class _SalesPaymentScreenState extends State<SalesPaymentScreen> {
  TextEditingController? tanggal;
  TextEditingController? orderId;
  DateTime? _date = DateTime.now();
  String today = DateTime.now().toIso8601String().substring(0, 10);
  @override
  void initState() {
    super.initState();
    context.read<TransaksiBloc>().add(GetTrans());
    tanggal = TextEditingController();
    orderId = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    tanggal!.dispose();
    orderId!.dispose();
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
          int subtotalCash = 0;
          int totalCash = 0;
          int subtotalGula = 0;
          int totalGula = 0;
          int subtotalKasbon = 0;
          int totalKasbon = 0;
          int total = 0;
          int subtotal = 0;
          for (var trans in state.transaksi) {
            if (trans.paymentType == 'Cash') {
              subtotalCash += 1;
              totalCash += int.parse(trans.totalHarga!);
            } else if (trans.paymentType == 'Gula') {
              subtotalGula += 1;
              totalGula += int.parse(trans.totalHarga!);
            } else {
              subtotalKasbon += 1;
              totalKasbon += int.parse(trans.totalHarga!);
            }
          }
          subtotal = subtotalCash + subtotalGula + subtotalKasbon;
          total = totalCash + totalGula + totalKasbon;
          return SizedBox(
            width: MediaQuery.of(context).size.width * 0.45,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DataTable(
                  headingRowColor: WidgetStateColor.resolveWith(
                    (states) =>
                        Colors.white, // Warna header dapat disesuaikan di sini
                  ),
                  columns: [
                    DataColumn(
                      label: ConstrainedBox(
                        constraints: const BoxConstraints(),
                        child: Text(
                          "Payment Methode",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.playfairDisplay(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                              color: const Color(0XFF000000)),
                        ),
                      ),
                    ),
                  ],
                  rows: [
                    DataRow(
                      color: WidgetStateProperty.all(Colors.white),
                      cells: [
                        DataCell(
                          ConstrainedBox(
                            constraints: const BoxConstraints(),
                            child: Text(
                              "Cash",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.play(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0XFF000000)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    DataRow(
                      color: WidgetStateProperty.all(Colors.white),
                      cells: [
                        DataCell(
                          ConstrainedBox(
                            constraints: const BoxConstraints(),
                            child: Text(
                              "Gula",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.playfairDisplay(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0XFF000000)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    DataRow(
                      color: WidgetStateProperty.all(Colors.white),
                      cells: [
                        DataCell(
                          ConstrainedBox(
                            constraints: const BoxConstraints(),
                            child: Text(
                              "Kasbon",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.playfairDisplay(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0XFF000000)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    DataRow(
                      color: WidgetStateProperty.all(Colors.white),
                      cells: [
                        DataCell(
                          ConstrainedBox(
                            constraints: const BoxConstraints(),
                            child: Text(
                              "Total",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.playfairDisplay(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0XFF000000)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Expanded(
                    child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor: WidgetStateColor.resolveWith(
                      (states) => Colors
                          .white, // Warna header dapat disesuaikan di sini
                    ),
                    columns: [
                      DataColumn(
                        label: ConstrainedBox(
                          constraints: const BoxConstraints(),
                          child: Text(
                            "Jumlah",
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
                            "Total",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.playfairDisplay(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                color: const Color(0XFF000000)),
                          ),
                        ),
                      ),
                    ],
                    rows: [
                      DataRow(
                        color: WidgetStateProperty.all(Colors.white),
                        cells: [
                          DataCell(
                            ConstrainedBox(
                              constraints: const BoxConstraints(),
                              child: Text(
                                "$subtotalCash",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.play(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0XFF000000)),
                              ),
                            ),
                          ),
                          DataCell(
                            ConstrainedBox(
                              constraints: const BoxConstraints(),
                              child: Text(
                                "Rp ${NumberFormats.convertToIdr(totalCash.toString())}",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.play(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0XFF000000)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      DataRow(
                        color: WidgetStateProperty.all(Colors.white),
                        cells: [
                          DataCell(
                            ConstrainedBox(
                              constraints: const BoxConstraints(),
                              child: Text(
                                "$subtotalGula",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.play(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0XFF000000)),
                              ),
                            ),
                          ),
                          DataCell(
                            ConstrainedBox(
                              constraints: const BoxConstraints(),
                              child: Text(
                                "Rp ${NumberFormats.convertToIdr(totalGula.toString())}",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.play(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0XFF000000)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      DataRow(
                        color: WidgetStateProperty.all(Colors.white),
                        cells: [
                          DataCell(
                            ConstrainedBox(
                              constraints: const BoxConstraints(),
                              child: Text(
                                "$subtotalKasbon",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.play(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0XFF000000)),
                              ),
                            ),
                          ),
                          DataCell(
                            ConstrainedBox(
                              constraints: const BoxConstraints(),
                              child: Text(
                                "Rp ${NumberFormats.convertToIdr(totalKasbon.toString())}",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.play(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0XFF000000)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      DataRow(
                        color: WidgetStateProperty.all(Colors.white),
                        cells: [
                          DataCell(
                            ConstrainedBox(
                              constraints: const BoxConstraints(),
                              child: Text(
                                "$subtotal",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.play(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0XFF000000)),
                              ),
                            ),
                          ),
                          DataCell(
                            ConstrainedBox(
                              constraints: const BoxConstraints(),
                              child: Text(
                                "Rp ${NumberFormats.convertToIdr(total.toString())}",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.play(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0XFF000000)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ))
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
                                        "cutomer_id": "",
                                      };
                                      context
                                          .read<TransaksiBloc>()
                                          .add(GetSearchTrans(params: request));
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
                                    "cutomer_id": "",
                                  };
                                  context
                                      .read<TransaksiBloc>()
                                      .add(GetSearchTrans(params: request));
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
                                  child: const SidebarSales(type: 'payment'),
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

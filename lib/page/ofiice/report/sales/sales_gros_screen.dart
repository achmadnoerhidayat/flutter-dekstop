import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:kasir_dekstop/bloc/transaksi/transaksi_bloc.dart';
import 'package:kasir_dekstop/helper/number_format.dart';
import 'package:kasir_dekstop/widget/bottom_nav.dart';
import 'package:kasir_dekstop/widget/sidebar.dart';
import 'package:kasir_dekstop/widget/sidebar_sales.dart';

class SalesGrosScreen extends StatefulWidget {
  static String routeName = '/ofice/report/sales-gros';
  const SalesGrosScreen({super.key});

  @override
  State<SalesGrosScreen> createState() => _SalesGrosScreenState();
}

class _SalesGrosScreenState extends State<SalesGrosScreen> {
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
          int subtotal = 0;
          int diskon = 0;
          double grosSugar = 0;
          double profitSugar = 0;
          int modalTrans = 0;
          int total = 0;
          double profitTrans = 0;
          double profit = 0;
          double totalWeigh = 0;
          for (var trans in state.transaksi) {
            if (trans.weightGula != null && trans.priceBeliGula != null) {
              double beli = double.parse(trans.weightGula!) *
                  double.parse(trans.priceBeliGula!);
              double jual = double.parse(trans.weightGula!) *
                  double.parse(trans.priceJualGula!);
              profitSugar += jual - beli;
              grosSugar += beli;
              totalWeigh += double.parse(trans.weightGula!);
            }
            total += int.parse(trans.totalHarga!);
            for (var det in trans.detail!) {
              double jum =
                  double.parse(det.hargaProduct!) * double.parse(det.qty!);
              double modal =
                  double.parse(det.hargaModal!) * double.parse(det.qty!);
              subtotal += jum.toInt();
              modalTrans += modal.toInt();
              if (det.totalDiskon != null) {
                diskon += int.parse(det.totalDiskon!);
              }
            }
          }
          profitTrans = total.toDouble() - modalTrans.toDouble();
          profit = total.toDouble() - modalTrans.toDouble() + profitSugar;
          return SizedBox(
            width: MediaQuery.of(context).size.width * 0.45,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Gros Sales",
                        style: GoogleFonts.playfairDisplay(
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF9C9797)),
                      ),
                      Text(
                        "Rp ${NumberFormats.convertToIdr(subtotal.toString())}",
                        style: GoogleFonts.play(
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF9C9797)),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Gros Sugar",
                        style: GoogleFonts.playfairDisplay(
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF9C9797)),
                      ),
                      Text(
                        "Rp ${NumberFormats.convertToIdr(grosSugar.toInt().toString())}",
                        style: GoogleFonts.play(
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF9C9797)),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Discount",
                        style: GoogleFonts.playfairDisplay(
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF9C9797)),
                      ),
                      Text(
                        "(Rp ${NumberFormats.convertToIdr(diskon.toString())})",
                        style: GoogleFonts.play(
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF9C9797)),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total Sales",
                        style: GoogleFonts.playfairDisplay(
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF9C9797)),
                      ),
                      Text(
                        "Rp ${NumberFormats.convertToIdr(total.toString())}",
                        style: GoogleFonts.play(
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF9C9797)),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Modal Awal",
                        style: GoogleFonts.playfairDisplay(
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF9C9797)),
                      ),
                      Text(
                        "Rp 0",
                        style: GoogleFonts.play(
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF9C9797)),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Sugar Weight Tracker",
                        style: GoogleFonts.playfairDisplay(
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF9C9797)),
                      ),
                      Text(
                        totalWeigh.toStringAsFixed(1).toString(),
                        style: GoogleFonts.play(
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF9C9797)),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Gros Profit Sugar",
                        style: GoogleFonts.playfairDisplay(
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF9C9797)),
                      ),
                      Text(
                        "Rp ${NumberFormats.convertToIdr(profitSugar.toInt().toString())}",
                        style: GoogleFonts.play(
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF9C9797)),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Gros Profit Transaksi",
                        style: GoogleFonts.playfairDisplay(
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF9C9797)),
                      ),
                      Text(
                        "Rp ${NumberFormats.convertToIdr(profitTrans.toInt().toString())}",
                        style: GoogleFonts.play(
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF9C9797)),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Gros Profit",
                        style: GoogleFonts.playfairDisplay(
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF9C9797)),
                      ),
                      Text(
                        "Rp ${NumberFormats.convertToIdr(profit.toInt().toString())}",
                        style: GoogleFonts.play(
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF9C9797)),
                      ),
                    ],
                  ),
                ),
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
                                  child: const SidebarSales(type: 'gros'),
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

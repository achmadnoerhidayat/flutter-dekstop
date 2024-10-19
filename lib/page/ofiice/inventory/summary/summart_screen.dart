import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:kasir_dekstop/bloc/order/order_bloc.dart';
import 'package:kasir_dekstop/widget/bottom_nav.dart';
import 'package:kasir_dekstop/widget/sidebar.dart';

class SummaryScreen extends StatefulWidget {
  static String routeName = '/ofice/summary';
  const SummaryScreen({super.key});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  TextEditingController? tanggal;
  DateTime? _date = DateTime.now();
  String today = DateTime.now().toIso8601String().substring(0, 10);
  @override
  void initState() {
    context.read<OrderBloc>().add(GetOrderDetail(date: today));
    tanggal = TextEditingController();
    tanggal!.text = DateFormat("yyyy-MM-dd").format(_date!).toString();
    super.initState();
  }

  @override
  void dispose() {
    tanggal!.dispose();
    super.dispose();
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
    final order = BlocBuilder<OrderBloc, OrderState>(
      builder: (context, state) {
        if (state is OrderDetailSucces) {
          return SizedBox(
            width: MediaQuery.of(context).size.width * 0.45,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                DataTable(
                  border: TableBorder.all(width: 0, color: Colors.white),
                  showCheckboxColumn: false,
                  headingRowColor: WidgetStateColor.resolveWith(
                      (states) => const Color(0xFFC2BEBE)),
                  columns: [
                    DataColumn(
                      label: ConstrainedBox(
                        constraints: const BoxConstraints(minWidth: 150),
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
                  ],
                  rows: state.orderDetail.map((e) {
                    return DataRow(
                      color: WidgetStateProperty.all(Colors.white),
                      cells: [
                        DataCell(
                          ConstrainedBox(
                            constraints: const BoxConstraints(),
                            child: Text(
                              e.product!.namaBarang,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.play(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0XFF000000)),
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      border: TableBorder.all(width: 0, color: Colors.white),
                      showCheckboxColumn: false,
                      headingRowColor: WidgetStateColor.resolveWith(
                          (states) => const Color(0xFFC2BEBE)),
                      columns: [
                        DataColumn(
                          label: ConstrainedBox(
                            constraints: const BoxConstraints(minWidth: 150),
                            child: Text(
                              "Category",
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
                              "Begining",
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
                            constraints: const BoxConstraints(minWidth: 100),
                            child: Text(
                              "Purchase Order",
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
                            constraints: const BoxConstraints(minWidth: 100),
                            child: Text(
                              "Sales",
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
                              "Transfer",
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
                            constraints: const BoxConstraints(maxWidth: 80),
                            child: Text(
                              "Ending",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.playfairDisplay(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0XFF000000)),
                            ),
                          ),
                        ),
                      ],
                      rows: state.orderDetail.map((e) {
                        int begining =
                            int.parse(e.product!.stock) - int.parse(e.qty!);
                        return DataRow(
                          color: WidgetStateProperty.all(Colors.white),
                          cells: [
                            DataCell(
                              ConstrainedBox(
                                constraints: const BoxConstraints(),
                                child: Text(
                                  e.product!.categori!.nama!,
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
                                  begining.toString(),
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
                                  e.qty!,
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
                                  (e.orderDetail != null)
                                      ? e.orderDetail!.qty!
                                      : "",
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
                                constraints: const BoxConstraints(maxWidth: 80),
                                child: Text(
                                  "0",
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
                                constraints: const BoxConstraints(maxWidth: 80),
                                child: Text(
                                  e.product!.stock,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.play(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0XFF000000)),
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return Container(
          height: 380,
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
                        padding: const EdgeInsets.only(
                            left: 20, top: 15, right: 30, bottom: 30),
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Text(
                          "Summary",
                          style: GoogleFonts.playfairDisplay(
                              fontSize: 30, fontWeight: FontWeight.w600),
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
                                      context
                                          .read<OrderBloc>()
                                          .add(GetOrderDetail(date: dateStr));
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
                              child: const TextField(
                                minLines: 1,
                                keyboardType: TextInputType.text,
                                maxLines: null,
                                readOnly: false,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "Search",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 10),
                                  isDense: true,
                                ),
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.1,
                              child: ElevatedButton(
                                onPressed: () {
                                  context
                                      .read<OrderBloc>()
                                      .add(GetOrder(date: tanggal!.text));
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
                            padding: const EdgeInsets.only(
                                top: 10, left: 20, right: 20),
                            child: order,
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

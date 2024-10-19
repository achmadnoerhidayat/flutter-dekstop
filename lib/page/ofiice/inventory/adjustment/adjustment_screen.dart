import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kasir_dekstop/helper/number_format.dart';
import 'package:kasir_dekstop/widget/sidebar.dart';
import 'package:kasir_dekstop/widget/bottom_nav.dart';
import 'package:kasir_dekstop/bloc/adjustment/adjustment_bloc.dart';
import 'package:kasir_dekstop/page/ofiice/inventory/adjustment/widget/form_adjustment.dart';

class AdjustmentScreen extends StatefulWidget {
  static String routeName = '/ofice/adjustment';
  const AdjustmentScreen({super.key});

  @override
  State<AdjustmentScreen> createState() => _AdjustmentScreenState();
}

class _AdjustmentScreenState extends State<AdjustmentScreen> {
  bool add = false;
  TextEditingController? tanggal;
  DateTime? _date = DateTime.now();
  String today = DateTime.now().toIso8601String().substring(0, 10);
  void updateStatus(bool newValue) {
    setState(() {
      add = newValue;
    });
  }

  @override
  void initState() {
    tanggal = TextEditingController();
    tanggal!.text = DateFormat("yyyy-MM-dd").format(_date!).toString();
    context.read<AdjustmentBloc>().add(ShowAdjustmentDetail(date: today));
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

    final adjustment = BlocBuilder<AdjustmentBloc, AdjustmentState>(
      builder: (context, state) {
        if (state is ShowAdjustmentSuccess) {
          return SizedBox(
            width: MediaQuery.of(context).size.width * 0.45,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black12, width: .5),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      SizedBox(
                        child: Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .15,
                              child: Column(
                                children: [
                                  Text(
                                    state.totalAdj.toString(),
                                    style: GoogleFonts.play(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xFF252424)),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    "ADJUSTMENT",
                                    style: GoogleFonts.playfairDisplay(
                                        fontSize: 14,
                                        color: const Color(0xFF584E4E)),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .15,
                              child: Column(
                                children: [
                                  Text(
                                    state.totalItem.toString(),
                                    style: GoogleFonts.play(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xFF252424)),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    "ITEM ADJUSTMENT",
                                    style: GoogleFonts.playfairDisplay(
                                      fontSize: 14,
                                      color: const Color(0xFF584E4E),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        child: Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .22,
                              child: Column(
                                children: [
                                  Text(
                                    "Rp ${NumberFormats.convertToIdr(state.totalExpen.toString())}",
                                    style: GoogleFonts.play(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xFF252424)),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    "TOTAL ADJUSTMENT EXPENSE",
                                    style: GoogleFonts.play(
                                        fontSize: 14,
                                        color: const Color(0xFF584E4E)),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .22,
                              child: Column(
                                children: [
                                  Text(
                                    state.totalIncome.toString(),
                                    style: GoogleFonts.play(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xFF252424)),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    "TOTAL ADJUSTMENT INCOME",
                                    style: GoogleFonts.playfairDisplay(
                                      fontSize: 14,
                                      color: const Color(0xFF584E4E),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
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
                              "Date",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.playfairDisplay(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0XFF000000)),
                            ),
                          ),
                        ),
                      ],
                      rows: state.adjustment.map((e) {
                        return DataRow(
                          color: WidgetStateProperty.all(Colors.white),
                          cells: [
                            DataCell(
                              ConstrainedBox(
                                constraints: const BoxConstraints(),
                                child: Text(
                                  NumberFormats.getFormatDay(
                                      DateTime.parse(e.created!)),
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
                          border:
                              TableBorder.all(width: 0, color: Colors.white),
                          showCheckboxColumn: false,
                          headingRowColor: WidgetStateColor.resolveWith(
                              (states) => const Color(0xFFC2BEBE)),
                          columns: [
                            DataColumn(
                              label: ConstrainedBox(
                                constraints:
                                    const BoxConstraints(minWidth: 150),
                                child: Text(
                                  "Note",
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
                                  "Items",
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
                                constraints:
                                    const BoxConstraints(minWidth: 100),
                                child: Text(
                                  "Adjustment",
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
                                  "Expense/Income",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.playfairDisplay(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0XFF000000)),
                                ),
                              ),
                            ),
                          ],
                          rows: state.adjustment.map((e) {
                            int expense = int.parse(e.hargaModal!) *
                                int.parse(e.adjustment!);
                            return DataRow(
                              color: WidgetStateProperty.all(Colors.white),
                              cells: [
                                DataCell(
                                  ConstrainedBox(
                                    constraints: const BoxConstraints(),
                                    child: Text(
                                      e.adjustmentModel!.note!,
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
                                      e.product!.namaBarang,
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
                                      "-${e.adjustment!}",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.play(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400,
                                          color: const Color(0xFFE71212)),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  ConstrainedBox(
                                    constraints: const BoxConstraints(),
                                    child: Text(
                                      "Rp ${NumberFormats.convertToIdr(expense.toString())}",
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
                    (add)
                        ? FormAdjustment(add: add, onToggle: updateStatus)
                        : const SizedBox.shrink()
                  ],
                ),
              ],
            ),
          );
        }
        return SizedBox(
          width: MediaQuery.of(context).size.width * 0.45,
          height: 500,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.45,
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'asset/not_found.png',
                        height: 200,
                      ),
                      const Text(
                        "Data Tidak Ditemukan Silahkan Order Barang",
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              (add)
                  ? FormAdjustment(add: add, onToggle: updateStatus)
                  : const SizedBox.shrink()
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Adjustment",
                              style: GoogleFonts.playfairDisplay(
                                  fontSize: 30, fontWeight: FontWeight.w600),
                            ),
                            Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
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
                                    updateStatus(true);
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
                            // suplier,
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
                                  fontSize: 14.0,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 20),
                              width: MediaQuery.of(context).size.width * 0.1,
                              child: ElevatedButton(
                                onPressed: () {
                                  context.read<AdjustmentBloc>().add(
                                      ShowAdjustmentDetail(
                                          date: tanggal!.text));
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
                            child: adjustment,
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

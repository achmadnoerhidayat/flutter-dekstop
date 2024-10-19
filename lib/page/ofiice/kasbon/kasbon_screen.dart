import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kasir_dekstop/bloc/deb_watch/deb_watch_bloc.dart';
import 'package:kasir_dekstop/helper/number_format.dart';
import 'package:kasir_dekstop/models/debt_watch_model.dart';
import 'package:kasir_dekstop/page/ofiice/kasbon/widget/form_debt_watch.dart';
import 'package:kasir_dekstop/page/ofiice/kasbon/widget/form_detail_watch.dart';
import 'package:kasir_dekstop/widget/bottom_nav.dart';
import 'package:kasir_dekstop/widget/sidebar.dart';

class KasbonScreen extends StatefulWidget {
  static String routeName = '/ofice/kasbon';
  const KasbonScreen({super.key});

  @override
  State<KasbonScreen> createState() => _KasbonScreenState();
}

class _KasbonScreenState extends State<KasbonScreen> {
  TextEditingController? txtNama;
  @override
  void initState() {
    super.initState();
    context.read<DebWatchBloc>().add(GetDebtWatch());
    txtNama = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    txtNama!.dispose();
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

    final debt = BlocBuilder<DebWatchBloc, DebWatchState>(
      builder: (context, state) {
        if (state is DebWatchSuccess) {
          return DataTable(
            border: TableBorder.all(width: 0, color: Colors.white),
            showCheckboxColumn: false,
            headingRowColor: WidgetStateColor.resolveWith(
                (states) => const Color(0xFFC2BEBE)),
            columns: [
              DataColumn(
                label: ConstrainedBox(
                  constraints: const BoxConstraints(),
                  child: Text(
                    "Nama Customer",
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
                    "Jumlah Kasbon",
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
                    "Status",
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
                    "Aksi",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.playfairDisplay(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: const Color(0XFF000000)),
                  ),
                ),
              ),
            ],
            rows: state.watch.map((e) {
              return DataRow(
                color: WidgetStateProperty.all(Colors.white),
                cells: [
                  DataCell(
                    ConstrainedBox(
                      constraints: const BoxConstraints(),
                      child: Text(
                        "${e.customerModel!.nama}",
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
                        "Rp ${NumberFormats.convertToIdr(e.nominal!)}",
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
                        e.status!,
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
                      constraints: const BoxConstraints(maxWidth: 160),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              modalShowDebt(context, e);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                  color: Colors.amber,
                                  borderRadius: BorderRadius.circular(20)),
                              child: const Icon(
                                Icons.remove_red_eye,
                                color: Colors.white,
                                size: 15,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              modalAddDetail(context, e);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                  color: Colors.lightBlue,
                                  borderRadius: BorderRadius.circular(20)),
                              child: const Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 15,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              modalEdit(context, e);
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
                                        BlocConsumer<DebWatchBloc,
                                            DebWatchState>(
                                          listener: (context, states) {
                                            if (states
                                                is RequestDebWatchSuccess) {
                                              Navigator.of(context).pop();
                                            }
                                          },
                                          builder: (context, states) {
                                            if (states is DebWatchLoading) {
                                              return ElevatedButton(
                                                onPressed: () {},
                                                style: ElevatedButton.styleFrom(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    fixedSize:
                                                        const Size(70, 40),
                                                    backgroundColor:
                                                        const Color(
                                                            0XFF2334A6)),
                                                child: Text(
                                                  "Ya",
                                                  style: GoogleFonts
                                                      .playfairDisplay(
                                                          color: const Color(
                                                              0XFFFFFFFF),
                                                          fontSize: 20),
                                                ),
                                              );
                                            }
                                            return ElevatedButton(
                                              onPressed: () {
                                                context
                                                    .read<DebWatchBloc>()
                                                    .add(DeleteDebtWatch(
                                                        id: e.id!));
                                                context
                                                    .read<DebWatchBloc>()
                                                    .add(GetDebtWatch());
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
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
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          );
        }
        return DataTable(
          border: TableBorder.all(width: 0, color: Colors.white),
          showCheckboxColumn: false,
          headingRowColor:
              WidgetStateColor.resolveWith((states) => const Color(0xFFC2BEBE)),
          columns: [
            DataColumn(
              label: ConstrainedBox(
                constraints: const BoxConstraints(),
                child: Text(
                  "Nama Customer",
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
                  "Jumlah Hutang",
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
                  "Status",
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
                  "Aksi",
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
                  ),
                ),
                DataCell(
                  ConstrainedBox(
                    constraints: const BoxConstraints(),
                    child: const Center(
                      child: Text("Data Tidak Ditemukan"),
                    ),
                  ),
                ),
                DataCell(
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 80),
                  ),
                ),
                DataCell(
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 80),
                  ),
                ),
              ],
            )
          ],
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
                              "Daily Debt Watch / Kasbon",
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
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 20.0, bottom: 10),
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.56,
                              child: TextField(
                                controller: txtNama,
                                minLines: 1,
                                keyboardType: TextInputType.text,
                                maxLines: null,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "Search Nama Customer",
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
                              child: ElevatedButton(
                                onPressed: () {
                                  context.read<DebWatchBloc>().add(
                                      SearchDebtWatch(name: txtNama!.text));
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
                          scrollDirection: Axis.vertical,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            padding: const EdgeInsets.all(20.0),
                            child: debt,
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

  Future<dynamic> modalAdd(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            height: MediaQuery.of(context).size.height * 0.6,
            child: const FormDebtWatch(),
          ),
        );
      },
    );
  }

  Future<dynamic> modalEdit(BuildContext context, DebtWatchModel debt) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            height: MediaQuery.of(context).size.height * 0.6,
            child: FormDebtWatch(watchModel: debt),
          ),
        );
      },
    );
  }

  Future<dynamic> modalAddDetail(BuildContext context, DebtWatchModel debt) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            height: MediaQuery.of(context).size.height * 0.6,
            child: FormDetailWatch(debtSugarModel: debt),
          ),
        );
      },
    );
  }

  Future<dynamic> modalShowDebt(BuildContext context, DebtWatchModel debt) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            height: MediaQuery.of(context).size.height * 0.6,
            child: ListView(
              children: [
                Container(
                  height: 60,
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: const Color(0xFFFAF5F5))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // txtNama!.clear();
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            fixedSize: const Size(120, 40),
                            backgroundColor: const Color(0XFFFFFFFF)),
                        child: Text(
                          "Cancel",
                          style: GoogleFonts.playfairDisplay(
                              color: const Color(0XFF2334A6), fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Detail Sugar Debt",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Nama Customer",
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                    ),
                    Text(
                      debt.customerModel!.nama!,
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 20),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Jumlah Hutang",
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                    ),
                    Text(
                      "Rp ${NumberFormats.convertToIdr(debt.nominal!)}",
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 20),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                DataTable(
                  border: TableBorder.all(width: 0, color: Colors.white),
                  showCheckboxColumn: false,
                  headingRowColor: WidgetStateColor.resolveWith(
                      (states) => const Color(0xFFC2BEBE)),
                  columns: [
                    DataColumn(
                      label: ConstrainedBox(
                        constraints: const BoxConstraints(),
                        child: Text(
                          "Type",
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
                        constraints: const BoxConstraints(maxWidth: 80),
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
                        constraints: const BoxConstraints(maxWidth: 80),
                        child: Text(
                          "Tanggal",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.playfairDisplay(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                              color: const Color(0XFF000000)),
                        ),
                      ),
                    ),
                  ],
                  rows: debt.kasbonDetail!.map((e) {
                    return DataRow(
                      color: WidgetStateProperty.all(Colors.white),
                      cells: [
                        DataCell(
                          ConstrainedBox(
                            constraints: const BoxConstraints(),
                            child: Text(
                              "${e.type}",
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
                              "Rp ${NumberFormats.convertToIdr(e.nominal!)}",
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
                              constraints: const BoxConstraints(maxWidth: 145),
                              child: Text(
                                "${e.note}",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.play(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0XFF000000)),
                              )),
                        ),
                        DataCell(
                          ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 200),
                              child: Text(
                                NumberFormats.getFormattedDate(
                                    DateTime.parse(e.created!)),
                                style: GoogleFonts.play(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0XFF000000)),
                              )),
                        ),
                      ],
                    );
                  }).toList(),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

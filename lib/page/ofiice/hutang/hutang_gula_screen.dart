import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kasir_dekstop/bloc/debt_sugar/debt_sugar_bloc.dart';
import 'package:kasir_dekstop/helper/number_format.dart';
import 'package:kasir_dekstop/models/debt_sugar_model.dart';
import 'package:kasir_dekstop/page/ofiice/hutang/widget/form_debt_sugar.dart';
import 'package:kasir_dekstop/page/ofiice/hutang/widget/form_detail_sugar.dart';
import 'package:kasir_dekstop/widget/bottom_nav.dart';
import 'package:kasir_dekstop/widget/sidebar.dart';

class HutangGulaScreen extends StatefulWidget {
  static String routeName = '/ofice/hutang-gula';
  const HutangGulaScreen({super.key});

  @override
  State<HutangGulaScreen> createState() => _HutangGulaScreenState();
}

class _HutangGulaScreenState extends State<HutangGulaScreen> {
  TextEditingController? txtNama;
  @override
  void initState() {
    super.initState();
    context.read<DebtSugarBloc>().add(GetDebtSugar());
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

    final debt = BlocBuilder<DebtSugarBloc, DebtSugarState>(
      builder: (context, state) {
        if (state is DebtSugarSuccess) {
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
            rows: state.debtModel.map((e) {
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
                                        BlocConsumer<DebtSugarBloc,
                                            DebtSugarState>(
                                          listener: (context, states) {
                                            if (states is RequestDebtSuccess) {
                                              Navigator.of(context).pop();
                                            }
                                          },
                                          builder: (context, states) {
                                            if (states is DebtSugarLoading) {
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
                                                    .read<DebtSugarBloc>()
                                                    .add(DeleteDebtSugar(
                                                        id: e.id!));
                                                context
                                                    .read<DebtSugarBloc>()
                                                    .add(GetDebtSugar());
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
                        padding: const EdgeInsets.all(30),
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Sugar Debt Monitor",
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
                                  context.read<DebtSugarBloc>().add(
                                      SearchDebtSugar(nama: txtNama!.text));
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
            child: const FormDebtSugar(),
          ),
        );
      },
    );
  }

  Future<dynamic> modalEdit(BuildContext context, DebtSugarModel debt) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            height: MediaQuery.of(context).size.height * 0.6,
            child: FormDebtSugar(sugarModel: debt),
          ),
        );
      },
    );
  }

  Future<dynamic> modalAddDetail(BuildContext context, DebtSugarModel debt) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            height: MediaQuery.of(context).size.height * 0.6,
            child: FormDetailSugar(debtSugarModel: debt),
          ),
        );
      },
    );
  }

  Future<dynamic> modalShowDebt(BuildContext context, DebtSugarModel debt) {
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
                  rows: debt.sugarDetail!.map((e) {
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

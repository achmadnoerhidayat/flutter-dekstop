import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kasir_dekstop/bloc/promo/promo_bloc.dart';
import 'package:kasir_dekstop/page/ofiice/promo/add_promo.dart';
import 'package:kasir_dekstop/widget/bottom_nav.dart';
import 'package:kasir_dekstop/widget/sidebar.dart';

class PromoScreen extends StatefulWidget {
  static String routeName = '/ofice/promo';
  const PromoScreen({super.key});

  @override
  State<PromoScreen> createState() => _PromoScreenState();
}

class _PromoScreenState extends State<PromoScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PromoBloc>().add(GetPromo());
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
    final promo = BlocBuilder<PromoBloc, PromoState>(
      builder: (context, state) {
        if (state is PromoLoading) {
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
                    "No",
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
                    "Judul",
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
                        child: CircularProgressIndicator(),
                      ),
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
        }
        if (state is PromoSuccess) {
          return Row(
            children: [
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
                        "No",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.playfairDisplay(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            color: const Color(0XFF000000)),
                      ),
                    ),
                  ),
                ],
                rows: state.promo.map((e) {
                  int no = state.promo.indexOf(e);
                  no = no + 1;
                  return DataRow(
                    color: WidgetStateProperty.all(Colors.white),
                    cells: [
                      DataCell(
                        ConstrainedBox(
                          constraints: const BoxConstraints(),
                          child: Text(
                            "$no",
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
                          constraints: const BoxConstraints(),
                          child: Text(
                            "Judul",
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
                            "Tgl Mulai",
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
                            "Tgl Berakhir",
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
                    rows: state.promo.map((e) {
                      return DataRow(
                        color: WidgetStateProperty.all(Colors.white),
                        cells: [
                          DataCell(
                            ConstrainedBox(
                              constraints: const BoxConstraints(),
                              child: Text(
                                "${e.judul}",
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
                                e.promoMulai!,
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
                                e.promoBerakhir!,
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
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
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
                                                BlocConsumer<PromoBloc,
                                                    PromoState>(
                                                  listener: (context, states) {
                                                    if (states
                                                        is RequestPromoSuccess) {
                                                      Navigator.of(context)
                                                          .pop();
                                                    }
                                                  },
                                                  builder: (context, states) {
                                                    if (states
                                                        is PromoLoading) {
                                                      return ElevatedButton(
                                                        onPressed: () {},
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
                                                                        70, 40),
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
                                                        int id = int.parse(
                                                            "${e.id}");
                                                        context
                                                            .read<PromoBloc>()
                                                            .add(DeletePromo(
                                                                id: id));
                                                        context
                                                            .read<PromoBloc>()
                                                            .add(GetPromo());
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
                                                                      70, 40),
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
                                                  },
                                                ),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                          fixedSize: const Size(
                                                              100, 40),
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
                                          borderRadius:
                                              BorderRadius.circular(20)),
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
                  ),
                ),
              )
            ],
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
                  "No",
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
                  "Judul",
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
                  "Tgl Mulai",
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
                  "Tgl Berakhir",
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
                              "Promo",
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
                                    context.push(AddPromo.routeName);
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
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            padding: const EdgeInsets.all(20.0),
                            child: promo,
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

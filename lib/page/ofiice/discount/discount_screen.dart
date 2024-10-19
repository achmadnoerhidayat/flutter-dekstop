import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kasir_dekstop/bloc/discount/discount_bloc.dart';
import 'package:kasir_dekstop/helper/number_format.dart';
import 'package:kasir_dekstop/models/discount_model.dart';
import 'package:kasir_dekstop/page/ofiice/discount/widget/add_discount.dart';
import 'package:kasir_dekstop/page/ofiice/discount/widget/edit_discount.dart';
import 'package:kasir_dekstop/widget/bottom_nav.dart';
import 'package:kasir_dekstop/widget/sidebar.dart';

class DiscountScreen extends StatefulWidget {
  static String routeName = '/ofice/discount';
  const DiscountScreen({super.key});

  @override
  State<DiscountScreen> createState() => _DiscountScreenState();
}

class _DiscountScreenState extends State<DiscountScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DiscountBloc>().add(GetDiscount());
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

    final discount = BlocBuilder<DiscountBloc, DiscountState>(
      builder: (context, state) {
        if (state is DiscountLoading) {
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
                    "Nama Discount",
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
                    "Harga Discount",
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
        if (state is DiscountSuccess) {
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
                    "Nama Discount",
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
                    "Harga Discount",
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
            rows: state.discount.map((e) {
              return DataRow(
                color: WidgetStateProperty.all(Colors.white),
                cells: [
                  DataCell(
                    ConstrainedBox(
                      constraints: const BoxConstraints(),
                      child: Text(
                        "${e.nama}",
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
                      child: (e.type == 'persen')
                          ? Text(
                              "${e.jumlah} %",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.play(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0XFF000000)),
                            )
                          : Text(
                              "Rp ${NumberFormats.convertToIdr(e.jumlah!)}",
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
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
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
                                        BlocConsumer<DiscountBloc,
                                            DiscountState>(
                                          listener: (context, states) {
                                            if (states
                                                is RequestDiscountSuccess) {
                                              Navigator.of(context).pop();
                                            }
                                          },
                                          builder: (context, states) {
                                            if (states is DiscountLoading) {
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
                                                int id = int.parse("${e.id}");
                                                context
                                                    .read<DiscountBloc>()
                                                    .add(
                                                        DeleteDiscount(id: id));
                                                context
                                                    .read<DiscountBloc>()
                                                    .add(GetDiscount());
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
                  "Nama Discount",
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
                  "Harga Discount",
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
                              "Discount",
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
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            padding: const EdgeInsets.all(20.0),
                            child: discount,
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
            height: MediaQuery.of(context).size.height * 0.4,
            child: const AddDiscount(),
          ),
        );
      },
    );
  }

  Future<dynamic> modalEdit(BuildContext context, DiscountModel discount) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            height: MediaQuery.of(context).size.height * 0.4,
            child: EditDiscount(model: discount),
          ),
        );
      },
    );
  }
}

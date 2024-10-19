import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:kasir_dekstop/bloc/order/order_bloc.dart';
import 'package:kasir_dekstop/bloc/suplier/suplier_bloc.dart';
import 'package:kasir_dekstop/helper/number_format.dart';
import 'package:kasir_dekstop/models/order_model.dart';
import 'package:kasir_dekstop/page/ofiice/inventory/order/widget/add_order.dart';
import 'package:kasir_dekstop/page/ofiice/inventory/order/widget/edit_order.dart';
import 'package:kasir_dekstop/widget/bottom_nav.dart';
import 'package:kasir_dekstop/widget/sidebar.dart';

class OrderScreen extends StatefulWidget {
  static String routeName = '/ofice/order';
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  bool add = false;
  SingleValueDropDownController? txtSuplier;
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
    context.read<OrderBloc>().add(GetOrder(date: today));
    context.read<SuplierBloc>().add(GetSuplier());
    txtSuplier = SingleValueDropDownController();
    tanggal = TextEditingController();
    tanggal!.text = DateFormat("yyyy-MM-dd").format(_date!).toString();
    super.initState();
  }

  @override
  void dispose() {
    txtSuplier!.dispose();
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

    final discount = BlocBuilder<OrderBloc, OrderState>(
      builder: (context, state) {
        if (state is OrderSuccess) {
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
                          "No Faktur",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.playfairDisplay(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                              color: const Color(0XFF000000)),
                        ),
                      ),
                    ),
                  ],
                  rows: state.order.map((e) {
                    return DataRow(
                      color: WidgetStateProperty.all(Colors.white),
                      cells: [
                        DataCell(
                          ConstrainedBox(
                            constraints: const BoxConstraints(),
                            child: Text(
                              "${e.noFaktur}",
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
                              "Subtotal",
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
                            constraints: const BoxConstraints(minWidth: 100),
                            child: Text(
                              "Suplier",
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
                              "Date",
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
                      rows: state.order.map((e) {
                        return DataRow(
                          color: WidgetStateProperty.all(Colors.white),
                          cells: [
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
                                  (e.status == "1") ? "Lunas" : "Hutang",
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
                                  (e.idSuplier == null)
                                      ? "Tidak Ada Supplier"
                                      : e.suplier!.name!,
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
                                  NumberFormats.getFormattedDate(
                                      DateTime.parse(e.created!)),
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
                                    (e.status == "2")
                                        ? InkWell(
                                            onTap: () {
                                              modalEdit(context, e);
                                              // txtStatus!.text = e.status!;
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(5),
                                              width: 30,
                                              height: 30,
                                              margin: const EdgeInsets.only(
                                                  right: 10),
                                              decoration: BoxDecoration(
                                                  color: Colors.blue,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              child: const Icon(
                                                Icons.edit_outlined,
                                                color: Colors.white,
                                                size: 15,
                                              ),
                                            ),
                                          )
                                        : Container(),
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
                                                  BlocConsumer<OrderBloc,
                                                      OrderState>(
                                                    listener:
                                                        (context, states) {
                                                      if (states
                                                          is RequestOrderSuccess) {
                                                        Navigator.of(context)
                                                            .pop();
                                                      }
                                                    },
                                                    builder: (context, states) {
                                                      if (states
                                                          is OrderLoading) {
                                                        return ElevatedButton(
                                                          onPressed: () {},
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                  ),
                                                                  fixedSize:
                                                                      const Size(
                                                                          70,
                                                                          40),
                                                                  backgroundColor:
                                                                      const Color(
                                                                          0XFF2334A6)),
                                                          child: Text(
                                                            "Ya",
                                                            style: GoogleFonts
                                                                .playfairDisplay(
                                                                    color: const Color(
                                                                        0XFFFFFFFF),
                                                                    fontSize:
                                                                        20),
                                                          ),
                                                        );
                                                      }
                                                      return ElevatedButton(
                                                        onPressed: () {
                                                          context
                                                              .read<OrderBloc>()
                                                              .add(DeleteOrder(
                                                                  id: e.id!));
                                                          context
                                                              .read<OrderBloc>()
                                                              .add(GetOrder(
                                                                  date: today));
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
                                                      Navigator.of(context)
                                                          .pop();
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
                ),
                (add)
                    ? AddOrder(add: add, onToggle: updateStatus)
                    : const SizedBox.shrink()
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
                  ? AddOrder(add: add, onToggle: updateStatus)
                  : const SizedBox.shrink()
            ],
          ),
        );
      },
    );

    final suplier = BlocBuilder<SuplierBloc, SuplierState>(
      builder: (context, state) {
        if (state is SuplierSuccess) {
          return Container(
            padding: const EdgeInsets.only(left: 2),
            width: MediaQuery.of(context).size.width * 0.2,
            height: 40,
            child: DropDownTextField(
              controller: txtSuplier,
              clearOption: true,
              enableSearch: true,
              clearIconProperty: IconProperty(color: Colors.green),
              searchTextStyle: const TextStyle(color: Colors.red),
              searchDecoration:
                  const InputDecoration(hintText: "Search Suplier"),
              dropDownItemCount: 6,
              dropDownList: state.suplier.map((e) {
                return DropDownValueModel(name: e.name!, value: e.name!);
              }).toList(),
              onChanged: (value) {
                if (value is DropDownValueModel) {
                  context
                      .read<OrderBloc>()
                      .add(GetOrderSuplier(suplier: value.value));
                } else {
                  // Handle jika nilai tidak sesuai dengan yang diharapkan
                }
              },
            ),
          );
        }
        return Container();
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
                              "Purchase Order (PO)",
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
                            const EdgeInsets.only(top: 15, left: 25, right: 35),
                        child: Row(
                          children: [
                            suplier,
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
                              padding: const EdgeInsets.only(left: 20),
                              margin: const EdgeInsets.only(right: 5),
                              width: MediaQuery.of(context).size.width * 0.21,
                              height: 35,
                              child: const TextField(
                                minLines: 1,
                                keyboardType: TextInputType.text,
                                maxLines: null,
                                readOnly: true,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "Search",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 10),
                                  isDense: true,
                                ),
                                style: TextStyle(
                                  fontSize: 14.0,
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

  Future<dynamic> modalEdit(BuildContext context, OrderModel order) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            height: MediaQuery.of(context).size.height * 0.35,
            child: EditOrder(order: order),
          ),
        );
      },
    );
  }
}

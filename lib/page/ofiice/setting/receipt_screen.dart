import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kasir_dekstop/bloc/receipt/receipt_bloc.dart';
import 'package:kasir_dekstop/helper/number_format.dart';
import 'package:kasir_dekstop/models/receipt_model.dart';
import 'package:kasir_dekstop/widget/bottom_nav.dart';
import 'package:kasir_dekstop/widget/sidebar.dart';

class ReceiptScreen extends StatefulWidget {
  static String routeName = '/ofice/receipt';
  const ReceiptScreen({super.key});

  @override
  State<ReceiptScreen> createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {
  final formState = GlobalKey<FormState>();
  TextEditingController? txtNamaToko;
  TextEditingController? txtALamat;
  TextEditingController? txtProvinsi;
  TextEditingController? txtKabupaten;
  TextEditingController? txtKodePos;
  TextEditingController? txtPhone;
  TextEditingController? txtNotes;
  DateTime? now = DateTime.now();
  bool status = false;
  int id = 0;

  @override
  void initState() {
    super.initState();
    context.read<ReceiptBloc>().add(GetReceipt());
    txtNamaToko = TextEditingController();
    txtALamat = TextEditingController();
    txtProvinsi = TextEditingController();
    txtKabupaten = TextEditingController();
    txtKodePos = TextEditingController();
    txtPhone = TextEditingController();
    txtNotes = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    txtNamaToko!.dispose();
    txtALamat!.dispose();
    txtProvinsi!.dispose();
    txtKabupaten!.dispose();
    txtKodePos!.dispose();
    txtPhone!.dispose();
    txtNotes!.dispose();
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
    final struk = BlocBuilder<ReceiptBloc, ReceiptState>(
      builder: (context, state) {
        if (state is ReceiptSuccess) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            status = true;
            id = state.receiptModel.id!;
            if (txtNamaToko!.text.isEmpty) {
              txtNamaToko?.text = state.receiptModel.namaToko!;
            }
            if (txtALamat!.text.isEmpty) {
              txtALamat?.text = state.receiptModel.alamat!;
            }
            if (txtProvinsi!.text.isEmpty) {
              txtProvinsi?.text = state.receiptModel.provinsi!;
            }
            if (txtKabupaten!.text.isEmpty) {
              txtKabupaten?.text = state.receiptModel.kota!;
            }
            if (txtKodePos!.text.isEmpty) {
              txtKodePos?.text = state.receiptModel.kodePos!;
            }
            if (txtPhone!.text.isEmpty) {
              txtPhone?.text = state.receiptModel.phone!;
            }
            if (txtNotes!.text.isEmpty) {
              txtNotes?.text = state.receiptModel.notes!;
            }
          });
          return Container(
            width: MediaQuery.of(context).size.width * 0.35,
            height: MediaQuery.of(context).size.height * 0.8,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                border: Border.all(width: 0.7, color: Colors.black12),
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xFFF5F1F1)),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                height: MediaQuery.of(context).size.height * 1,
                color: Colors.white,
                child: Column(
                  children: [
                    Text(
                      txtNamaToko!.text,
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 27),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 0),
                      child: Text(
                        "${txtALamat!.text} ${txtKabupaten!.text} ${txtProvinsi!.text} ${txtKodePos!.text}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 14, color: Color(0xFF868282)),
                      ),
                    ),
                    Text(
                      txtPhone!.text,
                      style: const TextStyle(
                          fontSize: 14, color: Color(0xFF868282)),
                    ),
                    const SizedBox(height: 20),
                    const Divider(),
                    Container(
                      alignment: Alignment.topLeft,
                      margin: const EdgeInsets.only(bottom: 5, left: 5),
                      child: Text(
                        NumberFormats.getFormatDay(
                            DateTime.parse(now.toString())),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                            width: 64,
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            child: const Text("No Order")),
                        const Text("INV/2024/001"),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Container(
                            width: 64,
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            child: const Text("Kasir")),
                        const Text("Maulida"),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Container(
                            width: 64,
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            child: const Text("Customer")),
                        const Text("Umum"),
                      ],
                    ),
                    const Divider(),
                    Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 1,
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(color: Colors.white),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Kapal Api",
                                      style: GoogleFonts.playfairDisplay(
                                          fontSize: 18),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      '5 X 2.000',
                                      style: GoogleFonts.play(fontSize: 14),
                                    ),
                                    const SizedBox(height: 5),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.1,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "Rp ${NumberFormats.convertToIdr("10000")}",
                                        overflow: TextOverflow.fade,
                                        textAlign: TextAlign.right,
                                        style: GoogleFonts.play(fontSize: 18),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 1,
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(color: Colors.white),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Sedap Goreng",
                                      style: GoogleFonts.playfairDisplay(
                                          fontSize: 18),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      '2 X 3.500',
                                      style: GoogleFonts.play(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.1,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "Rp ${NumberFormats.convertToIdr("7000")}",
                                        overflow: TextOverflow.fade,
                                        textAlign: TextAlign.right,
                                        style: GoogleFonts.play(fontSize: 18),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("Total",
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 18,
                            )),
                        Container(
                          width: 100,
                          alignment: Alignment.topRight,
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          child: Text(NumberFormats.convertToIdr("17000"),
                              style: GoogleFonts.play(
                                fontSize: 18,
                              )),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("Discount",
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 18,
                            )),
                        Container(
                          width: 100,
                          alignment: Alignment.topRight,
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          child: Text(NumberFormats.convertToIdr("0"),
                              style: GoogleFonts.play(
                                fontSize: 18,
                              )),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("Bayar",
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 18,
                            )),
                        Container(
                          width: 100,
                          alignment: Alignment.topRight,
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          child: Text(NumberFormats.convertToIdr("17000"),
                              style: GoogleFonts.play(
                                fontSize: 18,
                              )),
                        ),
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("Kembali",
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 18,
                            )),
                        Container(
                          width: 100,
                          alignment: Alignment.topRight,
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          child: Text(NumberFormats.convertToIdr("0"),
                              style: GoogleFonts.play(
                                fontSize: 18,
                              )),
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 20),
                      child: Text(
                        txtNotes!.text,
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }
        if (state is ReceiptError) {
          return Container(
            width: MediaQuery.of(context).size.width * 0.35,
            height: MediaQuery.of(context).size.height * 0.8,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                border: Border.all(width: 0.7, color: Colors.black12),
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xFFF5F1F1)),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                height: MediaQuery.of(context).size.height * 1,
                color: Colors.white,
                child: Column(
                  children: [
                    Text(
                      txtNamaToko!.text,
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 27),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 0),
                      child: Text(
                        "${txtALamat!.text} ${txtKabupaten!.text} ${txtProvinsi!.text} ${txtKodePos!.text}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 14, color: Color(0xFF868282)),
                      ),
                    ),
                    Text(
                      txtPhone!.text,
                      style: const TextStyle(
                          fontSize: 14, color: Color(0xFF868282)),
                    ),
                    const SizedBox(height: 20),
                    const Divider(),
                    Container(
                      alignment: Alignment.topLeft,
                      margin: const EdgeInsets.only(bottom: 5, left: 5),
                      child: Text(
                        NumberFormats.getFormatDay(
                            DateTime.parse(now.toString())),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                            width: 64,
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            child: const Text("No Order")),
                        const Text("INV/2024/001"),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Container(
                            width: 64,
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            child: const Text("Kasir")),
                        const Text("Maulida"),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Container(
                            width: 64,
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            child: const Text("Customer")),
                        const Text("Umum"),
                      ],
                    ),
                    const Divider(),
                    Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 1,
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(color: Colors.white),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Kapal Api",
                                      style: GoogleFonts.playfairDisplay(
                                          fontSize: 18),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      '5 X 2.000',
                                      style: GoogleFonts.play(fontSize: 14),
                                    ),
                                    const SizedBox(height: 5),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.1,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "Rp ${NumberFormats.convertToIdr("10000")}",
                                        overflow: TextOverflow.fade,
                                        textAlign: TextAlign.right,
                                        style: GoogleFonts.play(fontSize: 18),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 1,
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(color: Colors.white),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Sedap Goreng",
                                      style: GoogleFonts.playfairDisplay(
                                          fontSize: 18),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      '2 X 3.500',
                                      style: GoogleFonts.play(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.1,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "Rp ${NumberFormats.convertToIdr("7000")}",
                                        overflow: TextOverflow.fade,
                                        textAlign: TextAlign.right,
                                        style: GoogleFonts.play(fontSize: 18),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("Total",
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 18,
                            )),
                        Container(
                          width: 100,
                          alignment: Alignment.topRight,
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          child: Text(NumberFormats.convertToIdr("17000"),
                              style: GoogleFonts.play(
                                fontSize: 18,
                              )),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("Discount",
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 18,
                            )),
                        Container(
                          width: 100,
                          alignment: Alignment.topRight,
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          child: Text(NumberFormats.convertToIdr("0"),
                              style: GoogleFonts.play(
                                fontSize: 18,
                              )),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("Bayar",
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 18,
                            )),
                        Container(
                          width: 100,
                          alignment: Alignment.topRight,
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          child: Text(NumberFormats.convertToIdr("17000"),
                              style: GoogleFonts.play(
                                fontSize: 18,
                              )),
                        ),
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("Kembali",
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 18,
                            )),
                        Container(
                          width: 100,
                          alignment: Alignment.topRight,
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          child: Text(NumberFormats.convertToIdr("0"),
                              style: GoogleFonts.play(
                                fontSize: 18,
                              )),
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 20),
                      child: Text(
                        txtNotes!.text,
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }
        return Container();
      },
    );
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(color: Color(0xFFFFFFFF)),
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
                              "Receipt",
                              style: GoogleFonts.play(
                                  fontSize: 30, fontWeight: FontWeight.w600),
                            ),
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
                                      MediaQuery.of(context).size.width * 0.4,
                                  child: Form(
                                    key: formState,
                                    child: Column(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Nama Toko",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            const SizedBox(height: 10),
                                            TextFormField(
                                              controller: txtNamaToko,
                                              validator: (value) {
                                                if (value == '') {
                                                  return "Nama Toko Tidak Boleh Kosong";
                                                }
                                                return null;
                                              },
                                              minLines: 1,
                                              keyboardType: TextInputType.text,
                                              maxLines: null,
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                hintText: "Toko Rizky Illahi",
                                                hintStyle: TextStyle(
                                                    color: Colors.grey),
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 14,
                                                        horizontal: 14),
                                                isDense: true,
                                              ),
                                              style: const TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 20),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Alamat",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            const SizedBox(height: 10),
                                            TextFormField(
                                              controller: txtALamat,
                                              validator: (value) {
                                                if (value == '') {
                                                  return "Nama Toko Tidak Boleh Kosong";
                                                }
                                                return null;
                                              },
                                              minLines: 1,
                                              keyboardType:
                                                  TextInputType.multiline,
                                              maxLines: null,
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                hintText: "Jln Test ..",
                                                hintStyle: TextStyle(
                                                    color: Colors.grey),
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 14,
                                                        horizontal: 14),
                                                isDense: true,
                                              ),
                                              style: const TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 20),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              width: 120,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    "Provinsi",
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  TextFormField(
                                                    controller: txtProvinsi,
                                                    validator: (value) {
                                                      if (value == '') {
                                                        return "Provinsi Tidak Boleh Kosong";
                                                      }
                                                      return null;
                                                    },
                                                    minLines: 1,
                                                    keyboardType:
                                                        TextInputType.text,
                                                    maxLines: null,
                                                    decoration:
                                                        const InputDecoration(
                                                      border:
                                                          OutlineInputBorder(),
                                                      hintText: "Jawa Barat",
                                                      hintStyle: TextStyle(
                                                          color: Colors.grey),
                                                      contentPadding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 14,
                                                              horizontal: 14),
                                                      isDense: true,
                                                    ),
                                                    style: const TextStyle(
                                                      fontSize: 14.0,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: 120,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    "kab / Kota",
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  TextFormField(
                                                    controller: txtKabupaten,
                                                    validator: (value) {
                                                      if (value == '') {
                                                        return "Kabupaten Tidak Boleh Kosong";
                                                      }
                                                      return null;
                                                    },
                                                    minLines: 1,
                                                    keyboardType:
                                                        TextInputType.text,
                                                    maxLines: null,
                                                    decoration:
                                                        const InputDecoration(
                                                      border:
                                                          OutlineInputBorder(),
                                                      hintText: "Pangandaran",
                                                      hintStyle: TextStyle(
                                                          color: Colors.grey),
                                                      contentPadding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 14,
                                                              horizontal: 14),
                                                      isDense: true,
                                                    ),
                                                    style: const TextStyle(
                                                      fontSize: 14.0,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: 120,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    "Kode Pos",
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  TextFormField(
                                                    controller: txtKodePos,
                                                    validator: (value) {
                                                      if (value == '') {
                                                        return "Kode Pos Tidak Boleh Kosong";
                                                      }
                                                      return null;
                                                    },
                                                    minLines: 1,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    maxLines: null,
                                                    decoration:
                                                        const InputDecoration(
                                                      border:
                                                          OutlineInputBorder(),
                                                      hintText: "46396",
                                                      hintStyle: TextStyle(
                                                          color: Colors.grey),
                                                      contentPadding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 14,
                                                              horizontal: 14),
                                                      isDense: true,
                                                    ),
                                                    style: const TextStyle(
                                                      fontSize: 14.0,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 10),
                                            const Text(
                                              "Phone",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            const SizedBox(height: 10),
                                            TextFormField(
                                              controller: txtPhone,
                                              minLines: 1,
                                              keyboardType: TextInputType.phone,
                                              maxLines: null,
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                hintText: "081224",
                                                hintStyle: TextStyle(
                                                    color: Colors.grey),
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 14,
                                                        horizontal: 14),
                                                isDense: true,
                                              ),
                                              style: const TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 10),
                                            const Text(
                                              "Notes",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            const SizedBox(height: 10),
                                            TextFormField(
                                              controller: txtNotes,
                                              minLines: 5,
                                              keyboardType:
                                                  TextInputType.multiline,
                                              maxLines: null,
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                hintText: "notes",
                                                hintStyle: TextStyle(
                                                    color: Colors.grey),
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 14,
                                                        horizontal: 14),
                                                isDense: true,
                                              ),
                                              style: const TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 20),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            BlocConsumer<ReceiptBloc,
                                                ReceiptState>(
                                              listener: (context, states) {
                                                if (states
                                                    is RequestReceiptSuccess) {
                                                  context
                                                      .read<ReceiptBloc>()
                                                      .add(GetReceipt());
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                        backgroundColor:
                                                            Colors.blue,
                                                        content: Text(
                                                            'Success Menambah Receipt')),
                                                  );
                                                }
                                              },
                                              builder: (context, states) {
                                                if (states is ReceiptLoading) {
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
                                                                    150, 50),
                                                            backgroundColor:
                                                                const Color(
                                                                    0XFF2334A6)),
                                                    child: Text(
                                                      "Save",
                                                      style: GoogleFonts
                                                          .playfairDisplay(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 18),
                                                    ),
                                                  );
                                                }
                                                return ElevatedButton(
                                                  onPressed: () {
                                                    if (formState.currentState!
                                                        .validate()) {
                                                      var request =
                                                          ReceiptModel(
                                                        id: id,
                                                        namaToko:
                                                            txtNamaToko!.text,
                                                        alamat: txtALamat!.text,
                                                        provinsi:
                                                            txtProvinsi!.text,
                                                        kota:
                                                            txtKabupaten!.text,
                                                        kodePos:
                                                            txtKodePos!.text,
                                                        phone: txtPhone!.text,
                                                        notes: txtNotes!.text,
                                                      );
                                                      if (status) {
                                                        context
                                                            .read<ReceiptBloc>()
                                                            .add(UpdateReceipt(
                                                                receiptModel:
                                                                    request));
                                                      } else {
                                                        context
                                                            .read<ReceiptBloc>()
                                                            .add(CreateReceipt(
                                                                receiptModel:
                                                                    request));
                                                      }
                                                    }
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
                                                              150, 50),
                                                          backgroundColor:
                                                              const Color(
                                                                  0XFF2334A6)),
                                                  child: Text(
                                                    "Save",
                                                    style: GoogleFonts
                                                        .playfairDisplay(
                                                            color: Colors.white,
                                                            fontSize: 18),
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 11,
                                ),
                                struk
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

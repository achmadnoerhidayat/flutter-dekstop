import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kasir_dekstop/bloc/transaksi/transaksi_bloc.dart';
import 'package:kasir_dekstop/helper/number_format.dart';
import 'package:kasir_dekstop/models/transaksi_model.dart';
import 'package:kasir_dekstop/page/home/home_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

class TransaksiSucces extends StatefulWidget {
  static String routeName = '/transaksi-success';
  final int id;
  const TransaksiSucces({super.key, required this.id});

  @override
  State<TransaksiSucces> createState() => _TransaksiSuccesState();
}

class _TransaksiSuccesState extends State<TransaksiSucces> {
  int discount = 0;
  int subtotal = 0;
  TransaksiModel? transModel;
  DateTime? now = DateTime.now();
  @override
  void initState() {
    context.read<TransaksiBloc>().add(ShowTransaksi(id: widget.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final transaksi = BlocBuilder<TransaksiBloc, TransaksiState>(
      builder: (context, state) {
        if (state is ShowTransaksiSuccess) {
          transModel = state.transaksi;
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "Rp ${NumberFormats.convertToIdr(state.transaksi.kembalian!)}",
                        style: GoogleFonts.play(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Change",
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "Out Of ${NumberFormats.convertToIdr(state.transaksi.totalHarga!)}",
                    style: GoogleFonts.play(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                        color: const Color(0xFFB4B1B1)),
                  ),
                ],
              ),
            ],
          );
        }
        return Container();
      },
    );
    return Scaffold(
      body: Column(
        children: [
          // header
          Container(
            height: 120,
            padding: const EdgeInsets.only(left: 10, right: 10),
            margin: const EdgeInsets.only(top: 30),
            decoration: BoxDecoration(
                border: Border.all(color: const Color(0XFFD9D9D9))),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        context.go(HomeScreen.routeName);
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          fixedSize: const Size(150, 30),
                          backgroundColor: const Color(0XFF2334A6)),
                      child: Text(
                        "New Sale",
                        style: GoogleFonts.playfairDisplay(
                            color: Colors.white, fontSize: 20),
                      ),
                    )
                  ],
                ),
                transaksi
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 140,
                      child: ElevatedButton(
                        onPressed: () {
                          printStruk(transModel);
                        },
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            fixedSize: const Size(130, 30),
                            backgroundColor: const Color(0XFF2334A6)),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.print,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "Print",
                              style: GoogleFonts.playfairDisplay(
                                  color: Colors.white, fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 165,
                      child: ElevatedButton(
                        onPressed: () {
                          downloadStruk(transModel);
                        },
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            fixedSize: const Size(140, 30),
                            backgroundColor: const Color(0xFFB4B1B1)),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.download,
                              color: Colors.black,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "Download",
                              style: GoogleFonts.playfairDisplay(
                                  color: Colors.black, fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> downloadStruk(TransaksiModel? transaksiModel) async {
    final doc = pw.Document();
    subtotal = 0;
    discount = 0;
    doc.addPage(pw.Page(
      pageFormat: const PdfPageFormat(58 * PdfPageFormat.mm, double.infinity),
      build: (pw.Context context) {
        return pw.Container(
            color: PdfColors.white,
            child: pw.Column(
              children: [
                pw.SizedBox(height: 15),
                pw.Text(
                  (transaksiModel!.receipt != null)
                      ? "${transaksiModel.receipt!.namaToko}"
                      : "Nama Toko",
                  style: pw.TextStyle(
                      fontSize: 12, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 3),
                pw.Text(
                  (transaksiModel.receipt != null)
                      ? "${transaksiModel.receipt!.alamat} ${transaksiModel.receipt!.kota} ${transaksiModel.receipt!.provinsi} ${transaksiModel.receipt!.kodePos}"
                      : "Jln -- ",
                  style: const pw.TextStyle(fontSize: 6),
                ),
                pw.Text(
                  (transaksiModel.receipt != null)
                      ? "${transaksiModel.receipt!.phone}"
                      : "081224738582",
                  style: const pw.TextStyle(fontSize: 6),
                ),
                pw.SizedBox(height: 20),
                pw.Container(
                  margin:
                      const pw.EdgeInsets.only(bottom: 5, left: 5, right: 5),
                  decoration: const pw.BoxDecoration(
                    border: pw.Border(
                      bottom: pw.BorderSide(
                        color: PdfColors.black,
                        width: 0.8,
                        style: pw.BorderStyle.dashed,
                      ),
                    ),
                  ),
                ),
                pw.Container(
                  alignment: pw.Alignment.topLeft,
                  margin: const pw.EdgeInsets.only(bottom: 5, left: 5),
                  child: pw.Text(
                      NumberFormats.getFormatDay(
                          DateTime.parse(transaksiModel.created!)),
                      textAlign: pw.TextAlign.start,
                      style: const pw.TextStyle(fontSize: 8)),
                ),
                pw.Row(
                  children: [
                    pw.Container(
                        width: 64,
                        margin: const pw.EdgeInsets.symmetric(horizontal: 5),
                        child: pw.Text("No Order",
                            style: const pw.TextStyle(fontSize: 8))),
                    pw.Text(transaksiModel.orderId!,
                        style: const pw.TextStyle(fontSize: 8)),
                  ],
                ),
                pw.SizedBox(height: 5),
                pw.Row(
                  children: [
                    pw.Container(
                        width: 64,
                        margin: const pw.EdgeInsets.symmetric(horizontal: 5),
                        child: pw.Text("Kasir",
                            style: const pw.TextStyle(fontSize: 8))),
                    pw.Text("Maulida", style: const pw.TextStyle(fontSize: 8)),
                  ],
                ),
                pw.SizedBox(height: 5),
                pw.Row(
                  children: [
                    pw.Container(
                        width: 64,
                        margin: const pw.EdgeInsets.symmetric(horizontal: 5),
                        child: pw.Text("Customer",
                            style: const pw.TextStyle(fontSize: 8))),
                    pw.Text(
                        (transaksiModel.idCustomer != null)
                            ? "${transaksiModel.customer!.nama}"
                            : "Umum",
                        style: const pw.TextStyle(fontSize: 8)),
                  ],
                ),
                pw.Container(
                  margin: const pw.EdgeInsets.only(
                      top: 10, bottom: 2, left: 5, right: 5),
                  decoration: const pw.BoxDecoration(
                    border: pw.Border(
                      bottom: pw.BorderSide(
                        color: PdfColors.black,
                        width: 0.8,
                        style: pw.BorderStyle.dashed,
                      ),
                    ),
                  ),
                ),
                pw.Column(
                  children: transaksiModel.detail!.map((e) {
                    String promo = "";
                    int potongan = 0;
                    double total = 0;
                    if (e.idVarian == null) {
                      total =
                          double.parse(e.product!.harga) * double.parse(e.qty!);
                    } else {
                      total = double.parse(e.varian!.hargaVarian) *
                          double.parse(e.qty!);
                    }
                    if (e.totalDiskon != null) {
                      discount += int.parse(e.totalDiskon!);
                    }
                    if (e.product?.promoProducts != null) {
                      DateTime tanggalMulai = DateTime.parse(
                          e.product!.promoProducts!.promo!.promoMulai!);
                      DateTime tanggalBerakhir = DateTime.parse(
                          e.product!.promoProducts!.promo!.promoBerakhir!);
                      if (tanggalMulai.isBefore(now!) ||
                          tanggalBerakhir.isBefore(now!)) {
                        String min = "${e.product!.promoProducts!.minBelanja}";
                        if (int.parse(min) == int.parse(e.qty!)) {
                          promo = e.product!.promoProducts!.hargaPromo!;
                          int pot = total.toInt() - int.parse(promo);
                          potongan = pot;
                        }
                      }
                    }
                    subtotal += total.toInt();
                    return pw.Container(
                      padding: const pw.EdgeInsets.only(
                          left: 5, right: 5, bottom: 3),
                      child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.SizedBox(
                            width: 100,
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  e.product!.namaBarang,
                                  style: const pw.TextStyle(fontSize: 8),
                                ),
                                (e.idVarian == null)
                                    ? pw.Text(
                                        '${e.qty} X ${NumberFormats.convertToIdr(e.product!.harga)}',
                                        style: const pw.TextStyle(fontSize: 8),
                                      )
                                    : pw.Text(
                                        '${e.qty} ${e.varian!.namaVarian} X ${NumberFormats.convertToIdr(e.varian!.hargaVarian)}',
                                        style: const pw.TextStyle(fontSize: 8),
                                      ),
                                (promo != "")
                                    ? pw.Text("Promo: $potongan",
                                        style: const pw.TextStyle(fontSize: 8))
                                    : pw.SizedBox.shrink(),
                              ],
                            ),
                          ),
                          pw.SizedBox(
                            child: pw.Row(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              mainAxisAlignment: pw.MainAxisAlignment.end,
                              children: [
                                (promo != "")
                                    ? pw.Column(
                                        children: [
                                          pw.Text(
                                            NumberFormats.convertToIdr(
                                                total.toString()),
                                            textAlign: pw.TextAlign.right,
                                            style: const pw.TextStyle(
                                                fontSize: 8,
                                                color: PdfColors.red,
                                                decoration: pw.TextDecoration
                                                    .lineThrough),
                                          ),
                                          pw.Text(
                                            NumberFormats.convertToIdr(
                                                promo.toString()),
                                            textAlign: pw.TextAlign.right,
                                            style:
                                                const pw.TextStyle(fontSize: 8),
                                          ),
                                        ],
                                      )
                                    : pw.Text(
                                        NumberFormats.convertToIdr(
                                            total.toString()),
                                        textAlign: pw.TextAlign.right,
                                        style: const pw.TextStyle(fontSize: 8),
                                      ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                pw.Container(
                  margin: const pw.EdgeInsets.only(
                      top: 10, bottom: 10, left: 5, right: 5),
                  decoration: const pw.BoxDecoration(
                    border: pw.Border(
                      bottom: pw.BorderSide(
                        color: PdfColors.black,
                        width: 0.8,
                        style: pw.BorderStyle.dashed,
                      ),
                    ),
                  ),
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Container(
                      width: 60,
                      alignment: pw.Alignment.topLeft,
                      margin: const pw.EdgeInsets.only(left: 5),
                      child: pw.Text("Total",
                          style: const pw.TextStyle(
                            fontSize: 8,
                          )),
                    ),
                    pw.Text("="),
                    pw.Container(
                      width: 60,
                      alignment: pw.Alignment.topRight,
                      margin: const pw.EdgeInsets.only(right: 5),
                      child: pw.Text(
                          NumberFormats.convertToIdr(subtotal.toString()),
                          style: const pw.TextStyle(
                            fontSize: 8,
                          )),
                    ),
                  ],
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Container(
                      width: 60,
                      alignment: pw.Alignment.topLeft,
                      margin: const pw.EdgeInsets.only(left: 5),
                      child: pw.Text("Discount",
                          style: const pw.TextStyle(
                            fontSize: 8,
                          )),
                    ),
                    pw.Text("="),
                    pw.Container(
                      width: 60,
                      alignment: pw.Alignment.topRight,
                      margin: const pw.EdgeInsets.only(right: 5),
                      child: pw.Text(
                          NumberFormats.convertToIdr(discount.toString()),
                          style: const pw.TextStyle(
                            fontSize: 8,
                          )),
                    ),
                  ],
                ),
                (transaksiModel.weightGula != null)
                    ? pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Container(
                            width: 60,
                            alignment: pw.Alignment.topLeft,
                            margin: const pw.EdgeInsets.only(left: 5),
                            child: pw.Text("Berat Gula",
                                style: const pw.TextStyle(
                                  fontSize: 8,
                                )),
                          ),
                          pw.Text("="),
                          pw.Container(
                            width: 60,
                            alignment: pw.Alignment.topRight,
                            margin: const pw.EdgeInsets.only(right: 5),
                            child: pw.Text(transaksiModel.weightGula!,
                                style: const pw.TextStyle(
                                  fontSize: 8,
                                )),
                          ),
                        ],
                      )
                    : pw.SizedBox.shrink(),
                (transaksiModel.priceBeliGula != null)
                    ? pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Container(
                            width: 60,
                            alignment: pw.Alignment.topLeft,
                            margin: const pw.EdgeInsets.only(left: 5),
                            child: pw.Text("Harga Gula",
                                style: const pw.TextStyle(
                                  fontSize: 8,
                                )),
                          ),
                          pw.Text("="),
                          pw.Container(
                            width: 60,
                            alignment: pw.Alignment.topRight,
                            margin: const pw.EdgeInsets.only(right: 5),
                            child: pw.Text(
                                NumberFormats.convertToIdr(
                                    transaksiModel.priceBeliGula!),
                                style: const pw.TextStyle(
                                  fontSize: 8,
                                )),
                          ),
                        ],
                      )
                    : pw.SizedBox.shrink(),
                (transaksiModel.setorGula != null)
                    ? pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Container(
                            width: 60,
                            alignment: pw.Alignment.topLeft,
                            margin: const pw.EdgeInsets.only(left: 5),
                            child: pw.Text("Setor Gula",
                                style: const pw.TextStyle(
                                  fontSize: 8,
                                )),
                          ),
                          pw.Text("="),
                          pw.Container(
                            width: 60,
                            alignment: pw.Alignment.topRight,
                            margin: const pw.EdgeInsets.only(right: 5),
                            child: pw.Text(
                                NumberFormats.convertToIdr(
                                    transaksiModel.setorGula!),
                                style: const pw.TextStyle(
                                  fontSize: 8,
                                )),
                          ),
                        ],
                      )
                    : pw.SizedBox.shrink(),
                (transaksiModel.setorKasbon != null)
                    ? pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Container(
                            width: 60,
                            alignment: pw.Alignment.topLeft,
                            margin: const pw.EdgeInsets.only(left: 5),
                            child: pw.Text("Setor Kasbon",
                                style: const pw.TextStyle(
                                  fontSize: 8,
                                )),
                          ),
                          pw.Text("="),
                          pw.Container(
                            width: 60,
                            alignment: pw.Alignment.topRight,
                            margin: const pw.EdgeInsets.only(right: 5),
                            child: pw.Text(
                                NumberFormats.convertToIdr(
                                    transaksiModel.setorKasbon!),
                                style: const pw.TextStyle(
                                  fontSize: 8,
                                )),
                          ),
                        ],
                      )
                    : pw.SizedBox.shrink(),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Container(
                      width: 60,
                      alignment: pw.Alignment.topLeft,
                      margin: const pw.EdgeInsets.only(left: 5),
                      child: pw.Text("Bayar",
                          style: const pw.TextStyle(
                            fontSize: 8,
                          )),
                    ),
                    pw.Text("="),
                    pw.Container(
                      width: 60,
                      alignment: pw.Alignment.topRight,
                      margin: const pw.EdgeInsets.only(right: 5),
                      child: pw.Text(
                          NumberFormats.convertToIdr(transaksiModel.bayar!),
                          style: const pw.TextStyle(
                            fontSize: 8,
                          )),
                    ),
                  ],
                ),
                pw.Container(
                  margin: const pw.EdgeInsets.only(
                      top: 10, bottom: 10, left: 5, right: 5),
                  decoration: const pw.BoxDecoration(
                    border: pw.Border(
                      bottom: pw.BorderSide(
                        color: PdfColors.black,
                        width: 0.8,
                        style: pw.BorderStyle.dashed,
                      ),
                    ),
                  ),
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Container(
                      width: 60,
                      alignment: pw.Alignment.topLeft,
                      margin: const pw.EdgeInsets.only(left: 5),
                      child: pw.Text("Kembali",
                          style: const pw.TextStyle(
                            fontSize: 8,
                          )),
                    ),
                    pw.Text("="),
                    pw.Container(
                      width: 60,
                      alignment: pw.Alignment.topRight,
                      margin: const pw.EdgeInsets.only(right: 5),
                      child: pw.Text(
                          NumberFormats.convertToIdr(transaksiModel.kembalian!),
                          style: const pw.TextStyle(
                            fontSize: 8,
                          )),
                    ),
                  ],
                ),
                pw.Container(
                  margin: const pw.EdgeInsets.symmetric(
                      horizontal: 15, vertical: 20),
                  child: pw.Text(
                      (transaksiModel.receipt != null)
                          ? "${transaksiModel.receipt!.notes}"
                          : "Terimakasih atas kunjungan anda barang yang telah dibeli tidak bisa dikembalikan kecuali ada perjanjian",
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(fontSize: 8)),
                )
              ],
            ));
      },
    ));
    final pdfBytes = await doc.save();

    // Mendapatkan path ke folder Downloads
    final directory = await getDownloadsDirectory();
    final downloadPath = directory?.path;

    if (downloadPath != null) {
      // Merender PDF ke gambar
      await for (var page in Printing.raster(
        pdfBytes,
        pages: [0, 1], // Daftar halaman yang ingin dirender
        dpi: 150, // Resolusi DPI untuk gambar
      )) {
        // Mendapatkan gambar dalam format PNG
        final imageBytes = await page.toPng();

        // Menyimpan gambar ke file
        String orderId = transModel!.orderId!.replaceAll('/', '-');
        var fileName = '$orderId-struk.png';
        final file = File('$downloadPath/$fileName');
        await file.writeAsBytes(imageBytes);
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: Colors.blue,
              content: Text('Gambar berhasil disimpan di $fileName')),
        );
      }
    }

    // final file = File('D:/struk.pdf');
    // await file.writeAsBytes(await doc.save());
  }

  Future<void> printStruk(TransaksiModel? transaksiModel) async {
    final doc = pw.Document();
    subtotal = 0;
    discount = 0;
    doc.addPage(pw.Page(
      pageFormat: const PdfPageFormat(48 * PdfPageFormat.mm, double.infinity),
      build: (pw.Context context) {
        return pw.Container(
            color: PdfColors.white,
            margin: const pw.EdgeInsets.only(bottom: 20),
            child: pw.Column(
              children: [
                pw.SizedBox(height: 15),
                pw.Text(
                  (transaksiModel!.receipt != null)
                      ? "${transaksiModel.receipt!.namaToko}"
                      : "Nama Toko",
                  style: pw.TextStyle(
                      fontSize: 12, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 3),
                pw.Text(
                  textAlign: pw.TextAlign.center,
                  (transaksiModel.receipt != null)
                      ? "${transaksiModel.receipt!.alamat} ${transaksiModel.receipt!.kota} ${transaksiModel.receipt!.provinsi} ${transaksiModel.receipt!.kodePos}"
                      : "Jln -- ",
                  style: const pw.TextStyle(fontSize: 7.2),
                ),
                pw.Text(
                  (transaksiModel.receipt != null)
                      ? "${transaksiModel.receipt!.phone}"
                      : "081224738582",
                  style: const pw.TextStyle(fontSize: 7.2),
                ),
                pw.SizedBox(height: 20),
                pw.Container(
                  margin:
                      const pw.EdgeInsets.only(bottom: 5, left: 5, right: 5),
                  decoration: const pw.BoxDecoration(
                    border: pw.Border(
                      bottom: pw.BorderSide(
                        color: PdfColors.black,
                        width: 0.8,
                        style: pw.BorderStyle.dashed,
                      ),
                    ),
                  ),
                ),
                pw.Container(
                  alignment: pw.Alignment.topLeft,
                  margin: const pw.EdgeInsets.only(bottom: 5, left: 5),
                  child: pw.Text(
                      NumberFormats.getFormatDay(
                          DateTime.parse(transaksiModel.created!)),
                      textAlign: pw.TextAlign.start,
                      style: const pw.TextStyle(fontSize: 8.5)),
                ),
                pw.Row(
                  children: [
                    pw.Container(
                        width: 64,
                        margin: const pw.EdgeInsets.symmetric(horizontal: 5),
                        child: pw.Text("No Order",
                            style: const pw.TextStyle(fontSize: 8.5))),
                    pw.Text(transaksiModel.orderId!,
                        style: const pw.TextStyle(fontSize: 8.5)),
                  ],
                ),
                pw.SizedBox(height: 5),
                pw.Row(
                  children: [
                    pw.Container(
                        width: 64,
                        margin: const pw.EdgeInsets.symmetric(horizontal: 5),
                        child: pw.Text("Kasir",
                            style: const pw.TextStyle(fontSize: 8.5))),
                    pw.Text("Maulida",
                        style: const pw.TextStyle(fontSize: 8.5)),
                  ],
                ),
                pw.SizedBox(height: 5),
                pw.Row(
                  children: [
                    pw.Container(
                        width: 64,
                        margin: const pw.EdgeInsets.symmetric(horizontal: 5),
                        child: pw.Text("Customer",
                            style: const pw.TextStyle(fontSize: 8.5))),
                    pw.Text(
                        (transaksiModel.idCustomer != null)
                            ? "${transaksiModel.customer!.nama}"
                            : "Umum",
                        style: const pw.TextStyle(fontSize: 8.5)),
                  ],
                ),
                pw.Container(
                  margin: const pw.EdgeInsets.only(
                      top: 10, bottom: 2, left: 5, right: 5),
                  decoration: const pw.BoxDecoration(
                    border: pw.Border(
                      bottom: pw.BorderSide(
                        color: PdfColors.black,
                        width: 0.8,
                        style: pw.BorderStyle.dashed,
                      ),
                    ),
                  ),
                ),
                pw.Column(
                  children: transaksiModel.detail!.map((e) {
                    String promo = "";
                    int potongan = 0;
                    double total = 0;
                    if (e.idVarian == null) {
                      total =
                          double.parse(e.product!.harga) * double.parse(e.qty!);
                    } else {
                      total = double.parse(e.varian!.hargaVarian) *
                          double.parse(e.qty!);
                    }
                    if (e.totalDiskon != null) {
                      discount += int.parse(e.totalDiskon!);
                    }
                    if (e.product?.promoProducts != null) {
                      DateTime tanggalMulai = DateTime.parse(
                          e.product!.promoProducts!.promo!.promoMulai!);
                      DateTime tanggalBerakhir = DateTime.parse(
                          e.product!.promoProducts!.promo!.promoBerakhir!);
                      if (tanggalMulai.isBefore(now!) ||
                          tanggalBerakhir.isBefore(now!)) {
                        String min = "${e.product!.promoProducts!.minBelanja}";
                        if (int.parse(min) == int.parse(e.qty!)) {
                          promo = e.product!.promoProducts!.hargaPromo!;
                          int pot = total.toInt() - int.parse(promo);
                          potongan = pot;
                        }
                      }
                    }
                    subtotal += total.toInt();
                    return pw.Container(
                      padding: const pw.EdgeInsets.only(
                          left: 5, right: 5, bottom: 3),
                      child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.SizedBox(
                            width: 100,
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  e.product!.namaBarang,
                                  style: const pw.TextStyle(fontSize: 8.5),
                                ),
                                (e.idVarian == null)
                                    ? pw.Text(
                                        '${e.qty} X ${NumberFormats.convertToIdr(e.product!.harga)}',
                                        style:
                                            const pw.TextStyle(fontSize: 8.5),
                                      )
                                    : pw.Text(
                                        '${e.qty} ${e.varian!.namaVarian} X ${NumberFormats.convertToIdr(e.varian!.hargaVarian)}',
                                        style:
                                            const pw.TextStyle(fontSize: 8.5),
                                      ),
                                (promo != "")
                                    ? pw.Text("Promo: $potongan",
                                        style:
                                            const pw.TextStyle(fontSize: 8.5))
                                    : pw.SizedBox.shrink(),
                              ],
                            ),
                          ),
                          pw.SizedBox(
                            child: pw.Row(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              mainAxisAlignment: pw.MainAxisAlignment.end,
                              children: [
                                (promo != "")
                                    ? pw.Column(
                                        children: [
                                          pw.Text(
                                            NumberFormats.convertToIdr(
                                                total.toString()),
                                            textAlign: pw.TextAlign.right,
                                            style: const pw.TextStyle(
                                                fontSize: 8.5,
                                                color: PdfColors.red,
                                                decoration: pw.TextDecoration
                                                    .lineThrough),
                                          ),
                                          pw.Text(
                                            NumberFormats.convertToIdr(
                                                promo.toString()),
                                            textAlign: pw.TextAlign.right,
                                            style: const pw.TextStyle(
                                                fontSize: 8.5),
                                          ),
                                        ],
                                      )
                                    : pw.Text(
                                        NumberFormats.convertToIdr(
                                            total.toString()),
                                        textAlign: pw.TextAlign.right,
                                        style:
                                            const pw.TextStyle(fontSize: 8.5),
                                      ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                pw.Container(
                  margin: const pw.EdgeInsets.only(
                      top: 10, bottom: 10, left: 5, right: 5),
                  decoration: const pw.BoxDecoration(
                    border: pw.Border(
                      bottom: pw.BorderSide(
                        color: PdfColors.black,
                        width: 0.8,
                        style: pw.BorderStyle.dashed,
                      ),
                    ),
                  ),
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Container(
                      width: 60,
                      alignment: pw.Alignment.topLeft,
                      margin: const pw.EdgeInsets.only(left: 5),
                      child: pw.Text("Total",
                          style: const pw.TextStyle(
                            fontSize: 8.5,
                          )),
                    ),
                    pw.Text("="),
                    pw.Container(
                      width: 60,
                      alignment: pw.Alignment.topRight,
                      margin: const pw.EdgeInsets.only(right: 5),
                      child: pw.Text(
                          NumberFormats.convertToIdr(subtotal.toString()),
                          style: const pw.TextStyle(
                            fontSize: 8.5,
                          )),
                    ),
                  ],
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Container(
                      width: 60,
                      alignment: pw.Alignment.topLeft,
                      margin: const pw.EdgeInsets.only(left: 5),
                      child: pw.Text("Discount",
                          style: const pw.TextStyle(
                            fontSize: 8.5,
                          )),
                    ),
                    pw.Text("="),
                    pw.Container(
                      width: 60,
                      alignment: pw.Alignment.topRight,
                      margin: const pw.EdgeInsets.only(right: 5),
                      child: pw.Text(
                          NumberFormats.convertToIdr(discount.toString()),
                          style: const pw.TextStyle(
                            fontSize: 8.5,
                          )),
                    ),
                  ],
                ),
                (transaksiModel.weightGula != null)
                    ? pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Container(
                            width: 60,
                            alignment: pw.Alignment.topLeft,
                            margin: const pw.EdgeInsets.only(left: 5),
                            child: pw.Text("Berat Gula",
                                style: const pw.TextStyle(
                                  fontSize: 8.5,
                                )),
                          ),
                          pw.Text("="),
                          pw.Container(
                            width: 60,
                            alignment: pw.Alignment.topRight,
                            margin: const pw.EdgeInsets.only(right: 5),
                            child: pw.Text(transaksiModel.weightGula!,
                                style: const pw.TextStyle(
                                  fontSize: 8.5,
                                )),
                          ),
                        ],
                      )
                    : pw.SizedBox.shrink(),
                (transaksiModel.priceBeliGula != null)
                    ? pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Container(
                            width: 60,
                            alignment: pw.Alignment.topLeft,
                            margin: const pw.EdgeInsets.only(left: 5),
                            child: pw.Text("Harga Gula",
                                style: const pw.TextStyle(
                                  fontSize: 8.5,
                                )),
                          ),
                          pw.Text("="),
                          pw.Container(
                            width: 60,
                            alignment: pw.Alignment.topRight,
                            margin: const pw.EdgeInsets.only(right: 5),
                            child: pw.Text(
                                NumberFormats.convertToIdr(
                                    transaksiModel.priceBeliGula!),
                                style: const pw.TextStyle(
                                  fontSize: 8.5,
                                )),
                          ),
                        ],
                      )
                    : pw.SizedBox.shrink(),
                (transaksiModel.setorGula != null)
                    ? pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Container(
                            width: 60,
                            alignment: pw.Alignment.topLeft,
                            margin: const pw.EdgeInsets.only(left: 5),
                            child: pw.Text("Setor Gula",
                                style: const pw.TextStyle(
                                  fontSize: 8.5,
                                )),
                          ),
                          pw.Text("="),
                          pw.Container(
                            width: 60,
                            alignment: pw.Alignment.topRight,
                            margin: const pw.EdgeInsets.only(right: 5),
                            child: pw.Text(
                                NumberFormats.convertToIdr(
                                    transaksiModel.setorGula!),
                                style: const pw.TextStyle(
                                  fontSize: 8.5,
                                )),
                          ),
                        ],
                      )
                    : pw.SizedBox.shrink(),
                (transaksiModel.setorKasbon != null)
                    ? pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Container(
                            width: 60,
                            alignment: pw.Alignment.topLeft,
                            margin: const pw.EdgeInsets.only(left: 5),
                            child: pw.Text("Setor Kasbon",
                                style: const pw.TextStyle(
                                  fontSize: 8.5,
                                )),
                          ),
                          pw.Text("="),
                          pw.Container(
                            width: 60,
                            alignment: pw.Alignment.topRight,
                            margin: const pw.EdgeInsets.only(right: 5),
                            child: pw.Text(
                                NumberFormats.convertToIdr(
                                    transaksiModel.setorKasbon!),
                                style: const pw.TextStyle(
                                  fontSize: 8.5,
                                )),
                          ),
                        ],
                      )
                    : pw.SizedBox.shrink(),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Container(
                      width: 60,
                      alignment: pw.Alignment.topLeft,
                      margin: const pw.EdgeInsets.only(left: 5),
                      child: pw.Text("Bayar",
                          style: const pw.TextStyle(
                            fontSize: 8.5,
                          )),
                    ),
                    pw.Text("="),
                    pw.Container(
                      width: 60,
                      alignment: pw.Alignment.topRight,
                      margin: const pw.EdgeInsets.only(right: 5),
                      child: pw.Text(
                          NumberFormats.convertToIdr(transaksiModel.bayar!),
                          style: const pw.TextStyle(
                            fontSize: 8.5,
                          )),
                    ),
                  ],
                ),
                pw.Container(
                  margin: const pw.EdgeInsets.only(
                      top: 10, bottom: 10, left: 5, right: 5),
                  decoration: const pw.BoxDecoration(
                    border: pw.Border(
                      bottom: pw.BorderSide(
                        color: PdfColors.black,
                        width: 0.8,
                        style: pw.BorderStyle.dashed,
                      ),
                    ),
                  ),
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Container(
                      width: 60,
                      alignment: pw.Alignment.topLeft,
                      margin: const pw.EdgeInsets.only(left: 5),
                      child: pw.Text("Kembali",
                          style: const pw.TextStyle(
                            fontSize: 8.5,
                          )),
                    ),
                    pw.Text("="),
                    pw.Container(
                      width: 60,
                      alignment: pw.Alignment.topRight,
                      margin: const pw.EdgeInsets.only(right: 5),
                      child: pw.Text(
                          NumberFormats.convertToIdr(transaksiModel.kembalian!),
                          style: const pw.TextStyle(
                            fontSize: 8.5,
                          )),
                    ),
                  ],
                ),
                pw.Container(
                  margin: const pw.EdgeInsets.symmetric(
                      horizontal: 15, vertical: 20),
                  child: pw.Text(
                      (transaksiModel.receipt != null)
                          ? "${transaksiModel.receipt!.notes}"
                          : "Terimakasih atas kunjungan anda barang yang telah dibeli tidak bisa dikembalikan kecuali ada perjanjian",
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(fontSize: 8.5)),
                ),
              ],
            ));
      },
    ));
    final printers = await Printing.listPrinters();
    Printer? defaultPrint;
    for (var printer in printers) {
      if (printer.name.contains("POS58 Printer")) {
        defaultPrint = printer;
        break;
      }
    }
    if (defaultPrint == null && printers.isNotEmpty) {
      defaultPrint = printers.first;
    }
    if (defaultPrint != null) {
      String noOrder = transaksiModel!.orderId!.replaceAll('/', '-');
      await Printing.directPrintPdf(
          printer: defaultPrint,
          name: "struk-$noOrder",
          onLayout: (PdfPageFormat format) async => doc.save());
    }
    // final file = File('D:/struk.pdf');
    // await file.writeAsBytes(await doc.save());
  }
}

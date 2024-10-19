// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kasir_dekstop/bloc/bill/bill_bloc.dart';
import 'package:kasir_dekstop/bloc/cart/cart_bloc.dart';
import 'package:kasir_dekstop/helper/number_format.dart';

class ModalBill extends StatefulWidget {
  const ModalBill({super.key});

  @override
  State<ModalBill> createState() => _ModalBillState();
}

class _ModalBillState extends State<ModalBill> {
  @override
  Widget build(BuildContext context) {
    final bill = BlocBuilder<BillBloc, BillState>(
      builder: (context, state) {
        if (state is BillSuccess) {
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
                    "Nama Bill",
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
                  constraints: const BoxConstraints(maxWidth: 150),
                  child: Text(
                    "Jumlah Transaksi",
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
            rows: state.bill.map((val) {
              var no = state.bill.indexOf(val) + 1;
              int subtotal = 0;
              for (var i = 0; i < val.billCart!.length; i++) {
                double harga = 0;
                if (val.billCart![i].varianId != null) {
                  harga = double.parse(val.billCart![i].varian!.hargaVarian) *
                      double.parse(val.billCart![i].qty!);
                } else {
                  harga = double.parse(val.billCart![i].product!.harga) *
                      double.parse(val.billCart![i].qty!);
                }
                subtotal += harga.toInt();
              }
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
                  DataCell(
                    ConstrainedBox(
                      constraints: const BoxConstraints(),
                      child: Text(
                        "${val.billName}",
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
                        "${val.note}",
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
                        "Rp ${NumberFormats.convertToIdr(subtotal.toString())}",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.play(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: const Color(0XFF000000)),
                      ),
                    ),
                  ),
                  DataCell(
                    BlocConsumer<CartBloc, CartState>(
                      listener: (context, state) {
                        if (state is RequestCartSuccess) {
                          if (Navigator.of(context).canPop()) {
                            Navigator.of(context).pop();
                          } else {
                            // Optionally handle this case where there are no pages left to pop
                            print('No pages left to pop');
                          }
                          context.read<CartBloc>().add(GetCart());
                        }
                      },
                      builder: (context, state) {
                        if (state is BillLoading) {
                          return IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              context
                                  .read<CartBloc>()
                                  .add(UbahBill(billModel: val));
                            },
                          );
                        }
                        return IconButton(
                          icon: const Icon(Icons.check),
                          onPressed: () {
                            context
                                .read<CartBloc>()
                                .add(UbahBill(billModel: val));
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            }).toList(),
          );
        }
        return Container();
      },
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 40,
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Daftar Bill",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 24),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    fixedSize: const Size(100, 40),
                    backgroundColor: const Color(0XFFFFFFFF)),
                child: Text(
                  "Cancel",
                  style: GoogleFonts.playfairDisplay(
                      color: const Color(0XFF2334A6), fontSize: 14),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.6,
              padding: const EdgeInsets.only(top: 20, left: 5, right: 5),
              child: bill,
            ),
          ),
        ),
      ],
    );
  }
}

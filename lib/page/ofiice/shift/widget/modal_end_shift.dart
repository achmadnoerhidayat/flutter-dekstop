import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kasir_dekstop/bloc/shift/shift_bloc.dart';
import 'package:kasir_dekstop/helper/number_format.dart';
import 'package:kasir_dekstop/models/shift_model.dart';
import 'package:kasir_dekstop/util/utils.dart';

class ModalEndShift extends StatefulWidget {
  final ShiftModel shiftModel;
  const ModalEndShift({super.key, required this.shiftModel});

  @override
  State<ModalEndShift> createState() => _ModalEndShiftState();
}

class _ModalEndShiftState extends State<ModalEndShift> {
  int jumlah = 0;
  int selisih = 0;
  TextEditingController? txtUang;
  @override
  void initState() {
    super.initState();
    txtUang = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    txtUang!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int jumlah = 0;
    if (widget.shiftModel.modal != null) {
      jumlah = int.parse(widget.shiftModel.modal!);
    }
    if (widget.shiftModel.totalSetor != null) {
      jumlah = jumlah + int.parse(widget.shiftModel.totalSetor!);
    }
    if (widget.shiftModel.totalKasbon != null) {
      jumlah = jumlah - int.parse(widget.shiftModel.totalKasbon!);
    }
    if (widget.shiftModel.totalGula! != "null") {
      jumlah = jumlah - int.parse(widget.shiftModel.totalGula!);
    }
    if (widget.shiftModel.totalTransaksi != null) {
      jumlah = jumlah + int.parse(widget.shiftModel.totalTransaksi!);
    }
    if (widget.shiftModel.totalPemasukan != "0") {
      jumlah = jumlah + int.parse(widget.shiftModel.totalPemasukan!);
    }
    if (widget.shiftModel.totalPengeluaran != "0") {
      jumlah = jumlah - int.parse(widget.shiftModel.totalPengeluaran!);
    }
    return SizedBox(
      height: 400,
      child: ListView(
        children: [
          Container(
            height: 70,
            padding: const EdgeInsets.only(left: 10, right: 10),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFFFAF5F5))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      fixedSize: const Size(100, 50),
                      backgroundColor: const Color(0XFFFFFFFF)),
                  child: Text(
                    "Cancel",
                    style: GoogleFonts.playfairDisplay(
                        color: const Color(0XFF2334A6), fontSize: 16),
                  ),
                ),
                Text(
                  "End Shift",
                  style: GoogleFonts.playfairDisplay(
                      color: const Color(0XFF2334A6),
                      fontSize: 24,
                      fontWeight: FontWeight.w500),
                ),
                Container(),
              ],
            ),
          ),
          const Text(
            "Detail Shift",
            style: TextStyle(
              color: Color(0XFF1a278a),
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Nama",
                  style: TextStyle(
                    color: Color(0XFF1a278a),
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      Utils.userModel!.nama!,
                      style: const TextStyle(
                        color: Color(0XFF1a278a),
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Mulai Shift",
                  style: TextStyle(
                    color: Color(0XFF1a278a),
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                Text(
                  (widget.shiftModel.startShift != null)
                      ? NumberFormats.getFormatDay(
                          DateTime.parse(widget.shiftModel.startShift!))
                      : "",
                  style: const TextStyle(
                    color: Color(0XFF1a278a),
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Kas Keluar / Masuk",
                  style: TextStyle(
                    color: Color(0XFF1a278a),
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                Column(
                  children: [
                    (widget.shiftModel.totalPengeluaran != "0")
                        ? Text(
                            "- Rp ${NumberFormats.convertToIdr(widget.shiftModel.totalPengeluaran!)}",
                            style: const TextStyle(
                              color: Color(0xFFE4110A),
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          )
                        : const SizedBox.shrink(),
                    (widget.shiftModel.totalPemasukan != "0")
                        ? Text(
                            "+ Rp ${NumberFormats.convertToIdr(widget.shiftModel.totalPemasukan!)}",
                            style: const TextStyle(
                              color: Color(0XFF1a278a),
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Tunai",
            style: TextStyle(
              color: Color(0XFF1a278a),
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Modal",
                  style: TextStyle(
                    color: Color(0XFF1a278a),
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                Text(
                  (widget.shiftModel.modal != null)
                      ? "Rp ${NumberFormats.convertToIdr(widget.shiftModel.modal!.replaceAll('.', ''))}"
                      : "",
                  style: const TextStyle(
                    color: Color(0XFF1a278a),
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Pembayaran Tunai",
                  style: TextStyle(
                    color: Color(0XFF1a278a),
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                Text(
                  "Rp 0",
                  style: TextStyle(
                    color: Color(0XFF1a278a),
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Setor Kasbon / Hutang",
                  style: TextStyle(
                    color: Color(0XFF1a278a),
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                Text(
                  (widget.shiftModel.totalSetor != null)
                      ? "Rp ${NumberFormats.convertToIdr(widget.shiftModel.totalSetor!)}"
                      : "Rp 0",
                  style: const TextStyle(
                    color: Color(0XFF1a278a),
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Kasbon / Hutang",
                  style: TextStyle(
                    color: Color(0XFF1a278a),
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                Text(
                  (widget.shiftModel.totalKasbon != null)
                      ? "Rp ${NumberFormats.convertToIdr(widget.shiftModel.totalKasbon!)}"
                      : "Rp 0",
                  style: const TextStyle(
                    color: Color(0XFF1a278a),
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Beli Gula",
                  style: TextStyle(
                    color: Color(0XFF1a278a),
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                Text(
                  (widget.shiftModel.totalGula! != "null")
                      ? "Rp ${NumberFormats.convertToIdr(widget.shiftModel.totalGula!)}"
                      : "Rp 0",
                  style: const TextStyle(
                    color: Color(0XFF1a278a),
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Jumlah Uang Yang Diharapkan",
                  style: TextStyle(
                    color: Color(0XFF1a278a),
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                Text(
                  "Rp ${NumberFormats.convertToIdr(jumlah.toString())}",
                  style: const TextStyle(
                    color: Color(0XFF1a278a),
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Divider(),
          const Text(
            "Total",
            style: TextStyle(
              color: Color(0XFF1a278a),
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total Yang Diharapkan",
                  style: TextStyle(
                    color: Color(0XFF1a278a),
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                Text(
                  "Rp ${NumberFormats.convertToIdr(jumlah.toString())}",
                  style: const TextStyle(
                    color: Color(0XFF1a278a),
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            child: TextField(
              controller: txtUang,
              onChanged: (val) {
                setState(() {
                  if (val.isNotEmpty) {
                    val = val.replaceAll('.', '');
                  } else {
                    val = '';
                  }
                });
                txtUang!.value = TextEditingValue(
                  text: NumberFormats.convertToIdr(val),
                  selection: TextSelection.fromPosition(
                    TextPosition(
                        offset: NumberFormats.convertToIdr(val).length),
                  ),
                );
                setState(() {
                  String values = val.replaceAll('.', '');
                  if (val.isNotEmpty) {
                    selisih = int.parse(values) - jumlah;
                  }
                });
              },
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.only(left: 15, top: 5, bottom: 5),
                hintText: "Masukan Uang Yang Di dapatkan",
                hintStyle: const TextStyle(
                  color: Color(0XFFAA9D9D),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Selisih",
                  style: TextStyle(
                    color: Color(0XFF1a278a),
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                Text(
                  "Rp ${NumberFormats.convertToIdr(selisih.toString())}",
                  style: TextStyle(
                    color: (selisih > 0) ? const Color(0XFF1a278a) : Colors.red,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          BlocConsumer<ShiftBloc, ShiftState>(
            listener: (context, state) {
              if (state is RequestShiftSuccess) {
                txtUang!.clear();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      backgroundColor: Colors.blue,
                      content: Text('Berhasil Input Shift')),
                );
                Utils.shiftModel = null;
                String today =
                    DateTime.now().toIso8601String().substring(0, 10);
                context.read<ShiftBloc>().add(ShowShiftEvent(date: today));
                Navigator.of(context).pop();
              }
            },
            builder: (context, state) {
              if (state is ShiftLoading) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      fixedSize:
                          Size(MediaQuery.of(context).size.width * 1, 50),
                      backgroundColor: const Color(0XFF1a278a)),
                  onPressed: () {},
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                    fixedSize: Size(MediaQuery.of(context).size.width * 1, 50),
                    backgroundColor: const Color(0XFF1a278a)),
                onPressed: () {
                  String modal = txtUang!.text.replaceAll('.', '');
                  var request = ShiftModel(
                      id: widget.shiftModel.id,
                      modal: widget.shiftModel.modal,
                      startShift: widget.shiftModel.startShift,
                      endShift: DateTime.now().toIso8601String(),
                      totalUang: modal,
                      selisih: selisih.toString(),
                      created: widget.shiftModel.created);
                  context
                      .read<ShiftBloc>()
                      .add(UpdateShiftEvent(shift: request));
                },
                child: const Text(
                  "Akhiri Shift",
                  style: TextStyle(color: Colors.white),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

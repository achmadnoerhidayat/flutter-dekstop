import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kasir_dekstop/bloc/finance/finance_bloc.dart';
import 'package:kasir_dekstop/bloc/shift/shift_bloc.dart';
import 'package:kasir_dekstop/helper/number_format.dart';
import 'package:kasir_dekstop/models/finance_model.dart';

class ModalKas extends StatefulWidget {
  final String shiftId;
  const ModalKas({super.key, required this.shiftId});

  @override
  State<ModalKas> createState() => _ModalKasState();
}

class _ModalKasState extends State<ModalKas> {
  final formState = GlobalKey<FormState>();
  TextEditingController? txtModal;
  TextEditingController? txtNotes;
  String today = DateTime.now().toIso8601String().substring(0, 10);
  String type = "Pengeluaran";
  @override
  void initState() {
    super.initState();
    txtModal = TextEditingController();
    txtNotes = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    txtModal!.dispose();
    txtNotes!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                  txtModal!.clear();
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
              BlocConsumer<FinanceBloc, FinanceState>(
                listener: (context, state) {
                  if (state is RequestFinanceSucces) {
                    txtModal!.clear();
                    txtNotes!.clear();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          backgroundColor: Colors.blue,
                          content: Text('Success update shift')),
                    );
                    context.read<ShiftBloc>().add(ShowShiftEvent(date: today));
                    Navigator.of(context).pop();
                  }
                },
                builder: (context, state) {
                  if (state is FinanceLoading) {
                    return ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          fixedSize: const Size(100, 50),
                          backgroundColor: const Color(0XFF2334A6)),
                      child: Text(
                        "Save",
                        style: GoogleFonts.playfairDisplay(
                            color: const Color(0XFFFFFFFF), fontSize: 16),
                      ),
                    );
                  }
                  return ElevatedButton(
                    onPressed: () {
                      String modal = txtModal!.text.replaceAll('.', '');
                      var request = FinanceModel(
                        shiftId: widget.shiftId,
                        type: type,
                        nominal: modal,
                        note: txtNotes!.text,
                        created: DateTime.now().toIso8601String(),
                      );
                      context
                          .read<FinanceBloc>()
                          .add(CreateFinance(finance: request));
                    },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        fixedSize: const Size(100, 50),
                        backgroundColor: const Color(0XFF2334A6)),
                    child: Text(
                      "Save",
                      style: GoogleFonts.playfairDisplay(
                          color: const Color(0XFFFFFFFF), fontSize: 16),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 1,
          height: 60,
          child: TextFormField(
            controller: txtNotes,
            minLines: 5,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: "notes",
              hintStyle: TextStyle(color: Colors.grey),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 14, horizontal: 14),
              isDense: true,
            ),
            style: const TextStyle(
              fontSize: 14.0,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  TextButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                            (type == "Pengeluaran")
                                ? Colors.red
                                : const Color(0xFF5F5C5C)),
                      ),
                      onPressed: () {
                        setState(() {
                          type = "Pengeluaran";
                        });
                      },
                      child: const Text(
                        "Kas Keluar",
                        style: TextStyle(color: Colors.white),
                      )),
                  TextButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                            (type == "Pemasukan")
                                ? Colors.green
                                : const Color(0xFF5F5C5C)),
                      ),
                      onPressed: () {
                        setState(() {
                          type = "Pemasukan";
                        });
                      },
                      child: const Text(
                        "Kas Masuk",
                        style: TextStyle(color: Colors.white),
                      )),
                ],
              ),
            ),
            Expanded(
              child: TextFormField(
                controller: txtModal,
                validator: (value) {
                  if (value == '') {
                    return "Modal Tidak Boleh Kosong";
                  }
                  return null;
                },
                onChanged: (val) {
                  setState(() {
                    if (val.isNotEmpty) {
                      val = val.replaceAll('.', '');
                    } else {
                      val = '';
                    }
                  });
                  txtModal!.value = TextEditingValue(
                    text: NumberFormats.convertToIdr(val),
                    selection: TextSelection.fromPosition(
                      TextPosition(
                          offset: NumberFormats.convertToIdr(val).length),
                    ),
                  );
                },
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  fillColor: Colors.white,
                  contentPadding:
                      const EdgeInsets.only(left: 15, top: 5, bottom: 5),
                  hintText: "Masukan Nominal Modal",
                  hintStyle: const TextStyle(
                    color: Color(0XFFAA9D9D),
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}

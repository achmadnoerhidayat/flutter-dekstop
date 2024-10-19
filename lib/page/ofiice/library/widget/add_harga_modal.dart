import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:kasir_dekstop/bloc/request_variant/request_variant_bloc.dart';
import 'package:kasir_dekstop/helper/number_format.dart';
import 'package:kasir_dekstop/models/varian_model.dart';

// ignore: must_be_immutable
class AddHargaModal extends StatefulWidget {
  TextEditingController? txtModal;
  TextEditingController? txtHarga;
  List<VarianModel> list;
  AddHargaModal({super.key, required this.list, this.txtModal, this.txtHarga});

  @override
  State<AddHargaModal> createState() => _AddHargaModalState();
}

class _AddHargaModalState extends State<AddHargaModal> {
  final form = GlobalKey<FormState>();
  final NumberFormat _numberFormat =
      NumberFormat.currency(locale: 'id', symbol: '');
  @override
  Widget build(BuildContext context) {
    return Form(
      key: form,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // header
          Container(
            height: 100,
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
                      fixedSize: const Size(150, 70),
                      backgroundColor: const Color(0XFFFFFFFF)),
                  child: Text(
                    "Cancel",
                    style: GoogleFonts.playfairDisplay(
                        color: const Color(0XFF2334A6), fontSize: 20),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (form.currentState!.validate()) {
                      context
                          .read<RequestVariantBloc>()
                          .add(GetVarianList(formVarian: widget.list));
                      Navigator.of(context).pop();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      fixedSize: const Size(150, 70),
                      backgroundColor: const Color(0XFF2334A6)),
                  child: Text(
                    "Confirm",
                    style: GoogleFonts.playfairDisplay(
                        color: const Color(0XFFFFFFFF), fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(10),
            color: const Color(0xFFB8B2B2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.2,
                  child: Text(
                    "Varian",
                    style: GoogleFonts.playfairDisplay(
                        fontSize: 20, color: Colors.black),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.2,
                  child: Text("Harga Modal",
                      style: GoogleFonts.playfairDisplay(
                          fontSize: 20, color: Colors.black)),
                ),
              ],
            ),
          ),
          (widget.txtHarga!.text.isNotEmpty)
              ? Container(
                  width: double.infinity,
                  color: const Color(0xFFFFFFFF),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        width: MediaQuery.of(context).size.width * 0.2,
                        child: TextFormField(enabled: false),
                      ),
                      Container(
                        padding: const EdgeInsets.all(4),
                        width: MediaQuery.of(context).size.width * 0.2,
                        child: TextField(
                          controller: widget.txtModal,
                          keyboardType: TextInputType.number,
                          onChanged: (val) {
                            setState(() {
                              if (val.isNotEmpty) {
                                val = val.replaceAll('.', '');
                              } else {
                                val = '';
                              }
                            });
                            widget.txtModal!.value = TextEditingValue(
                              text: NumberFormats.convertToIdr(val),
                              selection: TextSelection.fromPosition(
                                TextPosition(
                                    offset:
                                        NumberFormats.convertToIdr(val).length),
                              ),
                            );
                          },
                          decoration: const InputDecoration(
                              labelText: 'Modal', hintText: '5000'),
                        ),
                      ),
                    ],
                  ),
                )
              : Container(),
          // body,
          BlocBuilder<RequestVariantBloc, RequestVariantState>(
            builder: (context, state) {
              if (state is RequestVariantList) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: state.formVarian.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(1.1),
                        child: Material(
                          elevation: 1,
                          clipBehavior: Clip.antiAlias,
                          borderRadius: BorderRadius.circular(8),
                          child: (state.formVarian[index].namaVarian.isNotEmpty)
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(4),
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      child: TextFormField(
                                        enabled: false,
                                        initialValue:
                                            state.formVarian[index].namaVarian,
                                        onChanged: (val) => state
                                            .formVarian[index].namaVarian = val,
                                        validator: (val) => val!.length > 1
                                            ? null
                                            : 'Nama Variant tidak valid',
                                        decoration: const InputDecoration(
                                            labelText: 'Nama Variant',
                                            hintText: 'Cth Pcs'),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(4),
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      child: TextFormField(
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                          TextInputFormatter.withFunction(
                                              (oldValue, newValue) {
                                            if (newValue.text.isEmpty) {
                                              return newValue.copyWith(
                                                  text: '');
                                            }
                                            final int? value = int.tryParse(
                                                newValue.text
                                                    .replaceAll(',', ''));
                                            if (value == null) {
                                              return oldValue;
                                            }
                                            final newText = _numberFormat
                                                .format(value)
                                                .toString()
                                                .replaceAll(',00', '');
                                            return newValue.copyWith(
                                              text: newText,
                                              selection:
                                                  TextSelection.collapsed(
                                                      offset: newText.length),
                                            );
                                          }),
                                        ],
                                        initialValue:
                                            NumberFormats.convertToIdr(state
                                                .formVarian[index]
                                                .hargaModalVarian),
                                        onChanged: (val) => state
                                            .formVarian[index]
                                            .hargaModalVarian = val,
                                        validator: (val) => val!.length > 1
                                            ? null
                                            : 'Harga Modal tidak boleh kosong',
                                        decoration: const InputDecoration(
                                            labelText: 'Modal',
                                            hintText: '5000'),
                                      ),
                                    ),
                                  ],
                                )
                              : const Row(),
                        ),
                      );
                    },
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),
    );
  }
}

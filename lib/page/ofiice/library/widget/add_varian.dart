import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:kasir_dekstop/bloc/request_variant/request_variant_bloc.dart';
import 'package:kasir_dekstop/helper/number_format.dart';
import 'package:kasir_dekstop/models/varian_model.dart';

// ignore: must_be_immutable
class AddVarian extends StatefulWidget {
  List<VarianModel> list;
  AddVarian({super.key, required this.list});

  @override
  State<AddVarian> createState() => _AddVarianState();
}

class _AddVarianState extends State<AddVarian> {
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
                    widget.list.removeWhere((val) =>
                        val.namaVarian.isEmpty || val.hargaVarian.isEmpty);
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
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  var varianModel = VarianModel();
                  widget.list.add(varianModel);
                  context
                      .read<RequestVariantBloc>()
                      .add(GetVarianList(formVarian: widget.list));
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0XFF2334A6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Text(
                "Tambah Varian",
                style: GoogleFonts.playfairDisplay(
                    fontSize: 16, color: Colors.white),
              ),
            ),
          ),
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
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                width: MediaQuery.of(context).size.width * 0.15,
                                child: TextFormField(
                                  initialValue:
                                      state.formVarian[index].namaVarian,
                                  onChanged: (val) {
                                    state.formVarian[index].namaVarian = val;
                                  },
                                  validator: (val) => val!.length > 1
                                      ? null
                                      : 'Nama Variant tidak valid',
                                  decoration: const InputDecoration(
                                      labelText: 'Nama Variant',
                                      hintText: 'Cth Pcs',
                                      border: OutlineInputBorder()),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(4),
                                width: MediaQuery.of(context).size.width * 0.15,
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    TextInputFormatter.withFunction(
                                        (oldValue, newValue) {
                                      if (newValue.text.isEmpty) {
                                        return newValue.copyWith(text: '');
                                      }
                                      final int? value = int.tryParse(
                                          newValue.text.replaceAll(',', ''));
                                      if (value == null) {
                                        return oldValue;
                                      }
                                      final newText = _numberFormat
                                          .format(value)
                                          .toString()
                                          .replaceAll(',00', '');
                                      return newValue.copyWith(
                                        text: newText,
                                        selection: TextSelection.collapsed(
                                            offset: newText.length),
                                      );
                                    }),
                                  ],
                                  initialValue: NumberFormats.convertToIdr(
                                      state.formVarian[index].hargaVarian),
                                  onChanged: (val) =>
                                      state.formVarian[index].hargaVarian = val,
                                  validator: (val) => val!.length > 1
                                      ? null
                                      : 'Harga Varian Tidak valid',
                                  decoration: const InputDecoration(
                                      labelText: 'Harga',
                                      hintText: '5000',
                                      border: OutlineInputBorder()),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(4),
                                width: MediaQuery.of(context).size.width * 0.14,
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  initialValue:
                                      state.formVarian[index].skuVarian,
                                  onChanged: (val) =>
                                      state.formVarian[index].skuVarian = val,
                                  decoration: const InputDecoration(
                                      labelText: 'Sku',
                                      hintText: '0123',
                                      border: OutlineInputBorder()),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  if (state.formVarian[index].id.isEmpty) {
                                    state.formVarian.removeWhere((dat) =>
                                        dat == state.formVarian[index]);
                                    context.read<RequestVariantBloc>().add(
                                        GetVarianList(
                                            formVarian: state.formVarian));
                                  } else {
                                    int idBarang =
                                        int.parse(state.formVarian[index].id);
                                    state.formVarian.removeWhere((dat) =>
                                        dat == state.formVarian[index]);
                                    context.read<RequestVariantBloc>().add(
                                        DeleteVarian(
                                            formVarian: state.formVarian,
                                            idBarang: idBarang));
                                    context.read<RequestVariantBloc>().add(
                                        GetVarianList(
                                            formVarian: state.formVarian));
                                  }
                                  // print(find);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  width:
                                      MediaQuery.of(context).size.width * 0.04,
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.red,
                                    size: 22,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
              return const SizedBox();
            },
          ),
          // Expanded(
          //   child: ListView.builder(
          //     itemCount: widget.list.length,
          //     itemBuilder: (context, index) {
          //       return widget.list[index];
          //     },
          //   ),
          // )
        ],
      ),
    );
  }
}

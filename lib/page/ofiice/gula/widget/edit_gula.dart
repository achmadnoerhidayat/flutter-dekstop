import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kasir_dekstop/bloc/gula/gula_bloc.dart';
import 'package:kasir_dekstop/helper/number_format.dart';
import 'package:kasir_dekstop/models/gula_model.dart';

class EditGula extends StatefulWidget {
  final GulaModel gulaModel;
  const EditGula({super.key, required this.gulaModel});

  @override
  State<EditGula> createState() => _EditGulaState();
}

class _EditGulaState extends State<EditGula> {
  final formState = GlobalKey<FormState>();
  TextEditingController? txtType;
  TextEditingController? txtBeli;
  TextEditingController? txtJual;
  @override
  void initState() {
    super.initState();
    txtType = TextEditingController();
    txtBeli = TextEditingController();
    txtJual = TextEditingController();
    txtType!.text = widget.gulaModel.type!;
    txtBeli!.text = NumberFormats.convertToIdr(widget.gulaModel.priceBeli!);
    txtJual!.text = NumberFormats.convertToIdr(widget.gulaModel.priceJual!);
  }

  @override
  void dispose() {
    super.dispose();
    txtType!.dispose();
    txtBeli!.dispose();
    txtJual!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formState,
      child: Padding(
        padding: const EdgeInsets.all(8),
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
                      // txtNama!.clear();
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
                  BlocConsumer<GulaBloc, GulaState>(
                    listener: (context, state) {
                      if (state is RequestGulaSuccess) {
                        txtType!.clear();
                        txtBeli!.clear();
                        txtJual!.clear();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              backgroundColor: Colors.blue,
                              content: Text('Success Menambah Gula')),
                        );
                        Navigator.of(context).pop();
                      }
                    },
                    builder: (context, state) {
                      if (state is GulaLoading) {
                        return ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              fixedSize: const Size(150, 70),
                              backgroundColor: const Color(0XFF2334A6)),
                          child: Text(
                            "Save",
                            style: GoogleFonts.playfairDisplay(
                                color: const Color(0XFFFFFFFF), fontSize: 20),
                          ),
                        );
                      }
                      return ElevatedButton(
                        onPressed: () {
                          if (formState.currentState!.validate()) {
                            var req = GulaModel(
                                id: widget.gulaModel.id,
                                type: txtType!.text,
                                priceBeli: txtBeli!.text.replaceAll('.', ''),
                                priceJual: txtJual!.text.replaceAll('.', ''),
                                created: DateTime.now().toIso8601String());
                            context
                                .read<GulaBloc>()
                                .add(UpdateGula(gulaModel: req));
                            context.read<GulaBloc>().add(GetGula());
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            fixedSize: const Size(150, 70),
                            backgroundColor: const Color(0XFF2334A6)),
                        child: Text(
                          "Save",
                          style: GoogleFonts.playfairDisplay(
                              color: const Color(0XFFFFFFFF), fontSize: 20),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              height: 250,
              color: Colors.white,
              padding: const EdgeInsets.all(10),
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  SizedBox(
                    height: 60,
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      controller: txtType,
                      validator: (value) {
                        if (value == '') {
                          return "Type Tidak Boleh Kosong";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        fillColor: Colors.white,
                        contentPadding:
                            const EdgeInsets.only(left: 15, top: 5, bottom: 5),
                        hintText: "Masukan Type Gula",
                        hintStyle: const TextStyle(
                          color: Color(0XFFAA9D9D),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  SizedBox(
                    height: 60,
                    child: TextFormField(
                      controller: txtBeli,
                      validator: (value) {
                        if (value == '') {
                          return "Harga Beli Gula Tidak Boleh Kosong";
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
                        txtBeli!.value = TextEditingValue(
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
                        hintText: "Masukan Harga Beli",
                        hintStyle: const TextStyle(
                          color: Color(0XFFAA9D9D),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  SizedBox(
                    height: 60,
                    child: TextFormField(
                      controller: txtJual,
                      validator: (value) {
                        if (value == '') {
                          return "Harga Jual Gula Tidak Boleh Kosong";
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
                        txtJual!.value = TextEditingValue(
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
                        hintText: "Masukan Harga Jual",
                        hintStyle: const TextStyle(
                          color: Color(0XFFAA9D9D),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

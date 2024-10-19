import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kasir_dekstop/bloc/deb_watch/deb_watch_bloc.dart';
import 'package:kasir_dekstop/bloc/debt_sugar/debt_sugar_bloc.dart';
import 'package:kasir_dekstop/helper/number_format.dart';
import 'package:kasir_dekstop/models/debt_watch_model.dart';

class FormDetailWatch extends StatefulWidget {
  final DebtWatchModel? debtSugarModel;
  const FormDetailWatch({super.key, this.debtSugarModel});

  @override
  State<FormDetailWatch> createState() => _FormDetailWatchState();
}

class _FormDetailWatchState extends State<FormDetailWatch> {
  final formState = GlobalKey<FormState>();
  TextEditingController? txtType;
  TextEditingController? txtNominal;
  TextEditingController? txtNote;
  @override
  void initState() {
    super.initState();
    txtType = TextEditingController();
    txtNominal = TextEditingController();
    txtNote = TextEditingController();
    txtType!.text = "Hutang";
  }

  @override
  void dispose() {
    super.dispose();
    txtType!.dispose();
    txtNominal!.dispose();
    txtNote!.dispose();
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
              height: 135,
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
                  BlocConsumer<DebWatchBloc, DebWatchState>(
                    listener: (context, state) {
                      if (state is RequestDebWatchSuccess) {
                        txtType!.clear();
                        txtNominal!.clear();
                        txtNote!.clear();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              backgroundColor: Colors.blue,
                              content: Text('Success Menambah Hutang Gula')),
                        );
                        Navigator.of(context).pop();
                      }
                    },
                    builder: (context, state) {
                      if (state is DebtSugarLoading) {
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
                            List<DebtWatchDetailModel> debtDetail = [];

                            String nominal = widget.debtSugarModel!.nominal!;
                            if (txtType!.text == "Setor") {
                              int total = int.parse(nominal) -
                                  int.parse(
                                      txtNominal!.text.replaceAll('.', ''));
                              nominal = total.toString();
                            } else {
                              int total = int.parse(nominal) +
                                  int.parse(
                                      txtNominal!.text.replaceAll('.', ''));
                              nominal = total.toString();
                            }

                            debtDetail.add(DebtWatchDetailModel(
                              idKasbon: widget.debtSugarModel!.id.toString(),
                              type: txtType!.text,
                              nominal: txtNominal!.text.replaceAll('.', ''),
                              note: txtNote!.text,
                              created: DateTime.now().toIso8601String(),
                            ));

                            var req = DebtWatchModel(
                              idCustomer: widget.debtSugarModel!.idCustomer!,
                              nominal: nominal,
                              created: DateTime.now().toIso8601String(),
                              kasbonDetail: debtDetail,
                            );

                            context.read<DebWatchBloc>().add(
                                CreateDebtWatchDetail(debtWatchModel: req));

                            context.read<DebWatchBloc>().add(GetDebtWatch());
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
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.76,
                    height: 46,
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                          color: Colors.grey,
                          style: BorderStyle.solid,
                          width: 0.80),
                    ),
                    child: DropdownButton(
                      isExpanded: true,
                      underline: const SizedBox(),
                      hint: const Text("Pilih Customer"),
                      dropdownColor: Colors.white,
                      items: const [
                        DropdownMenuItem(
                          value: "Hutang",
                          child: Text("Hutang"),
                        ),
                        DropdownMenuItem(
                          value: "Setor",
                          child: Text("Setor"),
                        ),
                      ],
                      onChanged: (data) {
                        String kategori = data!;
                        setState(() {
                          txtType!.text = kategori;
                        });
                      },
                      value: txtType!.text,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 60,
                    child: TextFormField(
                      controller: txtNominal,
                      validator: (value) {
                        if (value == '') {
                          return "Nominal Tidak Boleh Kosong";
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
                        txtNominal!.value = TextEditingValue(
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
                        hintText: "Masukan Nominal",
                        hintStyle: const TextStyle(
                          color: Color(0XFFAA9D9D),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 60,
                    child: TextFormField(
                      controller: txtNote,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        fillColor: Colors.white,
                        contentPadding:
                            const EdgeInsets.only(left: 15, top: 5, bottom: 5),
                        hintText: "Masukan Note",
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

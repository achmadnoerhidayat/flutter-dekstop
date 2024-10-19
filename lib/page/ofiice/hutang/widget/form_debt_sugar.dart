import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kasir_dekstop/bloc/customer/customer_bloc.dart';
import 'package:kasir_dekstop/bloc/debt_sugar/debt_sugar_bloc.dart';
import 'package:kasir_dekstop/helper/number_format.dart';
import 'package:kasir_dekstop/models/customer_model.dart';
import 'package:kasir_dekstop/models/debt_sugar_model.dart';

class FormDebtSugar extends StatefulWidget {
  final DebtSugarModel? sugarModel;
  const FormDebtSugar({super.key, this.sugarModel});

  @override
  State<FormDebtSugar> createState() => _FormDebtSugarState();
}

class _FormDebtSugarState extends State<FormDebtSugar> {
  final formState = GlobalKey<FormState>();
  TextEditingController? txtUser;
  TextEditingController? txtNominal;
  @override
  void initState() {
    super.initState();
    context.read<CustomerBloc>().add(GetCustomer());
    txtUser = TextEditingController();
    txtNominal = TextEditingController();
    txtUser!.text = "0";

    if (widget.sugarModel != null) {
      txtUser!.text = widget.sugarModel!.idCustomer!;
      txtNominal!.text =
          NumberFormats.convertToIdr(widget.sugarModel!.nominal!);
    }
  }

  @override
  void dispose() {
    super.dispose();
    txtUser!.dispose();
    txtNominal!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final consumen = BlocBuilder<CustomerBloc, CustomerState>(
      builder: (context, state) {
        if (state is CustomerSuccess) {
          List<CustomerModel> kategori = [];
          if (state.custModel.isNotEmpty) {
            kategori.add(CustomerModel(
              id: 0,
              nama: "Pilih Customer",
              phone: "",
              email: "",
              created: "",
            ));
            for (var varians in state.custModel) {
              kategori.add(varians);
            }
          }
          return Container(
            width: MediaQuery.of(context).size.width * 0.76,
            height: 46,
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                  color: Colors.grey, style: BorderStyle.solid, width: 0.80),
            ),
            child: DropdownButton(
              isExpanded: true,
              underline: const SizedBox(),
              hint: const Text("Pilih Customer"),
              dropdownColor: Colors.white,
              items: kategori.map((val) {
                return DropdownMenuItem(
                  value: "${val.id}",
                  child: Text("${val.nama}"),
                );
              }).toList(),
              onChanged: (data) {
                String kategori = data!;
                setState(() {
                  txtUser!.text = kategori;
                });
              },
              value: txtUser!.text,
            ),
          );
        }
        return Container();
      },
    );
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
                  BlocConsumer<DebtSugarBloc, DebtSugarState>(
                    listener: (context, state) {
                      if (state is RequestDebtSuccess) {
                        txtUser!.clear();
                        txtNominal!.clear();
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
                            if (widget.sugarModel != null) {
                              var req = DebtSugarModel(
                                id: widget.sugarModel!.id!,
                                idCustomer: txtUser!.text,
                                nominal: txtNominal!.text.replaceAll('.', ''),
                                created: DateTime.now().toIso8601String(),
                              );
                              context
                                  .read<DebtSugarBloc>()
                                  .add(UpdateDebtSugar(debtSugarModel: req));
                            } else {
                              List<DebtSugarDetailModel> debtDetail = [];
                              debtDetail.add(DebtSugarDetailModel(
                                  idHutang: "",
                                  type: "Hutang",
                                  nominal: txtNominal!.text.replaceAll('.', ''),
                                  note: "-",
                                  created: DateTime.now().toIso8601String()));
                              var req = DebtSugarModel(
                                  idCustomer: txtUser!.text,
                                  nominal: txtNominal!.text.replaceAll('.', ''),
                                  created: DateTime.now().toIso8601String(),
                                  sugarDetail: debtDetail);
                              context
                                  .read<DebtSugarBloc>()
                                  .add(CreateDebtSugar(debtSugarModel: req));
                            }
                            context.read<DebtSugarBloc>().add(GetDebtSugar());
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
                  consumen,
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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kasir_dekstop/bloc/discount/discount_bloc.dart';
import 'package:kasir_dekstop/models/discount_model.dart';

class EditDiscount extends StatefulWidget {
  final DiscountModel model;
  const EditDiscount({super.key, required this.model});

  @override
  State<EditDiscount> createState() => _EditDiscountState();
}

class _EditDiscountState extends State<EditDiscount> {
  final formState = GlobalKey<FormState>();
  TextEditingController? txtNama;
  TextEditingController? txtJumlah;
  String type = 'persen';
  @override
  void initState() {
    super.initState();
    txtNama = TextEditingController();
    txtJumlah = TextEditingController();
    txtNama!.text = widget.model.nama!;
    txtJumlah!.text = widget.model.jumlah!;
    type = widget.model.type!;
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
                  BlocConsumer<DiscountBloc, DiscountState>(
                    listener: (context, state) {
                      if (state is RequestDiscountSuccess) {
                        txtNama!.clear();
                        txtJumlah!.clear();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              backgroundColor: Colors.blue,
                              content: Text('Success Menambah Discount')),
                        );
                        Navigator.of(context).pop();
                      }
                    },
                    builder: (context, state) {
                      if (state is DiscountLoading) {
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
                            var req = DiscountModel(
                                id: widget.model.id,
                                nama: txtNama!.text,
                                jumlah: txtJumlah!.text,
                                type: type);
                            context
                                .read<DiscountBloc>()
                                .add(UpdateDiscount(discountModel: req));
                            context.read<DiscountBloc>().add(GetDiscount());
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
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.only(
                        top: 5, left: 10, right: 10, bottom: 10),
                    height: 120,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 52,
                          child: SizedBox(
                            height: 60,
                            child: TextFormField(
                              controller: txtNama,
                              validator: (value) {
                                if (value == '') {
                                  return "Nama Discount Tidak Boleh Kosong";
                                }
                                return null;
                              },
                              minLines: 1,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              decoration: const InputDecoration(
                                labelText: "Nama",
                                border: OutlineInputBorder(),
                                hintText: "Masukan Categori",
                                hintStyle: TextStyle(color: Colors.grey),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 8),
                                isDense: true,
                              ),
                              style: const TextStyle(
                                fontSize: 14.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          flex: 25,
                          child: SizedBox(
                            height: 60,
                            child: TextFormField(
                              controller: txtJumlah,
                              validator: (value) {
                                if (value == '') {
                                  return "Jumlah Discount Tidak Boleh Kosong";
                                }
                                if (type == 'persen') {
                                  if (int.parse(value!) > 100) {
                                    return "Format Yang Dimasukan Salah";
                                  }
                                }
                                return null;
                              },
                              minLines: 1,
                              keyboardType: TextInputType.number,
                              maxLines: null,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "Masukan Jumlah Discount",
                                hintStyle: TextStyle(color: Colors.grey),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 8),
                                isDense: true,
                              ),
                              style: const TextStyle(
                                fontSize: 14.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          flex: 18,
                          child: SizedBox(
                            height: 60,
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      type = 'persen';
                                    });
                                  },
                                  child: Container(
                                      width: 50,
                                      margin: const EdgeInsets.only(bottom: 20),
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          color: (type == 'persen')
                                              ? Colors.blue
                                              : Colors.white,
                                          border: Border.all(
                                              color: Colors.black12)),
                                      child: Text(
                                        "%",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: (type == 'persen')
                                                ? Colors.white
                                                : Colors.black),
                                      )),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      type = 'rupiah';
                                    });
                                  },
                                  child: Container(
                                      width: 50,
                                      padding: const EdgeInsets.all(5),
                                      margin: const EdgeInsets.only(bottom: 20),
                                      color: (type == 'rupiah')
                                          ? Colors.blue
                                          : Colors.white,
                                      child: Text(
                                        "Rp",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: (type == 'rupiah')
                                                ? Colors.white
                                                : Colors.black),
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kasir_dekstop/bloc/gula/gula_bloc.dart';
import 'package:kasir_dekstop/helper/number_format.dart';
import 'package:kasir_dekstop/models/gula_model.dart';

class ModalGula extends StatefulWidget {
  final TextEditingController? txtTotGula;
  final List<Map<String, dynamic>>? keterangan;
  const ModalGula(
      {super.key, required this.txtTotGula, required this.keterangan});

  @override
  State<ModalGula> createState() => _ModalGulaState();
}

class _ModalGulaState extends State<ModalGula> {
  String hargaGula = "0";
  TextEditingController? txtWeight;

  @override
  void initState() {
    super.initState();
    var gula = widget.keterangan!.firstWhere(
      (value) => value['title'] == "Beli Gula",
      orElse: () => {},
    );
    context.read<GulaBloc>().add(GetGula());
    if (gula.isNotEmpty) {
      widget.keterangan!.removeWhere((element) => element == gula);
    }
    txtWeight = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    txtWeight!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gula = BlocBuilder<GulaBloc, GulaState>(
      builder: (context, state) {
        if (state is GulaSuccess) {
          List<GulaModel> gulamodel = [];
          if (state.gula.isNotEmpty) {
            gulamodel.add(GulaModel(
                id: 0,
                type: "Pilih Gula",
                priceBeli: "",
                priceJual: "",
                created: ""));
            for (var varians in state.gula) {
              gulamodel.add(varians);
            }
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                width: 300,
                height: 40,
                margin: const EdgeInsets.only(bottom: 10),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: DropdownButton(
                  isExpanded: true,
                  underline: const SizedBox(),
                  hint: const Text("Pilih Gula"),
                  dropdownColor: Colors.white,
                  items: gulamodel.map((e) {
                    return DropdownMenuItem(
                      value: "${e.id}",
                      child: Text(
                          "${e.type} ${NumberFormats.convertToIdr(e.priceBeli!)}"),
                    );
                  }).toList(),
                  onChanged: (data) {
                    String kategori = data!;
                    setState(() {
                      hargaGula = kategori;
                    });
                  },
                  value: hargaGula,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                width: 300,
                height: 40,
                margin: const EdgeInsets.only(bottom: 10),
                child: TextField(
                  keyboardType: TextInputType.text,
                  controller: txtWeight,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    fillColor: Colors.white,
                    contentPadding:
                        const EdgeInsets.only(left: 15, top: 5, bottom: 5),
                    hintText: "Masukan Berat Gula",
                    hintStyle: const TextStyle(
                      color: Color(0XFFAA9D9D),
                    ),
                  ),
                ),
              ),
              Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  width: 300,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      if (txtWeight!.text.isNotEmpty && hargaGula != "0") {
                        var gula = gulamodel.firstWhere(
                            (val) => val.id.toString() == hargaGula);

                        var total = double.parse(txtWeight!.text) *
                            int.parse(gula.priceBeli!);
                        setState(() {
                          widget.txtTotGula!.text =
                              "Rp ${NumberFormats.convertToIdr(total.toInt().toString())}";
                          Map<String, dynamic> data = {
                            "title": "Beli Gula",
                            "harga":
                                "${txtWeight!.text} X ${NumberFormats.convertToIdr(gula.priceBeli!)}",
                            "priceBeli": gula.priceBeli!,
                            "weight": txtWeight!.text,
                            "priceJual": gula.priceJual!,
                            "keterangan": gula.type,
                          };
                          widget.keterangan!.add(data);
                        });
                        Navigator.of(context).pop(
                            true); // Nilai true (atau nilai yang sesuai) yang dikembalikan ke halaman pertama
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: const Color(0XFF2334A6)),
                    child: Text(
                      "Save",
                      style: GoogleFonts.playfairDisplay(
                          color: const Color(0XFFFFFFFF), fontSize: 20),
                    ),
                  )),
            ],
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
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0XFFD9D9D9),
            ),
          ),
          child: ElevatedButton(
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
        ),
        Container(
          height: 200,
          width: double.infinity,
          margin: const EdgeInsets.only(top: 10),
          padding: const EdgeInsets.all(20),
          child: gula,
        )
      ],
    );
  }
}

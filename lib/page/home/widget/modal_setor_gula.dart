import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kasir_dekstop/helper/number_format.dart';

class ModalSetorGula extends StatefulWidget {
  final List<Map<String, dynamic>>? keterangan;
  const ModalSetorGula({super.key, required this.keterangan});

  @override
  State<ModalSetorGula> createState() => _ModalSetorGulaState();
}

class _ModalSetorGulaState extends State<ModalSetorGula> {
  TextEditingController? txtJml;
  TextEditingController? txtKeterangan;

  @override
  void initState() {
    super.initState();
    var gula = widget.keterangan!.firstWhere(
      (value) => value['title'] == "Setor Gula",
      orElse: () => {},
    );
    if (gula.isNotEmpty) {
      widget.keterangan!.removeWhere((element) => element == gula);
    }
    txtJml = TextEditingController();
    txtKeterangan = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    txtJml!.dispose();
    txtKeterangan!.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Setor Gula",
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
        Container(
            height: 200,
            width: double.infinity,
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.all(20),
            child: Column(
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
                  child: TextField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    controller: txtJml,
                    onChanged: (val) {
                      setState(() {
                        if (val.isNotEmpty) {
                          val = val.replaceAll('.', '');
                        } else {
                          val = '';
                        }
                      });
                      txtJml!.value = TextEditingValue(
                        text: NumberFormats.convertToIdr(val),
                        selection: TextSelection.fromPosition(
                          TextPosition(
                              offset: NumberFormats.convertToIdr(val).length),
                        ),
                      );
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      fillColor: Colors.white,
                      contentPadding:
                          const EdgeInsets.only(left: 15, top: 5, bottom: 5),
                      hintText: "Masukan Jumlah Setor",
                      hintStyle: const TextStyle(
                        color: Color(0XFFAA9D9D),
                      ),
                    ),
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
                    controller: txtKeterangan,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      fillColor: Colors.white,
                      contentPadding:
                          const EdgeInsets.only(left: 15, top: 5, bottom: 5),
                      hintText: "Masukan Keterangan",
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
                        if (txtJml!.text.isNotEmpty) {
                          setState(() {
                            String jumlahSetor =
                                txtJml!.text.replaceAll('.', '');
                            Map<String, dynamic> data = {
                              "title": "Setor Gula",
                              "harga":
                                  "Rp ${NumberFormats.convertToIdr(jumlahSetor)}",
                              "keterangan": txtKeterangan!.text
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
            ))
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kasir_dekstop/bloc/suplier/suplier_bloc.dart';
import 'package:kasir_dekstop/models/suplier_model.dart';

class FormSuplier extends StatefulWidget {
  final SuplierModel? suplier;
  const FormSuplier({super.key, this.suplier});

  @override
  State<FormSuplier> createState() => _FormSuplierState();
}

class _FormSuplierState extends State<FormSuplier> {
  final formState = GlobalKey<FormState>();
  TextEditingController? txtNama;
  TextEditingController? txtPhone;
  TextEditingController? txtEmail;
  @override
  void initState() {
    super.initState();
    txtNama = TextEditingController();
    txtPhone = TextEditingController();
    txtEmail = TextEditingController();
    if (widget.suplier != null) {
      txtNama!.text = widget.suplier!.name!;
      txtPhone!.text = widget.suplier!.phone!;
      txtEmail!.text = widget.suplier!.email!;
    }
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
                  BlocConsumer<SuplierBloc, SuplierState>(
                    listener: (context, state) {
                      if (state is RequestSuplier) {
                        txtNama!.clear();
                        txtPhone!.clear();
                        txtEmail!.clear();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              backgroundColor: Colors.blue,
                              content: Text('Success Menambah Suplier')),
                        );
                        Navigator.of(context).pop();
                        context.read<SuplierBloc>().add(GetSuplier());
                      }
                    },
                    builder: (context, state) {
                      if (state is SuplierLoading) {
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
                            if (widget.suplier != null) {
                              var req = SuplierModel(
                                  id: widget.suplier!.id!,
                                  name: txtNama!.text,
                                  phone: txtPhone!.text,
                                  email: txtEmail!.text,
                                  created: widget.suplier!.created!);
                              context
                                  .read<SuplierBloc>()
                                  .add(UpdateSuplier(suplier: req));
                            } else {
                              var req = SuplierModel(
                                  name: txtNama!.text,
                                  phone: txtPhone!.text,
                                  email: txtEmail!.text,
                                  created: DateTime.now().toIso8601String());
                              context
                                  .read<SuplierBloc>()
                                  .add(CreateSuplier(suplier: req));
                            }
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
                    height: 80,
                    child: SizedBox(
                      height: 60,
                      child: TextFormField(
                        controller: txtNama,
                        validator: (value) {
                          if (value == '') {
                            return "Nama Customer Tidak Boleh Kosong";
                          }
                          return null;
                        },
                        minLines: 1,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.only(
                              left: 15, top: 5, bottom: 5),
                          hintText: "Masukan Name",
                          hintStyle: const TextStyle(
                            color: Color(0XFFAA9D9D),
                          ),
                        ),
                        style: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.only(
                        top: 5, left: 10, right: 10, bottom: 10),
                    height: 80,
                    child: SizedBox(
                      height: 60,
                      child: TextFormField(
                        controller: txtPhone,
                        minLines: 1,
                        keyboardType: TextInputType.number,
                        maxLines: null,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.only(
                              left: 15, top: 5, bottom: 5),
                          hintText: "Masukan Phone",
                          hintStyle: const TextStyle(
                            color: Color(0XFFAA9D9D),
                          ),
                        ),
                        style: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.only(
                        top: 5, left: 10, right: 10, bottom: 10),
                    height: 80,
                    child: SizedBox(
                      height: 60,
                      child: TextFormField(
                        controller: txtEmail,
                        minLines: 1,
                        keyboardType: TextInputType.emailAddress,
                        maxLines: null,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.only(
                              left: 15, top: 5, bottom: 5),
                          hintText: "Masukan Email",
                          hintStyle: const TextStyle(
                            color: Color(0XFFAA9D9D),
                          ),
                        ),
                        style: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

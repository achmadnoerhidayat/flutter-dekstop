import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kasir_dekstop/bloc/customer/customer_bloc.dart';
import 'package:kasir_dekstop/models/customer_model.dart';

class EditCustomer extends StatefulWidget {
  final CustomerModel customerModel;
  const EditCustomer({super.key, required this.customerModel});

  @override
  State<EditCustomer> createState() => _EditCustomerState();
}

class _EditCustomerState extends State<EditCustomer> {
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
    txtNama!.text = widget.customerModel.nama!;
    txtPhone!.text = widget.customerModel.phone!;
    txtEmail!.text = widget.customerModel.email!;
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
                  BlocConsumer<CustomerBloc, CustomerState>(
                    listener: (context, state) {
                      if (state is RequestCustomerSuccess) {
                        txtNama!.clear();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              backgroundColor: Colors.blue,
                              content: Text('Success Update Discount')),
                        );
                        Navigator.of(context).pop();
                      }
                    },
                    builder: (context, state) {
                      if (state is CustomerLoading) {
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
                            var req = CustomerModel(
                                id: widget.customerModel.id,
                                nama: txtNama!.text,
                                phone: txtPhone!.text,
                                email: txtEmail!.text,
                                created: widget.customerModel.created);
                            context
                                .read<CustomerBloc>()
                                .add(UpdateCustomer(customerModel: req));
                            context.read<CustomerBloc>().add(GetCustomer());
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
                        decoration: const InputDecoration(
                          labelText: "Nama",
                          border: OutlineInputBorder(),
                          hintText: "Masukan Nama Customer",
                          hintStyle: TextStyle(color: Colors.grey),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),
                          isDense: true,
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
                        decoration: const InputDecoration(
                          labelText: "Phone",
                          border: OutlineInputBorder(),
                          hintText: "Masukan Phone Customer",
                          hintStyle: TextStyle(color: Colors.grey),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),
                          isDense: true,
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
                        decoration: const InputDecoration(
                          labelText: "Email",
                          border: OutlineInputBorder(),
                          hintText: "Masukan Email Customer",
                          hintStyle: TextStyle(color: Colors.grey),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),
                          isDense: true,
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

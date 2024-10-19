import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kasir_dekstop/bloc/bill/bill_bloc.dart';
import 'package:kasir_dekstop/bloc/cart/cart_bloc.dart';
import 'package:kasir_dekstop/models/bill_model.dart';
import 'package:kasir_dekstop/models/cart_model.dart';

class ModalTambahBill extends StatefulWidget {
  final List<CartModel>? keterangan;
  const ModalTambahBill({super.key, required this.keterangan});

  @override
  State<ModalTambahBill> createState() => _ModalTambahBillState();
}

class _ModalTambahBillState extends State<ModalTambahBill> {
  TextEditingController? txtName;
  TextEditingController? txtKeterangan;

  @override
  void initState() {
    super.initState();
    txtName = TextEditingController();
    txtKeterangan = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    txtName!.dispose();
    txtKeterangan!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bill = BlocConsumer<BillBloc, BillState>(
      listener: (context, state) {
        if (state is RequestBillSuccess) {
          for (var dat in widget.keterangan!) {
            int id = dat.id!;
            context.read<CartBloc>().add(DeleteCart(id: id));
          }
          context.read<CartBloc>().add(GetCart());
          Navigator.of(context).pop(
              true); // Nilai true (atau nilai yang sesuai) yang dikembalikan ke halaman pertama
        }
      },
      builder: (context, state) {
        return ElevatedButton(
          onPressed: () {
            if (txtName!.text.isNotEmpty) {
              List<BillCartModel> bil = [];
              widget.keterangan?.forEach((value) {
                bil.add(BillCartModel(
                  billId: null,
                  productId: value.productId,
                  varianId: value.varianId,
                  discountId: value.discountId,
                  customerId: value.customerId,
                  qty: value.qty,
                  created: value.created,
                  varian: value.varian,
                  product: value.product,
                  discon: value.discon,
                  customer: value.customer,
                  diskons: value.diskons,
                ));
              });
              var requuest = BillModel(
                billName: txtName!.text,
                note: txtKeterangan!.text,
                created: DateTime.now().toIso8601String(),
                billCart: bil,
              );

              context.read<BillBloc>().add(CreateBill(billModel: requuest));
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
        );
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Simpan Bill",
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
                    keyboardType: TextInputType.text,
                    controller: txtName,
                    onChanged: (val) {},
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      fillColor: Colors.white,
                      contentPadding:
                          const EdgeInsets.only(left: 15, top: 5, bottom: 5),
                      hintText: "Masukan Nama Bill",
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
                      hintText: "Masukan Keterangan Bill",
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
                  child: bill,
                ),
              ],
            ))
      ],
    );
  }
}

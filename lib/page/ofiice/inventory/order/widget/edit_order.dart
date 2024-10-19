import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kasir_dekstop/bloc/order/order_bloc.dart';
import 'package:kasir_dekstop/models/order_model.dart';

class EditOrder extends StatefulWidget {
  final OrderModel order;
  const EditOrder({super.key, required this.order});

  @override
  State<EditOrder> createState() => _EditOrderState();
}

class _EditOrderState extends State<EditOrder> {
  TextEditingController? txtStatus;
  String today = DateTime.now().toIso8601String().substring(0, 10);
  @override
  void initState() {
    super.initState();
    txtStatus = TextEditingController();
    txtStatus!.text = widget.order.status!;
  }

  @override
  void dispose() {
    super.dispose();
    txtStatus!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.4,
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
            hint: const Text("Pilih Status Pembayaran"),
            dropdownColor: Colors.white,
            items: const [
              DropdownMenuItem(
                value: "0",
                child: Text("Status Pembayaran"),
              ),
              DropdownMenuItem(
                value: "1",
                child: Text("Lunas"),
              ),
              DropdownMenuItem(
                value: "2",
                child: Text("Hutang"),
              ),
            ],
            onChanged: (value) {
              setState(() {
                txtStatus!.text = value!;
              });
            },
            value: txtStatus!.text,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 20),
          height: MediaQuery.of(context).size.height * 0.2,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: const Color(0XFFFFFFFF),
                  fixedSize: const Size(100, 20)),
              child: Text(
                "Cancel",
                style: GoogleFonts.playfairDisplay(
                    color: const Color(0XFF2334A6), fontSize: 14),
              ),
            ),
            BlocConsumer<OrderBloc, OrderState>(
              listener: (context, state) {
                if (state is RequestOrderSuccess) {
                  context.read<OrderBloc>().add(GetOrder(date: today));
                  Navigator.of(context).pop();
                }
              },
              builder: (context, state) {
                return ElevatedButton(
                  onPressed: () {
                    var request = OrderModel(
                      id: widget.order.id,
                      idSuplier: widget.order.idSuplier,
                      noFaktur: widget.order.noFaktur,
                      nominal: widget.order.nominal,
                      status: txtStatus!.text,
                      created: widget.order.created,
                    );
                    context.read<OrderBloc>().add(UpdateOrder(order: request));
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: const Color(0XFF2334A6),
                      fixedSize: const Size(100, 20)),
                  child: Text(
                    "Save",
                    style: GoogleFonts.playfairDisplay(
                        color: const Color(0XFFFFFFFF), fontSize: 14),
                  ),
                );
              },
            )
          ],
        ),
      ],
    );
  }
}

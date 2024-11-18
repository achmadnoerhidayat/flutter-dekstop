// ignore_for_file: must_be_immutable

import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kasir_dekstop/bloc/order/order_bloc.dart';
import 'package:kasir_dekstop/bloc/product/product_bloc.dart';
import 'package:kasir_dekstop/bloc/suplier/suplier_bloc.dart';
import 'package:kasir_dekstop/helper/number_format.dart';
import 'package:kasir_dekstop/models/order_model.dart';

class AddOrder extends StatefulWidget {
  final bool add;
  final ValueChanged<bool> onToggle;
  const AddOrder({super.key, required this.add, required this.onToggle});

  @override
  State<AddOrder> createState() => _AddOrderState();
}

class _AddOrderState extends State<AddOrder> {
  final formState = GlobalKey<FormState>();
  List<OrderDetailModel>? order;
  TextEditingController? txtFaktur;
  TextEditingController? txtNominal;
  TextEditingController? txtStatus;
  SingleValueDropDownController? txtSuplier;
  TextEditingController? txtSearch;
  bool toogle = true;
  int subtotal = 0;
  List<FocusNode> focusNodes = [];
  String today = DateTime.now().toIso8601String().substring(0, 10);
  @override
  void initState() {
    super.initState();
    txtFaktur = TextEditingController();
    txtNominal = TextEditingController();
    txtStatus = TextEditingController();
    txtSuplier = SingleValueDropDownController();
    txtSearch = TextEditingController();
    txtStatus!.text = "0";
    order = [];
  }

  @override
  void dispose() {
    txtFaktur!.dispose();
    txtNominal!.dispose();
    txtStatus!.dispose();
    txtSuplier!.dispose();
    txtSearch!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final barang = BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is ProductSuccess) {
          return ListView.builder(
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(state.product![index].namaBarang),
                onTap: () {
                  setState(() {
                    if (order!.isEmpty) {
                      focusNodes.add(FocusNode());
                      order!.add(OrderDetailModel(
                          idPembelian: "",
                          idProduct: state.product![index].id.toString(),
                          qty: "1",
                          stockBarang: state.product![index].stock,
                          created: DateTime.now().toIso8601String(),
                          harga: state.product![index].hargaModal,
                          subtotal: state.product![index].hargaModal,
                          product: state.product![index]));
                      if (order!.isNotEmpty) {
                        focusNodes[focusNodes.length - 1].requestFocus();
                      }
                    } else {
                      var data = order!.firstWhere(
                        (val) =>
                            val.idProduct ==
                            state.product![index].id.toString(),
                        orElse: () => OrderDetailModel(
                            idPembelian: "", idProduct: "", created: ""),
                      );
                      if (data.idProduct == "") {
                        focusNodes.add(FocusNode());
                        order!.add(OrderDetailModel(
                            idPembelian: "",
                            idProduct: state.product![index].id.toString(),
                            qty: "1",
                            stockBarang: state.product![index].stock,
                            created: DateTime.now().toIso8601String(),
                            harga: state.product![index].hargaModal,
                            subtotal: state.product![index].hargaModal,
                            product: state.product![index]));
                        if (order!.isNotEmpty) {
                          focusNodes[focusNodes.length - 1].requestFocus();
                        }
                      }
                    }
                  });
                  Navigator.of(context).pop();
                  context
                      .read<ProductBloc>()
                      .add(GetProductsByName(nama: "null", type: "search"));
                  txtSearch!.clear();
                  subtotal = 0;
                  order?.forEach((e) {
                    subtotal += int.parse(e.subtotal!);
                  });
                },
                trailing: Text(
                    "Rp ${NumberFormats.convertToIdr(state.product![index].harga)}"),
              );
            },
            itemCount: state.product!.length,
          );
        }
        return Container();
      },
    );

    Future<dynamic> modalAdd(BuildContext context) {
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            insetPadding: EdgeInsets.zero,
            content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              height: MediaQuery.of(context).size.height * 0.6,
              child: Column(
                children: [
                  SizedBox(
                    height: 60,
                    child: TextField(
                      keyboardType: TextInputType.text,
                      onSubmitted: (value) {
                        context.read<ProductBloc>().add(
                            GetProductsByName(nama: value, type: "search"));
                      },
                      controller: txtSearch,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        fillColor: Colors.white,
                        contentPadding:
                            const EdgeInsets.only(left: 15, top: 5, bottom: 5),
                        hintText: "Search Barang",
                        hintStyle: const TextStyle(
                          color: Color(0XFFAA9D9D),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    height: MediaQuery.of(context).size.height * 0.43,
                    child: barang,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          context.read<ProductBloc>().add(
                              GetProductsByName(nama: "null", type: "search"));
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
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    final suplier = BlocBuilder<SuplierBloc, SuplierState>(
      builder: (context, state) {
        if (state is SuplierSuccess) {
          return DropDownTextField(
            controller: txtSuplier,
            clearOption: true,
            enableSearch: true,
            clearIconProperty: IconProperty(color: Colors.green),
            searchTextStyle: const TextStyle(color: Colors.red),
            searchDecoration: const InputDecoration(hintText: "Search Suplier"),
            dropDownItemCount: 6,
            dropDownList: state.suplier.map((e) {
              return DropDownValueModel(name: e.name!, value: e.id.toString());
            }).toList(),
          );
        }
        return Container();
      },
    );

    return Form(
      key: formState,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black12),
          color: Colors.white70,
        ),
        height: 500,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.23,
                    height: 46,
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                          color: Colors.grey,
                          style: BorderStyle.solid,
                          width: 0.80),
                    ),
                    child: suplier,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.23,
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
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 60,
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  controller: txtFaktur,
                  validator: (value) {
                    if (value == '') {
                      return "No Faktur Tidak Boleh Kosong";
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
                    hintText: "Masukan No Faktur",
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
                  keyboardType: TextInputType.text,
                  controller: txtNominal,
                  validator: (value) {
                    if (value == '') {
                      return "Nominal Order Tidak Boleh Kosong";
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
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    fillColor: Colors.white,
                    contentPadding:
                        const EdgeInsets.only(left: 15, top: 5, bottom: 5),
                    hintText: "Masukan Nominal Order",
                    hintStyle: const TextStyle(
                      color: Color(0XFFAA9D9D),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              const Row(
                children: [
                  Expanded(
                    child: Text(
                      "ITEM",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      "IN STOCK",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      "ORDER",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      "UNIT COST",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      "TOTAL",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height * .25),
                child: Column(
                  children: order!.map((e) {
                    int index = order!.indexOf(e);
                    TextEditingController txtProduct =
                        TextEditingController.fromValue(TextEditingValue(
                            text: e.product!.namaBarang,
                            selection: TextSelection.collapsed(
                                offset: e.product!.namaBarang.length)));
                    TextEditingController txtStok =
                        TextEditingController.fromValue(TextEditingValue(
                            text: e.product!.stock,
                            selection: TextSelection.collapsed(
                                offset: e.product!.stock.length)));

                    TextEditingController txtOrder =
                        TextEditingController.fromValue(TextEditingValue(
                            text: e.qty!,
                            selection: TextSelection.collapsed(
                                offset: e.qty!.length)));

                    TextEditingController txtprice =
                        TextEditingController.fromValue(TextEditingValue(
                            text: e.harga!,
                            selection: TextSelection.collapsed(
                                offset: e.harga!.length)));

                    TextEditingController txtSubtotal =
                        TextEditingController.fromValue(TextEditingValue(
                      text: e.subtotal!,
                    ));
                    for (var focus in focusNodes) {
                      focus.addListener(() {
                        if (focus.hasFocus) {
                          txtOrder.selection = TextSelection(
                            baseOffset: 0,
                            extentOffset: txtOrder.text.length,
                          );
                        }
                      });
                    }
                    return Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: txtProduct,
                              readOnly: true,
                              keyboardType: TextInputType.text,
                              style: const TextStyle(fontSize: 12),
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.only(
                                    left: 15, top: 5, bottom: 5),
                                hintText: "Masukan Nominal Order",
                                hintStyle: TextStyle(
                                  color: Color(0XFFAA9D9D),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: txtStok,
                              readOnly: true,
                              style: const TextStyle(fontSize: 12),
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.only(
                                    left: 15, top: 5, bottom: 5),
                                hintText: "Masukan Nominal Order",
                                hintStyle: TextStyle(
                                    color: Color(0XFFAA9D9D), fontSize: 12),
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              focusNode: focusNodes[index],
                              controller: txtOrder,
                              onTap: () => txtOrder.selection = TextSelection(
                                  baseOffset: 0,
                                  extentOffset: txtOrder.value.text.length),
                              onChanged: (value) {
                                if (value == "") {
                                  value = "1";
                                }
                                setState(() {
                                  var total = int.parse(value) *
                                      int.parse(txtprice.text);
                                  e.qty = value;
                                  e.subtotal = total.toString();
                                });
                                subtotal = 0;
                                order?.forEach((e) {
                                  subtotal += int.parse(e.subtotal!);
                                });
                              },
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.only(
                                    left: 15, top: 5, bottom: 5),
                                hintText: "Order",
                                hintStyle: TextStyle(
                                    color: Color(0XFFAA9D9D), fontSize: 16),
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: txtprice,
                              onChanged: (value) {
                                if (value == "") {
                                  value = "1";
                                }
                                setState(() {
                                  e.harga = value;
                                  txtprice.text = value;
                                  int total = int.parse(value) *
                                      int.parse(txtOrder.text);
                                  e.subtotal = total.toString();
                                });
                                subtotal = 0;
                                order?.forEach((e) {
                                  subtotal += int.parse(e.subtotal!);
                                });
                              },
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.only(
                                    left: 15, top: 5, bottom: 5),
                                hintText: "Price",
                                hintStyle: TextStyle(
                                  color: Color(0XFFAA9D9D),
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: txtSubtotal,
                              readOnly: true,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.only(
                                    left: 15, top: 5, bottom: 5),
                                hintText: "Masukan Nominal Order",
                                hintStyle: TextStyle(
                                  color: Color(0XFFAA9D9D),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    focusNodes[index].dispose();
                                    order!.removeWhere(
                                        (val) => val.idProduct == e.idProduct);
                                    focusNodes.removeAt(index);
                                  });
                                },
                                icon: const Icon(Icons.close)),
                          )
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                        fontSize: 18),
                  ),
                  Text(
                    "Rp ${NumberFormats.convertToIdr(subtotal.toString())}",
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                        fontSize: 18),
                  )
                ],
              ),
              const SizedBox(height: 10),
              BlocConsumer<OrderBloc, OrderState>(
                listener: (context, state) {
                  if (state is ModalShow) {
                    modalAdd(state.context);
                  }
                },
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed: () {
                      context.read<OrderBloc>().add(Modal(context: context));
                      context.read<OrderBloc>().add(GetOrder(date: today));
                    },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: const Color(0XFF2334A6),
                        fixedSize:
                            Size(MediaQuery.of(context).size.width * 1, 20)),
                    child: Text(
                      "Add Items",
                      style: GoogleFonts.playfairDisplay(
                          color: const Color(0XFFFFFFFF), fontSize: 14),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          widget.onToggle(false);
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
                      const SizedBox(width: 10),
                      BlocConsumer<OrderBloc, OrderState>(
                        listener: (context, state) {
                          if (state is RequestOrderSuccess) {
                            widget.onToggle(false);
                            context
                                .read<OrderBloc>()
                                .add(GetOrder(date: today));
                          }
                        },
                        builder: (context, state) {
                          return ElevatedButton(
                            onPressed: () {
                              if (formState.currentState!.validate()) {
                                var request = OrderModel(
                                    idSuplier: txtSuplier!.dropDownValue!.value,
                                    noFaktur: txtFaktur!.text,
                                    nominal:
                                        txtNominal!.text.replaceAll('.', ''),
                                    status: txtStatus!.text,
                                    created: DateTime.now().toIso8601String(),
                                    detail: order);
                                context
                                    .read<OrderBloc>()
                                    .add(CreateOrder(order: request));
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                backgroundColor: const Color(0XFF2334A6),
                                fixedSize: const Size(100, 20)),
                            child: Text(
                              "Create",
                              style: GoogleFonts.playfairDisplay(
                                  color: const Color(0XFFFFFFFF), fontSize: 14),
                            ),
                          );
                        },
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

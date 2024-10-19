import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kasir_dekstop/bloc/adjustment/adjustment_bloc.dart';
import 'package:kasir_dekstop/bloc/product/product_bloc.dart';
import 'package:kasir_dekstop/helper/number_format.dart';
import 'package:kasir_dekstop/models/adjustment_model.dart';

class FormAdjustment extends StatefulWidget {
  final bool add;
  final ValueChanged<bool> onToggle;
  const FormAdjustment({super.key, required this.add, required this.onToggle});

  @override
  State<FormAdjustment> createState() => _FormAdjustmentState();
}

class _FormAdjustmentState extends State<FormAdjustment> {
  final formState = GlobalKey<FormState>();
  TextEditingController? txtNote;
  TextEditingController? txtSearch;
  bool toogle = true;
  int subtotal = 0;
  List<FocusNode> focusNodes = [];
  List<AdjustmentModelDetail> order = [];
  String today = DateTime.now().toIso8601String().substring(0, 10);
  bool status = false;
  @override
  void initState() {
    super.initState();
    txtNote = TextEditingController();
    txtSearch = TextEditingController();
  }

  @override
  void dispose() {
    txtNote!.dispose();
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
                    if (order.isEmpty) {
                      focusNodes.add(FocusNode());
                      order.add(AdjustmentModelDetail(
                        idAdjustment: null,
                        idProduct: state.product![index].id.toString(),
                        hargaModal: state.product![index].hargaModal,
                        stock: "",
                        created: DateTime.now().toIso8601String(),
                        product: state.product![index],
                      ));
                      if (order.isNotEmpty) {
                        focusNodes[focusNodes.length - 1].requestFocus();
                      }
                    } else {
                      var data = order.firstWhere(
                        (val) =>
                            val.idProduct ==
                            state.product![index].id.toString(),
                        orElse: () => AdjustmentModelDetail(
                          idAdjustment: null,
                          idProduct: "",
                          hargaModal: "",
                          stock: "",
                          created: "",
                        ),
                      );
                      if (data.idProduct == "") {
                        focusNodes.add(FocusNode());
                        order.add(AdjustmentModelDetail(
                          idAdjustment: null,
                          idProduct: state.product![index].id.toString(),
                          hargaModal: state.product![index].hargaModal,
                          stock: "",
                          created: DateTime.now().toIso8601String(),
                          product: state.product![index],
                        ));
                        if (order.isNotEmpty) {
                          focusNodes[focusNodes.length - 1].requestFocus();
                        }
                      }
                    }
                  });
                  Navigator.of(context).pop();
                  txtSearch!.clear();
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
              SizedBox(
                height: 60,
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  controller: txtNote,
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
                    hintText: "Masukan Notes",
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
                      "ACTUAL STOCK",
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
                  children: order.map((e) {
                    int index = order.indexOf(e);
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

                    TextEditingController txtStockUdj =
                        TextEditingController.fromValue(TextEditingValue(
                            text: e.stock!,
                            selection: TextSelection.collapsed(
                                offset: e.stock!.length)));

                    for (var focus in focusNodes) {
                      focus.addListener(() {
                        if (focus.hasFocus) {
                          txtStockUdj.selection = TextSelection(
                            baseOffset: 0,
                            extentOffset: txtStockUdj.text.length,
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
                              focusNode: focusNodes[index],
                              controller: txtStockUdj,
                              onChanged: (value) {
                                if (value == "") {
                                  value = "1";
                                }
                                setState(() {
                                  e.stock = value;
                                });
                              },
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
                          SizedBox(
                            child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    focusNodes[index].dispose();
                                    order.removeWhere(
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
              const SizedBox(height: 10),
              BlocConsumer<AdjustmentBloc, AdjustmentState>(
                listener: (context, state) {
                  if (state is ModalShow) {
                    modalAdd(state.context);
                  }
                },
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed: () {
                      context
                          .read<AdjustmentBloc>()
                          .add(Modal(context: context));
                      // context.read<OrderBloc>().add(GetOrder(date: today));
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
                      BlocConsumer<AdjustmentBloc, AdjustmentState>(
                        listener: (context, state) {
                          if (state is Requestadjustment) {
                            widget.onToggle(false);
                            // context
                            //     .read<OrderBloc>()
                            //     .add(GetOrder(date: today));
                          }
                        },
                        builder: (context, state) {
                          return ElevatedButton(
                            onPressed: () {
                              if (formState.currentState!.validate()) {
                                List<AdjustmentModelDetail> detail = [];
                                for (var data in order) {
                                  int total = int.parse(data.product!.stock) -
                                      int.parse(data.stock!);
                                  detail.add(AdjustmentModelDetail(
                                    idAdjustment: data.idAdjustment,
                                    idProduct: data.idProduct,
                                    hargaModal: data.hargaModal,
                                    stock: data.stock,
                                    adjustment: total.toString(),
                                    created: data.created,
                                    product: data.product,
                                  ));
                                }
                                var request = AdjustmentModel(
                                    note: txtNote!.text,
                                    created: DateTime.now().toIso8601String(),
                                    detail: detail);
                                context
                                    .read<AdjustmentBloc>()
                                    .add(CreateAdjustment(adjustment: request));
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

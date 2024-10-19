import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kasir_dekstop/bloc/cart/cart_bloc.dart';
import 'package:kasir_dekstop/helper/number_format.dart';
import 'package:kasir_dekstop/models/cart_model.dart';
import 'package:kasir_dekstop/models/discount_model.dart';

// ignore: must_be_immutable
class ModalCartProduct extends StatefulWidget {
  CartModel cart;
  final ValueChanged<int> onToggle;
  final int index;
  ModalCartProduct(
      {super.key,
      required this.cart,
      required this.onToggle,
      required this.index});

  @override
  State<ModalCartProduct> createState() => _ModalCartProductState();
}

class _ModalCartProductState extends State<ModalCartProduct> {
  TextEditingController? txtQty;
  String? price;
  String? priceVarian;
  String? idVarian;
  String? idDiskon;
  DiscountModel? discountModel;
  FocusNode focusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    if (widget.cart.varianId == null) {
      double harga = double.parse(widget.cart.product!.harga) *
          double.parse(widget.cart.qty!);
      price = harga.toString();
      priceVarian = "";
    } else {
      idVarian = widget.cart.varianId;
      double harga = double.parse(widget.cart.varian!.hargaVarian) *
          double.parse(widget.cart.qty!);
      price = harga.toString();
      priceVarian = widget.cart.varian!.hargaVarian;
    }
    if (widget.cart.discountId != null) {
      idDiskon = "${widget.cart.discon!.id}";
      discountModel = widget.cart.discon;
      if (widget.cart.discon!.type == 'persen') {
        var diskon =
            (int.parse(widget.cart.discon!.jumlah!) * int.parse(price!)) / 100;
        double hasil = 0.0;
        hasil = int.parse(price!) - diskon;
        price = "${hasil.toInt()}";
      }
    }
    txtQty = TextEditingController();
    txtQty?.text = widget.cart.qty!;
    focusNode.requestFocus();
    txtQty!.selection =
        TextSelection(baseOffset: 0, extentOffset: txtQty!.value.text.length);
  }

  @override
  void dispose() {
    super.dispose();
    txtQty!.dispose();
    focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 100,
          padding: const EdgeInsets.only(left: 10, right: 10),
          decoration:
              BoxDecoration(border: Border.all(color: const Color(0XFFD9D9D9))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  txtQty!.text = "1";
                  price = "";
                  widget.onToggle(widget.index);
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
              Row(
                children: [
                  Text(
                    widget.cart.product!.namaBarang,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    "-",
                    style: GoogleFonts.play(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    NumberFormats.convertToIdr(price!),
                    style: GoogleFonts.play(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ],
              ),
              BlocConsumer<CartBloc, CartState>(
                listener: (context, state) {
                  if (state is RequestCartSuccess) {
                    txtQty!.text = "1";
                    price = "";
                    widget.cart.product!.varian?.forEach((val) {
                      val.status = false;
                    });
                    Navigator.of(context).pop();
                    widget.onToggle(widget.index);
                    context.read<CartBloc>().add(GetCart());
                  }
                },
                builder: (context, state) {
                  if (state is CartLoading) {
                    return ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          fixedSize: const Size(150, 70),
                          backgroundColor: const Color(0XFF2334A6)),
                      child: Text(
                        "Save",
                        style: GoogleFonts.playfairDisplay(
                            color: Colors.white, fontSize: 20),
                      ),
                    );
                  }
                  return ElevatedButton(
                    onPressed: () {
                      var request = CartModel(
                          id: widget.cart.id,
                          productId: widget.cart.product!.id.toString(),
                          qty: txtQty!.text,
                          varianId: (idVarian == "") ? null : idVarian,
                          discountId: (idDiskon == "") ? null : idDiskon,
                          customerId: null,
                          created: widget.cart.created);
                      context.read<CartBloc>().add(UpdateCart(cart: request));
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
                          color: Colors.white, fontSize: 20),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        Text(
          "Qty",
          style: GoogleFonts.playfairDisplay(fontSize: 24),
        ),
        SizedBox(
          height: 100,
          child: Padding(
            padding: const EdgeInsets.only(left: 5, right: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    int txt = int.parse(txtQty!.text) - 1;
                    if (txt >= 1) {
                      txtQty!.text = "$txt";
                      int total = 0;
                      if (priceVarian == "") {
                        total = int.parse(txtQty!.text) *
                            int.parse(widget.cart.product!.harga);
                      } else {
                        total =
                            int.parse(txtQty!.text) * int.parse(priceVarian!);
                      }
                      if (idDiskon != null) {
                        if (discountModel!.type == 'persen') {
                          var diskon =
                              (int.parse(discountModel!.jumlah!) * total) / 100;
                          double hasil = 0.0;
                          hasil = total - diskon;
                          total = hasil.toInt();
                        }
                      }
                      setState(() {
                        price = total.toString();
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      fixedSize:
                          Size(MediaQuery.of(context).size.width * 0.1, 60),
                      backgroundColor: const Color(0XFFFFFFFF)),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    child: const Icon(Icons.minimize),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 15),
                  width: MediaQuery.of(context).size.width * 0.55,
                  height: 60,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    color: Colors.white,
                    child: BlocConsumer<CartBloc, CartState>(
                      listener: (context, state) {
                        if (state is RequestCartSuccess) {
                          txtQty!.text = "1";
                          price = "";
                          widget.cart.product!.varian?.forEach((val) {
                            val.status = false;
                          });
                          Future.delayed(const Duration(milliseconds: 100), () {
                            if (Navigator.canPop(context)) {
                              Navigator.of(context).pop();
                            }
                            widget.onToggle(widget.index);
                            context.read<CartBloc>().add(GetCart());
                          });
                        }
                      },
                      builder: (context, state) {
                        if (state is CartLoading) {
                          return TextField(
                            controller: txtQty,
                            focusNode: focusNode,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            onTap: () => txtQty!.selection = TextSelection(
                                baseOffset: 0,
                                extentOffset: txtQty!.value.text.length),
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                if (value != ".") {
                                  txtQty!.text = value;
                                  double total = 0;
                                  if (priceVarian == "") {
                                    total = double.parse(txtQty!.text) *
                                        double.parse(
                                            widget.cart.product!.harga);
                                  } else {
                                    total = double.parse(txtQty!.text).toInt() *
                                        double.parse(priceVarian!);
                                  }
                                  setState(() {
                                    price = total.toInt().toString();
                                  });
                                }
                              }
                            },
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                contentPadding: const EdgeInsets.only(
                                    left: 35, top: 8, bottom: 15),
                                fillColor: Colors.white,
                                hintText: "Qty",
                                hintStyle:
                                    const TextStyle(color: Color(0XFFAA9D9D))),
                          );
                        }
                        return TextField(
                          controller: txtQty,
                          focusNode: focusNode,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          onTap: () => txtQty!.selection = TextSelection(
                              baseOffset: 0,
                              extentOffset: txtQty!.value.text.length),
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              if (value != ".") {
                                txtQty!.text = value;
                                double total = 0;
                                if (priceVarian == "") {
                                  total = double.parse(txtQty!.text) *
                                      double.parse(widget.cart.product!.harga);
                                } else {
                                  total = double.parse(txtQty!.text).toInt() *
                                      double.parse(priceVarian!);
                                }
                                setState(() {
                                  price = total.toInt().toString();
                                });
                              }
                            }
                          },
                          onSubmitted: (value) {
                            var request = CartModel(
                                id: widget.cart.id,
                                productId: widget.cart.product!.id.toString(),
                                qty: txtQty!.text,
                                varianId: (idVarian == "") ? null : idVarian,
                                discountId: (idDiskon == "") ? null : idDiskon,
                                customerId: null,
                                created: widget.cart.created);
                            context
                                .read<CartBloc>()
                                .add(UpdateCart(cart: request));
                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              contentPadding: const EdgeInsets.only(
                                  left: 35, top: 8, bottom: 15),
                              fillColor: Colors.white,
                              hintText: "Qty",
                              hintStyle:
                                  const TextStyle(color: Color(0XFFAA9D9D))),
                        );
                      },
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    int txt = int.parse(txtQty!.text) + 1;
                    txtQty!.text = "$txt";
                    int total = 0;
                    if (priceVarian!.isEmpty) {
                      total = int.parse(txtQty!.text) *
                          int.parse(widget.cart.product!.harga);
                    } else {
                      total = int.parse(txtQty!.text) * int.parse(priceVarian!);
                    }
                    if (idDiskon != null) {
                      if (discountModel!.type == 'persen') {
                        var diskon =
                            (int.parse(discountModel!.jumlah!) * total) / 100;
                        double hasil = 0.0;
                        hasil = total - diskon;
                        total = hasil.toInt();
                      }
                    }
                    setState(() {
                      price = total.toString();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      fixedSize:
                          Size(MediaQuery.of(context).size.width * 0.1, 60),
                      backgroundColor: const Color(0XFFFFFFFF)),
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ),
        ),
        Text(
          "Variant",
          style: GoogleFonts.playfairDisplay(fontSize: 24),
        ),
        const SizedBox(height: 15),
        Expanded(
          child: GridView(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // number of items in each row
              mainAxisExtent: 65,
              mainAxisSpacing: 5, // spacing between columns
            ),
            children: widget.cart.product!.varian!.map((e) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                child: ElevatedButton(
                  onPressed: () {
                    double total = 0;
                    setState(() {
                      total = double.parse(txtQty!.text) *
                          double.parse(e.hargaVarian);
                      price = total.toString();
                      priceVarian = e.hargaVarian;
                      idVarian = e.id.toString();
                      e.status = !e.status;
                      if (!e.status) {
                        total = double.parse(txtQty!.text) *
                            double.parse(widget.cart.product!.harga);
                        price = total.toString();
                        priceVarian = "";
                        idVarian = "";
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      fixedSize: const Size(150, 70),
                      backgroundColor: (e.status)
                          ? const Color(0XFF2334A6)
                          : const Color(0XFFFFFFFF)),
                  child: Text(
                    e.namaVarian,
                    style: GoogleFonts.playfairDisplay(
                        color:
                            (e.status) ? Colors.white : const Color(0XFF2334A6),
                        fontSize: 20),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        Text(
          "Discount",
          style: GoogleFonts.playfairDisplay(fontSize: 24),
        ),
        const SizedBox(height: 15),
        Expanded(
          child: GridView(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // number of items in each row
              mainAxisExtent: 65,
              mainAxisSpacing: 5, // spacing between columns
            ),
            children: widget.cart.diskons!.map((e) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                child: ElevatedButton(
                  onPressed: () {
                    if (e.type == 'persen') {
                      setState(() {
                        var diskon = (int.parse(e.jumlah!) *
                                int.parse(price!.replaceAll('.', ''))) /
                            100;
                        double hasil = 0.0;
                        idDiskon = e.id.toString();
                        if (!e.status) {
                          hasil = int.parse(price!) - diskon;
                          e.status = true;
                          discountModel = e;
                        } else {
                          e.status = false;
                          idDiskon = null;
                          if (idVarian == null) {
                            hasil = double.parse(widget.cart.product!.harga) *
                                int.parse(txtQty!.text);
                          } else {
                            hasil = double.parse(priceVarian!) *
                                int.parse(txtQty!.text);
                          }
                        }
                        price = "${hasil.toInt()}";
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      fixedSize: const Size(150, 70),
                      backgroundColor: (e.status)
                          ? const Color(0XFF2334A6)
                          : const Color(0XFFFFFFFF)),
                  child: (e.type == 'persen')
                      ? Text(
                          "${e.nama!} ${e.jumlah} %",
                          style: GoogleFonts.play(
                              color: (e.status)
                                  ? const Color(0XFFFFFFFF)
                                  : const Color(0XFF2334A6),
                              fontSize: 20),
                        )
                      : Text(
                          "${e.nama!} Rp ${e.jumlah}",
                          style: GoogleFonts.play(
                              color: const Color(0XFF2334A6), fontSize: 20),
                        ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

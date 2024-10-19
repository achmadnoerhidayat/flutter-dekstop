// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kasir_dekstop/bloc/cart/cart_bloc.dart';
import 'package:kasir_dekstop/bloc/product/product_bloc.dart';
import 'package:kasir_dekstop/helper/number_format.dart';
import 'package:kasir_dekstop/models/cart_model.dart';
import 'package:kasir_dekstop/models/varian_reesponse_model.dart';

// ignore: must_be_immutable
class ModalProduct extends StatefulWidget {
  String? namaProduct;
  final ValueChanged<int?> onToggle;
  ModalProduct({super.key, required this.namaProduct, required this.onToggle});

  @override
  State<ModalProduct> createState() => _ModalProductState();
}

class _ModalProductState extends State<ModalProduct> {
  List<TextEditingController> controllers = [];
  @override
  void initState() {
    super.initState();
    context
        .read<ProductBloc>()
        .add(GetProductsByName(nama: widget.namaProduct!, type: 'search'));
  }

  @override
  Widget build(BuildContext context) {
    final product = BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is ProductSuccess) {
          return DataTable(
              border: TableBorder.all(width: 0, color: Colors.white),
              showCheckboxColumn: false,
              headingRowColor: WidgetStateColor.resolveWith(
                  (states) => const Color(0xFFC2BEBE)),
              columns: const [
                DataColumn(label: Text("Nama Barang")),
                DataColumn(label: Text("Varian")),
                DataColumn(label: Text("Harga")),
                DataColumn(label: Text("Aksi")),
              ],
              rows: state.product!.map((e) {
                int key = state.product!.indexOf(e);
                for (int i = 0; i < state.product!.length; i++) {
                  controllers.add(TextEditingController.fromValue(
                      const TextEditingValue(text: '0')));
                }
                List<VarianResponseModel> varian = [];
                if (e.varian!.isNotEmpty) {
                  varian.add(VarianResponseModel(
                      id: 0,
                      idBarang: "",
                      namaVarian: "Pilih Varian",
                      hargaVarian: "",
                      skuVarian: "",
                      stokVarian: "",
                      hargaModalVarian: ""));
                  e.varian?.forEach((varians) {
                    varian.add(varians);
                  });
                }
                return DataRow(
                    color: WidgetStateProperty.all(Colors.white),
                    cells: [
                      DataCell(Text(e.namaBarang)),
                      DataCell(
                        (varian.isNotEmpty)
                            ? Container(
                                width: MediaQuery.of(context).size.width * 0.2,
                                height: 46,
                                padding: const EdgeInsets.all(10.0),
                                child: DropdownButton(
                                  isExpanded: true,
                                  underline: const SizedBox(),
                                  hint: const Text("Pilih Kategori Surat"),
                                  dropdownColor: Colors.white,
                                  items: varian.map((val) {
                                    return DropdownMenuItem(
                                      value: "${val.id}",
                                      child: Text(val.namaVarian),
                                    );
                                  }).toList(),
                                  onChanged: (data) {
                                    String kategori = data!;
                                    setState(() {
                                      controllers[key].text = kategori;
                                    });
                                  },
                                  value: controllers[key].text,
                                ),
                              )
                            : Container(),
                      ),
                      DataCell(Text((controllers[key].text == '0')
                          ? NumberFormats.convertToIdr(e.harga)
                          : NumberFormats.convertToIdr(e.varian!
                              .firstWhere((elem) =>
                                  elem.id.toString() == controllers[key].text)
                              .hargaVarian))),
                      DataCell(
                        BlocConsumer<CartBloc, CartState>(
                          listener: (context, state) {
                            if (state is RequestCartSuccess) {
                              if (Navigator.of(context).canPop()) {
                                Navigator.of(context).pop();
                              } else {
                                // Optionally handle this case where there are no pages left to pop
                                print('No pages left to pop');
                              }
                              widget.onToggle(null);
                              context.read<CartBloc>().add(GetCart());
                            }
                          },
                          builder: (context, state) {
                            if (state is CartLoading) {
                              return IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {},
                              );
                            }
                            return IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                var request = CartModel(
                                    productId: e.id.toString(),
                                    qty: '1',
                                    varianId: (controllers[key].text == "0")
                                        ? null
                                        : controllers[key].text,
                                    discountId: null,
                                    customerId: null,
                                    created: DateTime.now().toIso8601String());
                                context
                                    .read<CartBloc>()
                                    .add(CreateCart(cart: request));
                              },
                            );
                          },
                        ),
                      ),
                    ]);
              }).toList());
        }
        return Container();
      },
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 60,
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
                fixedSize: const Size(150, 70),
                backgroundColor: const Color(0XFFFFFFFF)),
            child: Text(
              "Cancel",
              style: GoogleFonts.playfairDisplay(
                  color: const Color(0XFF2334A6), fontSize: 20),
            ),
          ),
        ),
        Container(
            height: MediaQuery.of(context).size.height * .65,
            margin: const EdgeInsets.only(top: 10),
            child: ListView(
              children: [
                product,
              ],
            ))
      ],
    );
  }
}

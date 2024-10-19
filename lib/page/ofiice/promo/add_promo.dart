import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:kasir_dekstop/bloc/product/product_bloc.dart';
import 'package:kasir_dekstop/bloc/promo/promo_bloc.dart';
import 'package:kasir_dekstop/helper/number_format.dart';
import 'package:kasir_dekstop/models/product_models.dart';
import 'package:kasir_dekstop/models/promo_model.dart';
import 'package:kasir_dekstop/models/promo_product_model.dart';
import 'package:kasir_dekstop/page/ofiice/promo/promo_screen.dart';

class AddPromo extends StatefulWidget {
  static String routeName = '/ofice/add-promo';
  const AddPromo({super.key});

  @override
  State<AddPromo> createState() => _AddPromoState();
}

class _AddPromoState extends State<AddPromo> {
  int _currentStep = 0;
  final formState = GlobalKey<FormState>();
  final NumberFormat _numberFormat =
      NumberFormat.currency(locale: 'id', symbol: '');
  TextEditingController? txtJudul;
  TextEditingController? dateMulai;
  TextEditingController? dateBerakhir;
  List<PromoProductModel> prod = [];
  DateTime? _date = DateTime.now();

  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(GetProducts());
    txtJudul = TextEditingController();
    dateMulai = TextEditingController();
    dateBerakhir = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final productBlock = BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is ProductLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is ProductSuccess) {
          return DataTable(
            border: TableBorder.all(width: 0, color: Colors.white),
            showCheckboxColumn: false,
            headingRowColor: WidgetStateColor.resolveWith(
                (states) => const Color(0xFFC2BEBE)),
            columns: [
              DataColumn(
                label: ConstrainedBox(
                  constraints: const BoxConstraints(),
                  child: Text(
                    "#",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.playfairDisplay(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: const Color(0XFF000000)),
                  ),
                ),
              ),
              DataColumn(
                label: ConstrainedBox(
                  constraints: const BoxConstraints(),
                  child: Text(
                    "Name",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.playfairDisplay(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: const Color(0XFF000000)),
                  ),
                ),
              ),
              DataColumn(
                label: ConstrainedBox(
                  constraints: const BoxConstraints(),
                  child: Text(
                    "Harga Jual",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.playfairDisplay(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: const Color(0XFF000000)),
                  ),
                ),
              ),
            ],
            rows: [
              for (var i = 0; i < state.product!.length; i++)
                DataRow(
                  color: WidgetStateProperty.all(Colors.white),
                  cells: [
                    DataCell(ConstrainedBox(
                      constraints: const BoxConstraints(),
                      child: (state.product![i].promoProducts == null)
                          ? Checkbox(
                              value: state.product![i].cheked,
                              onChanged: (val) {
                                String idProduct = "${state.product![i].id}";
                                ProductsModel productsModel = state.product![i];
                                setState(() {
                                  if (val! == true) {
                                    prod.add(PromoProductModel(
                                        idPromo: "",
                                        idProduct: idProduct,
                                        hargaPromo: "",
                                        discount: "",
                                        minBelanja: "",
                                        product: productsModel));
                                  } else {
                                    prod.removeWhere((element) =>
                                        element.idProduct == idProduct);
                                  }
                                  state.product![i].cheked = val;
                                });
                              })
                          : const Checkbox(value: false, onChanged: null),
                    )),
                    DataCell(ConstrainedBox(
                      constraints: const BoxConstraints(),
                      child: Text(
                        state.product![i].namaBarang,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.playfairDisplay(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: const Color(0XFF000000)),
                      ),
                    )),
                    DataCell(ConstrainedBox(
                      constraints: const BoxConstraints(),
                      child: Text(
                        "Rp ${NumberFormats.convertToIdr(state.product![i].harga)}",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.play(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: const Color(0XFF000000)),
                      ),
                    )),
                  ],
                )
            ],
          );
        }
        return const Center(
          child: Text("data tidak ditemukan"),
        );
      },
    );
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formState,
          child: Stepper(
            controlsBuilder: (context, details) {
              return const SizedBox();
            },
            type: StepperType.horizontal,
            currentStep: _currentStep,
            steps: [
              Step(
                state:
                    _currentStep <= 1 ? StepState.editing : StepState.complete,
                isActive: _currentStep >= 1,
                title: const Text("Info Promo"),
                content: Container(
                  constraints: const BoxConstraints(
                      minHeight: 100,
                      minWidth: double.infinity,
                      maxHeight: 600),
                  child: ListView(
                    children: [
                      Container(
                        color: Colors.white,
                        padding: const EdgeInsets.only(
                            top: 5, left: 10, right: 10, bottom: 10),
                        height: 80,
                        child: SizedBox(
                          height: 60,
                          child: TextFormField(
                            controller: txtJudul,
                            minLines: 1,
                            keyboardType: TextInputType.emailAddress,
                            maxLines: null,
                            validator: (value) {
                              if (value == '') {
                                return "Judul Tidak Boleh Kosong";
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              labelText: "Judul",
                              border: OutlineInputBorder(),
                              hintText: "Masukan Judul Promo",
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: dateMulai,
                                minLines: 1,
                                keyboardType: TextInputType.text,
                                maxLines: null,
                                readOnly: true,
                                validator: (value) {
                                  if (value == '') {
                                    return "Tgl Mulai Tidak Boleh Kosong";
                                  }
                                  return null;
                                },
                                onTap: () async {
                                  DateTime? pickerdate = await showDatePicker(
                                      context: context,
                                      initialDate: _date,
                                      firstDate: DateTime(_date!.year - 200),
                                      lastDate: DateTime(_date!.year + 100));
                                  if (pickerdate != null) {
                                    setState(() {
                                      _date = pickerdate;
                                      String dateStr = DateFormat("yyyy-MM-dd")
                                          .format(_date!)
                                          .toString();
                                      dateMulai!.text = dateStr;
                                    });
                                  }
                                },
                                decoration: const InputDecoration(
                                  labelText: "Tgl Mulai",
                                  border: OutlineInputBorder(),
                                  hintText: "Masukan Tgl Mulai",
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
                            const SizedBox(width: 30),
                            Expanded(
                              child: TextFormField(
                                controller: dateBerakhir,
                                minLines: 1,
                                keyboardType: TextInputType.text,
                                maxLines: null,
                                readOnly: true,
                                validator: (value) {
                                  if (value == '') {
                                    return "Tgl Berakhir Tidak Boleh Kosong";
                                  }
                                  return null;
                                },
                                onTap: () async {
                                  DateTime? pickerdate = await showDatePicker(
                                      context: context,
                                      initialDate: _date,
                                      firstDate: DateTime(_date!.year - 200),
                                      lastDate: DateTime(_date!.year + 100));
                                  if (pickerdate != null) {
                                    setState(() {
                                      _date = pickerdate;
                                      String dateStr = DateFormat("yyyy-MM-dd")
                                          .format(_date!)
                                          .toString();
                                      dateBerakhir!.text = dateStr;
                                    });
                                  }
                                },
                                decoration: const InputDecoration(
                                  labelText: "Tgl Berakhir",
                                  border: OutlineInputBorder(),
                                  hintText: "Masukan Tgl Berakhir",
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
                          ],
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 1,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.4,
                                height: 40,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.1)),
                                      backgroundColor: const Color(0xFF8b5bc2)),
                                  onPressed: () {
                                    context.pop();
                                  },
                                  child: const Text(
                                    "Batal",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.4,
                                height: 40,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.1)),
                                      backgroundColor: const Color(0xFF8b5bc2)),
                                  onPressed: () {
                                    if (formState.currentState!.validate()) {
                                      setState(() {
                                        _currentStep++;
                                      });
                                    }
                                  },
                                  child: const Text(
                                    "Next",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Step(
                title: const Text("Kelola Product"),
                state:
                    _currentStep <= 2 ? StepState.editing : StepState.complete,
                isActive: _currentStep >= 2,
                content: Container(
                  constraints: const BoxConstraints(
                      minHeight: 100,
                      minWidth: double.infinity,
                      maxHeight: 600),
                  child: ListView(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 1,
                        height: 450,
                        padding: const EdgeInsets.all(20.0),
                        child: productBlock,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.1)),
                                    backgroundColor: const Color(0xFF8b5bc2)),
                                onPressed: () {
                                  setState(() {
                                    _currentStep--;
                                  });
                                },
                                child: const Text(
                                  "Back",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.1)),
                                    backgroundColor: const Color(0xFF8b5bc2)),
                                onPressed: () {
                                  if (prod.isNotEmpty) {
                                    setState(() {
                                      _currentStep++;
                                    });
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          backgroundColor: Colors.red,
                                          content: Text(
                                            'Mohon Pilih Product Terlebih Dahulu',
                                            style:
                                                TextStyle(color: Colors.white),
                                          )),
                                    );
                                  }
                                },
                                child: const Text(
                                  "Next",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Step(
                title: const Text("Aturan Promo"),
                state: StepState.complete,
                isActive: _currentStep >= 3,
                content: Container(
                  constraints: const BoxConstraints(
                      minHeight: 100,
                      minWidth: double.infinity,
                      maxHeight: 600),
                  child: ListView(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 1,
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          children: [
                            DataTable(
                              border: TableBorder.all(
                                  width: 0, color: Colors.white),
                              showCheckboxColumn: false,
                              headingRowColor: WidgetStateColor.resolveWith(
                                  (states) => const Color(0xFFC2BEBE)),
                              columns: [
                                DataColumn(
                                  label: ConstrainedBox(
                                    constraints: const BoxConstraints(),
                                    child: Text(
                                      "Name",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.playfairDisplay(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0XFF000000)),
                                    ),
                                  ),
                                ),
                              ],
                              rows: [
                                for (var i = 0; i < prod.length; i++)
                                  DataRow(
                                    color:
                                        WidgetStateProperty.all(Colors.white),
                                    cells: [
                                      DataCell(ConstrainedBox(
                                        constraints: const BoxConstraints(),
                                        child: Text(
                                          prod[i].product!.namaBarang,
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.playfairDisplay(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400,
                                              color: const Color(0XFF000000)),
                                        ),
                                      )),
                                    ],
                                  ),
                              ],
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  border: TableBorder.all(
                                      width: 0, color: Colors.white),
                                  showCheckboxColumn: false,
                                  headingRowColor: WidgetStateColor.resolveWith(
                                      (states) => const Color(0xFFC2BEBE)),
                                  columns: [
                                    DataColumn(
                                      label: ConstrainedBox(
                                        constraints: const BoxConstraints(),
                                        child: Text(
                                          "Harga Product",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.playfairDisplay(
                                              fontSize: 22,
                                              fontWeight: FontWeight.w500,
                                              color: const Color(0XFF000000)),
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: ConstrainedBox(
                                        constraints: const BoxConstraints(),
                                        child: Text(
                                          "Harga Promo",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.playfairDisplay(
                                              fontSize: 22,
                                              fontWeight: FontWeight.w500,
                                              color: const Color(0XFF000000)),
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: ConstrainedBox(
                                        constraints: const BoxConstraints(),
                                        child: Text(
                                          "Diskon",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.playfairDisplay(
                                              fontSize: 22,
                                              fontWeight: FontWeight.w500,
                                              color: const Color(0XFF000000)),
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: ConstrainedBox(
                                        constraints: const BoxConstraints(),
                                        child: Text(
                                          "Min Belanja",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.playfairDisplay(
                                              fontSize: 22,
                                              fontWeight: FontWeight.w500,
                                              color: const Color(0XFF000000)),
                                        ),
                                      ),
                                    ),
                                  ],
                                  rows: prod.map((products) {
                                    // Create a TextEditingController for each item
                                    TextEditingController txtHargaPromo =
                                        TextEditingController.fromValue(
                                            TextEditingValue(
                                                text: products.hargaPromo!,
                                                selection:
                                                    TextSelection.collapsed(
                                                        offset: products
                                                            .hargaPromo!
                                                            .length)));
                                    TextEditingController txtDiskon =
                                        TextEditingController.fromValue(
                                            TextEditingValue(
                                                text: products.discount!,
                                                selection:
                                                    TextSelection.collapsed(
                                                        offset: products
                                                            .discount!
                                                            .length)));
                                    TextEditingController txtMin =
                                        TextEditingController.fromValue(
                                            TextEditingValue(
                                                text: products.minBelanja!,
                                                selection:
                                                    TextSelection.collapsed(
                                                        offset: products
                                                            .minBelanja!
                                                            .length)));
                                    return DataRow(
                                      color:
                                          WidgetStateProperty.all(Colors.white),
                                      cells: [
                                        DataCell(ConstrainedBox(
                                          constraints: const BoxConstraints(),
                                          child: Text(
                                            "Rp ${NumberFormats.convertToIdr(products.product!.harga)}",
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.play(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w400,
                                                color: const Color(0XFF000000)),
                                          ),
                                        )),
                                        DataCell(TextField(
                                          enableInteractiveSelection: true,
                                          controller: txtHargaPromo,
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                            TextInputFormatter.withFunction(
                                                (oldValue, newValue) {
                                              if (newValue.text.isEmpty) {
                                                return newValue.copyWith(
                                                    text: '');
                                              }
                                              final int? value = int.tryParse(
                                                  newValue.text
                                                      .replaceAll(',', ''));
                                              if (value == null) {
                                                return oldValue;
                                              }
                                              final newText = _numberFormat
                                                  .format(value)
                                                  .toString()
                                                  .replaceAll(',00', '');
                                              return newValue.copyWith(
                                                text: newText,
                                                selection:
                                                    TextSelection.collapsed(
                                                        offset: newText.length),
                                              );
                                            }),
                                          ],
                                          onChanged: (newValue) {
                                            setState(() {
                                              int hargaProduct = 0;
                                              int hargaPromo = 0;
                                              int laba = 0;
                                              if (newValue != "") {
                                                hargaProduct = int.parse(
                                                    products.product!.harga);
                                                hargaPromo = int.parse(newValue
                                                    .replaceAll('.', ''));
                                                if (txtMin.text != "") {
                                                  hargaProduct = hargaProduct *
                                                      int.parse(txtMin.text);
                                                  laba =
                                                      hargaProduct - hargaPromo;
                                                }
                                              } else {
                                                products.hargaPromo = "";
                                              }
                                              if (hargaPromo < hargaProduct) {
                                                double persen =
                                                    (laba / hargaProduct) * 100;
                                                products.discount =
                                                    "${persen.toInt()}";
                                                products.hargaPromo = newValue;
                                              }
                                            });
                                          },
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                          ),
                                        )),
                                        DataCell(TextField(
                                          controller: txtDiskon,
                                          keyboardType: TextInputType.number,
                                          onChanged: (newValue) {
                                            setState(() {
                                              int disc = 0;
                                              int hargaProduct = 0;
                                              if (newValue != "") {
                                                disc = int.parse(newValue);
                                                hargaProduct = int.parse(
                                                    products.product!.harga);
                                              }
                                              if (txtMin.text != "") {
                                                hargaProduct = hargaProduct *
                                                    int.parse(txtMin.text);
                                              }
                                              var diskon =
                                                  (disc * hargaProduct) / 100;
                                              var hasil = hargaProduct - diskon;
                                              if (disc < 100) {
                                                products.hargaPromo =
                                                    NumberFormats.convertToIdr(
                                                        "${hasil.toInt()}");
                                                products.discount = newValue;
                                              }
                                              if (disc == 0) {
                                                products.discount = "";
                                              }
                                            });
                                          },
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                          ),
                                        )),
                                        DataCell(TextField(
                                          controller: txtMin,
                                          keyboardType: TextInputType.number,
                                          onChanged: (newValue) {
                                            setState(() {
                                              products.minBelanja = newValue;
                                            });
                                          },
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                          ),
                                        )),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.1)),
                                    backgroundColor: const Color(0xFF8b5bc2)),
                                onPressed: () {
                                  setState(() {
                                    _currentStep--;
                                  });
                                },
                                child: const Text(
                                  "Back",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          BlocConsumer<PromoBloc, PromoState>(
                            listener: (context, state) {
                              if (state is RequestPromoSuccess) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      backgroundColor: Colors.green,
                                      content: Text(
                                        'Promo Berhasil di simpan',
                                        style: TextStyle(color: Colors.white),
                                      )),
                                );
                                context.go(PromoScreen.routeName);
                              }
                            },
                            builder: (context, state) {
                              if (state is PromoLoading) {
                                return Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.1)),
                                          backgroundColor:
                                              const Color(0xFF8b5bc2)),
                                      onPressed: () {},
                                      child: const Text(
                                        "Simpan",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                );
                              }
                              return Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.1)),
                                        backgroundColor:
                                            const Color(0xFF8b5bc2)),
                                    onPressed: () {
                                      if (prod.isNotEmpty) {
                                        for (var p in prod) {
                                          p.hargaPromo =
                                              p.hargaPromo!.replaceAll('.', '');
                                        }
                                      }
                                      var request = PromoModel(
                                          judul: txtJudul!.text,
                                          promoMulai: dateMulai!.text,
                                          promoBerakhir: dateBerakhir!.text,
                                          promoProdact: prod);
                                      context.read<PromoBloc>().add(
                                          CreatePromo(promoModel: request));
                                      context.read<PromoBloc>().add(GetPromo());
                                    },
                                    child: const Text(
                                      "Simpan",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

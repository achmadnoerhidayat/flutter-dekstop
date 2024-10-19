import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kasir_dekstop/bloc/category/category_bloc.dart';
import 'package:kasir_dekstop/models/category_model.dart';
import 'package:kasir_dekstop/widget/bottom_nav.dart';
import 'package:kasir_dekstop/widget/sidebar.dart';

class CategoryScreen extends StatefulWidget {
  static String routeName = '/ofice/category';
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  TextEditingController? txtNama;
  final formState = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    context.read<CategoryBloc>().add(GetCategory());
    txtNama = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> buttonNaf = [
      {
        'name': "Home",
        'route': "/home",
        'icon': const Icon(
          Icons.home,
          color: Colors.purple,
        ),
        'active': "false"
      },
      {
        'name': "Dashboard",
        'route': "/ofice/dashboard",
        'icon': const Icon(
          Icons.dashboard,
          color: Colors.purple,
        ),
        'active': "true"
      }
    ];
    final categori = BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state is CategoryLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is CategorySucces) {
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
                    "No",
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
                    "Nama",
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
                  constraints: const BoxConstraints(maxWidth: 80),
                  child: Text(
                    "Aksi",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.playfairDisplay(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: const Color(0XFF000000)),
                  ),
                ),
              ),
            ],
            rows: state.categori.map((val) {
              var no = state.categori.indexOf(val) + 1;
              return DataRow(
                color: WidgetStateProperty.all(Colors.white),
                cells: [
                  DataCell(
                    ConstrainedBox(
                      constraints: const BoxConstraints(),
                      child: Text(
                        "$no",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.play(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: const Color(0XFF000000)),
                      ),
                    ),
                  ),
                  DataCell(
                    ConstrainedBox(
                      constraints: const BoxConstraints(),
                      child: Text(
                        "${val.nama}",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.play(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: const Color(0XFF000000)),
                      ),
                    ),
                  ),
                  DataCell(
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 80),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            onTap: () {
                              txtNama!.text = "${val.nama}";
                              modalEdit(context, val);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(20)),
                              child: const Icon(
                                Icons.edit_outlined,
                                color: Colors.white,
                                size: 15,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text(
                                          "Apa anda yakin ingin menghapus ?"),
                                      content: const Text(
                                          "data yang dihapus tidak dapat dikembalikan"),
                                      actions: [
                                        BlocConsumer<CategoryBloc,
                                            CategoryState>(
                                          listener: (context, states) {
                                            if (states
                                                is CreateCategorySucces) {
                                              Navigator.of(context).pop();
                                            }
                                          },
                                          builder: (context, states) {
                                            if (states is CategoryLoading) {
                                              return ElevatedButton(
                                                onPressed: () {},
                                                style: ElevatedButton.styleFrom(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    fixedSize:
                                                        const Size(70, 40),
                                                    backgroundColor:
                                                        const Color(
                                                            0XFF2334A6)),
                                                child: Text(
                                                  "Ya",
                                                  style: GoogleFonts
                                                      .playfairDisplay(
                                                          color: const Color(
                                                              0XFFFFFFFF),
                                                          fontSize: 20),
                                                ),
                                              );
                                            }
                                            return ElevatedButton(
                                              onPressed: () {
                                                int id = int.parse("${val.id}");
                                                context
                                                    .read<CategoryBloc>()
                                                    .add(
                                                        DeleteCategory(id: id));
                                                context
                                                    .read<CategoryBloc>()
                                                    .add(GetCategory());
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  fixedSize: const Size(70, 40),
                                                  backgroundColor:
                                                      const Color(0XFF2334A6)),
                                              child: Text(
                                                "Ya",
                                                style:
                                                    GoogleFonts.playfairDisplay(
                                                        color: const Color(
                                                            0XFFFFFFFF),
                                                        fontSize: 20),
                                              ),
                                            );
                                          },
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              fixedSize: const Size(100, 40),
                                              backgroundColor:
                                                  const Color(0xFFC0C2D1)),
                                          child: Text(
                                            "Tidak",
                                            style: GoogleFonts.playfairDisplay(
                                                color: const Color(0xFF252323),
                                                fontSize: 20),
                                          ),
                                        )
                                      ],
                                    );
                                  });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(20)),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                                size: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          );
        }
        return DataTable(
          border: TableBorder.all(width: 0, color: Colors.white),
          showCheckboxColumn: false,
          headingRowColor:
              WidgetStateColor.resolveWith((states) => const Color(0xFFC2BEBE)),
          columns: [
            DataColumn(
              label: ConstrainedBox(
                constraints: const BoxConstraints(),
                child: Text(
                  "No",
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
                  "Nama",
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
                constraints: const BoxConstraints(maxWidth: 80),
                child: Text(
                  "Aksi",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.playfairDisplay(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: const Color(0XFF000000)),
                ),
              ),
            ),
          ],
          rows: const [],
        );
      },
    );
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(color: Color(0xFFF5F1F1)),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  const SideBar(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(30),
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Category",
                              style: GoogleFonts.playfairDisplay(
                                  fontSize: 30, fontWeight: FontWeight.w600),
                            ),
                            Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      fixedSize: const Size(200, 50),
                                      backgroundColor: const Color(0XFF2334A6)),
                                  child: Text(
                                    "Import / Export",
                                    style: GoogleFonts.playfairDisplay(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                ElevatedButton(
                                  onPressed: () {
                                    modalAdd(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      fixedSize: const Size(150, 50),
                                      backgroundColor: const Color(0XFF2334A6)),
                                  child: Text(
                                    "Add Item",
                                    style: GoogleFonts.playfairDisplay(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            padding: const EdgeInsets.all(20.0),
                            child: categori,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            BottomNav(
              buttonNav: buttonNaf,
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> modalAdd(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            height: MediaQuery.of(context).size.height * 0.5,
            child: Form(
              key: formState,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // header
                    Container(
                      height: 80,
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: const Color(0xFFFAF5F5))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              txtNama!.clear();
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                fixedSize: const Size(120, 40),
                                backgroundColor: const Color(0XFFFFFFFF)),
                            child: Text(
                              "Cancel",
                              style: GoogleFonts.playfairDisplay(
                                  color: const Color(0XFF2334A6), fontSize: 20),
                            ),
                          ),
                          BlocConsumer<CategoryBloc, CategoryState>(
                            listener: (context, state) {
                              if (state is CreateCategorySucces) {
                                txtNama!.clear();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      backgroundColor: Colors.blue,
                                      content:
                                          Text('Success Menambah Categori')),
                                );
                                Navigator.of(context).pop();
                              }
                            },
                            builder: (context, state) {
                              if (state is CategoryLoading) {
                                return ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      fixedSize: const Size(120, 40),
                                      backgroundColor: const Color(0XFF2334A6)),
                                  child: Text(
                                    "Save",
                                    style: GoogleFonts.playfairDisplay(
                                        color: const Color(0XFFFFFFFF),
                                        fontSize: 20),
                                  ),
                                );
                              }
                              return ElevatedButton(
                                onPressed: () {
                                  if (formState.currentState!.validate()) {
                                    var req =
                                        CategoryModel(nama: txtNama!.text);
                                    context
                                        .read<CategoryBloc>()
                                        .add(CreateCategory(nama: req));
                                    context
                                        .read<CategoryBloc>()
                                        .add(GetCategory());
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    fixedSize: const Size(120, 40),
                                    backgroundColor: const Color(0XFF2334A6)),
                                child: Text(
                                  "Save",
                                  style: GoogleFonts.playfairDisplay(
                                      color: const Color(0XFFFFFFFF),
                                      fontSize: 20),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      width: MediaQuery.of(context).size.width * 1,
                      padding: const EdgeInsets.all(20),
                      height: 120,
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Column(
                        children: [
                          TextFormField(
                            keyboardType: TextInputType.text,
                            controller: txtNama,
                            validator: (value) {
                              if (value == '') {
                                return "Nama Categori Tidak Boleh Kosong";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.only(
                                  left: 15, top: 5, bottom: 5),
                              hintText: "Masukan Kategori",
                              hintStyle: const TextStyle(
                                color: Color(0XFFAA9D9D),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<dynamic> modalEdit(BuildContext context, CategoryModel model) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            height: MediaQuery.of(context).size.height * 0.5,
            child: Form(
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
                              txtNama!.clear();
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                fixedSize: const Size(120, 40),
                                backgroundColor: const Color(0XFFFFFFFF)),
                            child: Text(
                              "Cancel",
                              style: GoogleFonts.playfairDisplay(
                                  color: const Color(0XFF2334A6), fontSize: 20),
                            ),
                          ),
                          BlocConsumer<CategoryBloc, CategoryState>(
                            listener: (context, state) {
                              if (state is CreateCategorySucces) {
                                txtNama!.clear();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      backgroundColor: Colors.blue,
                                      content: Text('Success Update Categori')),
                                );
                                Navigator.of(context).pop();
                              }
                            },
                            builder: (context, state) {
                              if (state is CategoryLoading) {
                                return ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      fixedSize: const Size(120, 40),
                                      backgroundColor: const Color(0XFF2334A6)),
                                  child: Text(
                                    "Save",
                                    style: GoogleFonts.playfairDisplay(
                                        color: const Color(0XFFFFFFFF),
                                        fontSize: 20),
                                  ),
                                );
                              }
                              return ElevatedButton(
                                onPressed: () {
                                  if (formState.currentState!.validate()) {
                                    var req = CategoryModel(
                                        id: model.id, nama: txtNama!.text);
                                    context
                                        .read<CategoryBloc>()
                                        .add(UpdateCategory(nama: req));
                                    context
                                        .read<CategoryBloc>()
                                        .add(GetCategory());
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    fixedSize: const Size(120, 40),
                                    backgroundColor: const Color(0XFF2334A6)),
                                child: Text(
                                  "Save",
                                  style: GoogleFonts.playfairDisplay(
                                      color: const Color(0XFFFFFFFF),
                                      fontSize: 20),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      width: MediaQuery.of(context).size.width * 1,
                      padding: const EdgeInsets.all(20),
                      height: 120,
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Column(
                        children: [
                          TextFormField(
                            keyboardType: TextInputType.text,
                            controller: txtNama,
                            validator: (value) {
                              if (value == '') {
                                return "Nama Categori Tidak Boleh Kosong";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.only(
                                  left: 15, top: 5, bottom: 5),
                              hintText: "Masukan Kategori",
                              hintStyle: const TextStyle(
                                color: Color(0XFFAA9D9D),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

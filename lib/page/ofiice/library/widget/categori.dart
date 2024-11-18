// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasir_dekstop/bloc/category/category_bloc.dart';
import 'package:kasir_dekstop/models/category_model.dart';

class Categori extends StatefulWidget {
  TextEditingController? txtCategory;
  Categori({super.key, this.txtCategory});

  @override
  State<Categori> createState() => _CategoriState();
}

class _CategoriState extends State<Categori> {
  @override
  void initState() {
    super.initState();
    if (widget.txtCategory!.text.isEmpty) {
      widget.txtCategory!.text = "0";
    }
  }

  @override
  Widget build(BuildContext context) {
    final categori = BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state is CategoryLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is CategorySucces) {
          List<CategoryModel> kategori = [];
          if (state.categori.isNotEmpty) {
            kategori.add(CategoryModel(
              id: 0,
              nama: "Pilih Kategori Barang",
            ));
            for (var varians in state.categori) {
              kategori.add(varians);
            }
          }
          return DropdownButtonFormField(
            isExpanded: true,
            hint: const Text("Pilih Kategori Barang"),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              contentPadding:
                  const EdgeInsets.only(left: 35, top: 8, bottom: 15),
              fillColor: Colors.white,
              hintStyle: const TextStyle(
                color: Color(0XFFAA9D9D),
              ),
            ),
            validator: (value) {
              if (value == '0') {
                return 'Kategori Barang Tidak Boleh Kosong';
              }
              return null;
            },
            items: kategori.map((val) {
              return DropdownMenuItem(
                value: "${val.id}",
                child: Text("${val.nama}"),
              );
            }).toList(),
            onChanged: (data) {
              String kategori = data!;
              setState(() {
                widget.txtCategory!.text = kategori;
              });
            },
            value: widget.txtCategory!.text,
          );
        }
        return Container(
          height: 40,
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            border: Border.all(
                color: Colors.grey, style: BorderStyle.solid, width: 0.80),
          ),
          child: DropdownButton(
            underline: const SizedBox(),
            hint: const Text("Pilih Kategori Surat"),
            dropdownColor: Colors.white,
            items: const [
              DropdownMenuItem(
                value: 1,
                child: Text("ini data sampling"),
              )
            ],
            onChanged: (value) {},
          ),
        );
      },
    );
    return categori;
  }
}

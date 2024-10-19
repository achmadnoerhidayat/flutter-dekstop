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
          return Container(
            width: MediaQuery.of(context).size.width * 0.76,
            height: 46,
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              border: Border.all(
                  color: Colors.grey, style: BorderStyle.solid, width: 0.80),
            ),
            child: DropdownButton(
              isExpanded: true,
              underline: const SizedBox(),
              hint: const Text("Pilih Kategori Barang"),
              dropdownColor: Colors.white,
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
            ),
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

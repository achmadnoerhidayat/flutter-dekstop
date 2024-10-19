import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kasir_dekstop/bloc/shift/shift_bloc.dart';
import 'package:kasir_dekstop/helper/number_format.dart';
import 'package:kasir_dekstop/models/shift_model.dart';
import 'package:kasir_dekstop/page/ofiice/shift/widget/modal_end_shift.dart';
import 'package:kasir_dekstop/page/ofiice/shift/widget/modal_kas.dart';
import 'package:kasir_dekstop/util/utils.dart';
import 'package:kasir_dekstop/widget/bottom_nav.dart';
import 'package:kasir_dekstop/widget/sidebar.dart';

class ShiftScreen extends StatefulWidget {
  static String routeName = '/ofice/shift';
  const ShiftScreen({super.key});

  @override
  State<ShiftScreen> createState() => _ShiftScreenState();
}

class _ShiftScreenState extends State<ShiftScreen> {
  final formState = GlobalKey<FormState>();
  TextEditingController? txtModal;
  TextEditingController? txtNotes;
  String today = DateTime.now().toIso8601String().substring(0, 10);
  String type = "Pengeluaran";
  @override
  void initState() {
    super.initState();
    txtModal = TextEditingController();
    txtNotes = TextEditingController();
    context.read<ShiftBloc>().add(ShowShiftEvent(date: today));
  }

  @override
  void dispose() {
    super.dispose();
    txtModal!.dispose();
    txtNotes!.dispose();
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

    final shift = BlocBuilder<ShiftBloc, ShiftState>(
      builder: (context, state) {
        if (state is ShowShiftSuccess) {
          Utils.shiftModel ??= state.shift;
          int jumlah = 0;
          if (state.shift.modal != null) {
            jumlah = int.parse(state.shift.modal!);
          }
          if (state.shift.totalSetor != null) {
            jumlah = jumlah + int.parse(state.shift.totalSetor!);
          }
          if (state.shift.totalKasbon != null) {
            jumlah = jumlah - int.parse(state.shift.totalKasbon!);
          }
          if (state.shift.totalGula! != "null") {
            jumlah = jumlah - int.parse(state.shift.totalGula!);
          }
          if (state.shift.totalTransaksi != null) {
            jumlah = jumlah + int.parse(state.shift.totalTransaksi!);
          }
          if (state.shift.totalPemasukan != "0") {
            jumlah = jumlah + int.parse(state.shift.totalPemasukan!);
          }
          if (state.shift.totalPengeluaran != "0") {
            jumlah = jumlah - int.parse(state.shift.totalPengeluaran!);
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          fixedSize:
                              Size(MediaQuery.of(context).size.width * .4, 50),
                          backgroundColor: const Color(0xFF9EA1B8)),
                      onPressed: () {
                        modalEndShift(context, state.shift);
                      },
                      child: const Text(
                        "Akhiri Shift",
                        style: TextStyle(color: Color(0XFF1a278a)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          fixedSize:
                              Size(MediaQuery.of(context).size.width * .4, 50),
                          backgroundColor: const Color(0xFF9EA1B8)),
                      onPressed: () {},
                      child: const Text(
                        "Cetak Laporan Shift",
                        style: TextStyle(color: Color(0XFF1a278a)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              const Text(
                "Detail Shift",
                style: TextStyle(
                  color: Color(0XFF1a278a),
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Nama",
                      style: TextStyle(
                        color: Color(0XFF1a278a),
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          Utils.userModel!.nama!,
                          style: const TextStyle(
                            color: Color(0XFF1a278a),
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Mulai Shift",
                      style: TextStyle(
                        color: Color(0XFF1a278a),
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      (state.shift.startShift != null)
                          ? NumberFormats.getFormatDay(
                              DateTime.parse(state.shift.startShift!))
                          : "",
                      style: const TextStyle(
                        color: Color(0XFF1a278a),
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Kas Keluar / Masuk",
                      style: TextStyle(
                        color: Color(0XFF1a278a),
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    Row(
                      children: [
                        Column(
                          children: [
                            (state.shift.totalPengeluaran != "0")
                                ? Text(
                                    "- Rp ${NumberFormats.convertToIdr(state.shift.totalPengeluaran!)}",
                                    style: const TextStyle(
                                      color: Color(0xFFE4110A),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                    ),
                                  )
                                : const SizedBox.shrink(),
                            (state.shift.totalPemasukan != "0")
                                ? Text(
                                    "+ Rp ${NumberFormats.convertToIdr(state.shift.totalPemasukan!)}",
                                    style: const TextStyle(
                                      color: Color(0XFF1a278a),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            modalKash(context, state.shift.id.toString());
                          },
                          child: const Icon(Icons.chevron_right_outlined),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Tunai",
                style: TextStyle(
                  color: Color(0XFF1a278a),
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Modal",
                      style: TextStyle(
                        color: Color(0XFF1a278a),
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          (state.shift.modal != null)
                              ? "Rp ${NumberFormats.convertToIdr(state.shift.modal!.replaceAll('.', ''))}"
                              : "",
                          style: const TextStyle(
                            color: Color(0XFF1a278a),
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 10),
                        InkWell(
                          onTap: () {
                            txtModal!.text =
                                NumberFormats.convertToIdr(state.shift.modal!);
                            modalEditModal(context, state.shift);
                          },
                          child: const Icon(
                            Icons.mode_edit_outline_sharp,
                            size: 15,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Pembayaran Tunai",
                      style: TextStyle(
                        color: Color(0XFF1a278a),
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      "Rp 0",
                      style: TextStyle(
                        color: Color(0XFF1a278a),
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Setor Kasbon / Hutang",
                      style: TextStyle(
                        color: Color(0XFF1a278a),
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      (state.shift.totalSetor != null)
                          ? "Rp ${NumberFormats.convertToIdr(state.shift.totalSetor!)}"
                          : "Rp 0",
                      style: const TextStyle(
                        color: Color(0XFF1a278a),
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Kasbon / Hutang",
                      style: TextStyle(
                        color: Color(0XFF1a278a),
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      (state.shift.totalKasbon != null)
                          ? "Rp ${NumberFormats.convertToIdr(state.shift.totalKasbon!)}"
                          : "Rp 0",
                      style: const TextStyle(
                        color: Color(0XFF1a278a),
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Beli Gula",
                      style: TextStyle(
                        color: Color(0XFF1a278a),
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      (state.shift.totalGula! != "null")
                          ? "Rp ${NumberFormats.convertToIdr(state.shift.totalGula!)}"
                          : "Rp 0",
                      style: const TextStyle(
                        color: Color(0XFF1a278a),
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Jumlah Uang Yang Diharapkan",
                      style: TextStyle(
                        color: Color(0XFF1a278a),
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      "Rp ${NumberFormats.convertToIdr(jumlah.toString())}",
                      style: const TextStyle(
                        color: Color(0XFF1a278a),
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Divider(),
              const Text(
                "Total",
                style: TextStyle(
                  color: Color(0XFF1a278a),
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Total Yang Diharapkan",
                      style: TextStyle(
                        color: Color(0XFF1a278a),
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      "Rp ${NumberFormats.convertToIdr(jumlah.toString())}",
                      style: const TextStyle(
                        color: Color(0XFF1a278a),
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }
        return Form(
          key: formState,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 1,
                height: 60,
                child: TextFormField(
                  controller: txtModal,
                  validator: (value) {
                    if (value == '') {
                      return "Modal Tidak Boleh Kosong";
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
                    txtModal!.value = TextEditingValue(
                      text: NumberFormats.convertToIdr(val),
                      selection: TextSelection.fromPosition(
                        TextPosition(
                            offset: NumberFormats.convertToIdr(val).length),
                      ),
                    );
                  },
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    fillColor: Colors.white,
                    contentPadding:
                        const EdgeInsets.only(left: 15, top: 5, bottom: 5),
                    hintText: "Masukan Nominal Modal",
                    hintStyle: const TextStyle(
                      color: Color(0XFFAA9D9D),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              BlocConsumer<ShiftBloc, ShiftState>(
                listener: (context, state) {
                  if (state is RequestShiftSuccess) {
                    txtModal!.clear();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          backgroundColor: Colors.blue,
                          content: Text('Berhasil Input Shift')),
                    );
                    Utils.shiftModel = ShiftModel(
                        id: state.id,
                        modal: txtModal!.text,
                        startShift: DateTime.now().toIso8601String(),
                        created: DateTime.now().toIso8601String());
                    context.read<ShiftBloc>().add(ShowShiftEvent(date: today));
                  }
                },
                builder: (context, state) {
                  if (state is ShiftLoading) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          fixedSize:
                              Size(MediaQuery.of(context).size.width * 1, 50),
                          backgroundColor: const Color(0XFF1a278a)),
                      onPressed: () {},
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize:
                            Size(MediaQuery.of(context).size.width * 1, 50),
                        backgroundColor: const Color(0XFF1a278a)),
                    onPressed: () {
                      if (formState.currentState!.validate()) {
                        String modal = txtModal!.text.replaceAll('.', '');
                        var request = ShiftModel(
                            modal: modal,
                            startShift: DateTime.now().toIso8601String(),
                            created: DateTime.now().toIso8601String());
                        context
                            .read<ShiftBloc>()
                            .add(CreateShiftEvent(shift: request));
                      }
                    },
                    child: const Text(
                      "Mulai Shift",
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                },
              ),
            ],
          ),
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
                        child: Text(
                          "Shift",
                          style: GoogleFonts.playfairDisplay(
                              fontSize: 30, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            padding: const EdgeInsets.all(20.0),
                            child: shift,
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

  Future<dynamic> modalEditModal(BuildContext context, ShiftModel shift) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            height: MediaQuery.of(context).size.height * 0.25,
            child: Column(
              children: [
                Container(
                  height: 70,
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: const Color(0xFFFAF5F5))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          txtModal!.clear();
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            fixedSize: const Size(100, 50),
                            backgroundColor: const Color(0XFFFFFFFF)),
                        child: Text(
                          "Cancel",
                          style: GoogleFonts.playfairDisplay(
                              color: const Color(0XFF2334A6), fontSize: 16),
                        ),
                      ),
                      BlocConsumer<ShiftBloc, ShiftState>(
                        listener: (context, state) {
                          if (state is RequestShiftSuccess) {
                            txtModal!.clear();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  backgroundColor: Colors.blue,
                                  content: Text('Success update shift')),
                            );
                            context
                                .read<ShiftBloc>()
                                .add(ShowShiftEvent(date: today));
                            Navigator.of(context).pop();
                          }
                        },
                        builder: (context, state) {
                          if (state is ShiftLoading) {
                            return ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  fixedSize: const Size(100, 50),
                                  backgroundColor: const Color(0XFF2334A6)),
                              child: Text(
                                "Save",
                                style: GoogleFonts.playfairDisplay(
                                    color: const Color(0XFFFFFFFF),
                                    fontSize: 16),
                              ),
                            );
                          }
                          return ElevatedButton(
                            onPressed: () {
                              String modal = txtModal!.text.replaceAll('.', '');
                              var request = ShiftModel(
                                id: shift.id,
                                modal: modal,
                                startShift: shift.startShift,
                                created: shift.created,
                              );
                              context
                                  .read<ShiftBloc>()
                                  .add(UpdateShiftEvent(shift: request));
                            },
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                fixedSize: const Size(100, 50),
                                backgroundColor: const Color(0XFF2334A6)),
                            child: Text(
                              "Save",
                              style: GoogleFonts.playfairDisplay(
                                  color: const Color(0XFFFFFFFF), fontSize: 16),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 1,
                  height: 60,
                  child: TextFormField(
                    controller: txtModal,
                    validator: (value) {
                      if (value == '') {
                        return "Modal Tidak Boleh Kosong";
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
                      txtModal!.value = TextEditingValue(
                        text: NumberFormats.convertToIdr(val),
                        selection: TextSelection.fromPosition(
                          TextPosition(
                              offset: NumberFormats.convertToIdr(val).length),
                        ),
                      );
                    },
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      fillColor: Colors.white,
                      contentPadding:
                          const EdgeInsets.only(left: 15, top: 5, bottom: 5),
                      hintText: "Masukan Nominal Modal",
                      hintStyle: const TextStyle(
                        color: Color(0XFFAA9D9D),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<dynamic> modalKash(BuildContext context, String shiftId) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            height: MediaQuery.of(context).size.height * 0.6,
            child: ModalKas(shiftId: shiftId),
          ),
        );
      },
    );
  }

  Future<dynamic> modalEndShift(BuildContext context, ShiftModel shift) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            height: MediaQuery.of(context).size.height * 0.6,
            child: ModalEndShift(shiftModel: shift),
          ),
        );
      },
    );
  }
}

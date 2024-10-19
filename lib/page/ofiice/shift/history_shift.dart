import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kasir_dekstop/bloc/shift/shift_bloc.dart';
import 'package:kasir_dekstop/helper/number_format.dart';
import 'package:kasir_dekstop/models/shift_model.dart';
import 'package:kasir_dekstop/util/utils.dart';
import 'package:kasir_dekstop/widget/bottom_nav.dart';
import 'package:kasir_dekstop/widget/sidebar.dart';

class HistoryShift extends StatefulWidget {
  static String routeName = '/ofice/history/shift';
  const HistoryShift({super.key});

  @override
  State<HistoryShift> createState() => _HistoryShiftState();
}

class _HistoryShiftState extends State<HistoryShift> {
  bool detail = false;
  int jumlah = 0;
  ShiftModel? shiftModel;
  @override
  void initState() {
    super.initState();
    context.read<ShiftBloc>().add(GetShiftEvent());
  }

  @override
  Widget build(BuildContext context) {
    final shift = BlocBuilder<ShiftBloc, ShiftState>(
      builder: (context, state) {
        if (state is ShiftSuccess) {
          return (!detail)
              ? ListView(
                  children: state.shift.map(
                    (e) {
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side:
                              const BorderSide(color: Colors.black, width: 1.0),
                        ),
                        child: ListTile(
                          title: Text(
                            "${NumberFormats.getFormatDay(DateTime.parse(e.startShift!))} - ${NumberFormats.getFormatDay(DateTime.parse(e.endShift!))}",
                            style: const TextStyle(
                                fontSize: 22, fontWeight: FontWeight.w500),
                          ),
                          trailing: InkWell(
                            onTap: () {
                              setState(() {
                                detail = true;
                                shiftModel = e;
                                if (e.modal != null) {
                                  jumlah = int.parse(e.modal!);
                                }
                                if (e.totalSetor != null) {
                                  jumlah = jumlah + int.parse(e.totalSetor!);
                                }
                                if (e.totalKasbon != null) {
                                  double kasbon = double.parse(e.totalKasbon!);
                                  jumlah = jumlah - kasbon.toInt();
                                }
                                if (e.totalGula! != "null") {
                                  jumlah = jumlah - int.parse(e.totalGula!);
                                }
                                if (e.totalTransaksi != null) {
                                  double trans =
                                      double.parse(e.totalTransaksi!);
                                  jumlah = jumlah + trans.toInt();
                                }
                                if (e.totalPemasukan != "0") {
                                  jumlah =
                                      jumlah + int.parse(e.totalPemasukan!);
                                }
                                if (e.totalPengeluaran != "0") {
                                  jumlah =
                                      jumlah - int.parse(e.totalPengeluaran!);
                                }
                              });
                              // modalKash(context);
                            },
                            child: const Icon(
                              Icons.chevron_right_outlined,
                              size: 40,
                            ),
                          ),
                        ),
                      );
                    },
                  ).toList(),
                )
              : ListView(
                  children: [
                    const Text(
                      "Detail Shift",
                      style: TextStyle(
                        color: Color(0XFF1a278a),
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5),
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5),
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
                            (shiftModel != null)
                                ? NumberFormats.getFormatDay(
                                    DateTime.parse(shiftModel!.startShift!))
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Shift Berakhir",
                            style: TextStyle(
                              color: Color(0XFF1a278a),
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            (shiftModel != null)
                                ? NumberFormats.getFormatDay(
                                    DateTime.parse(shiftModel!.endShift!))
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5),
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
                          Column(
                            children: [
                              (shiftModel!.totalPengeluaran != "0")
                                  ? Text(
                                      "- Rp ${NumberFormats.convertToIdr(shiftModel!.totalPengeluaran!)}",
                                      style: const TextStyle(
                                        color: Color(0xFFE4110A),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                              (shiftModel!.totalPemasukan != "0")
                                  ? Text(
                                      "+ Rp ${NumberFormats.convertToIdr(shiftModel!.totalPemasukan!)}",
                                      style: const TextStyle(
                                        color: Color(0XFF1a278a),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                      ),
                                    )
                                  : const SizedBox.shrink(),
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5),
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
                          Text(
                            (shiftModel!.modal != null)
                                ? "Rp ${NumberFormats.convertToIdr(shiftModel!.modal!.replaceAll('.', ''))}"
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5),
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5),
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
                            (shiftModel!.totalSetor != null)
                                ? "Rp ${NumberFormats.convertToIdr(shiftModel!.totalSetor!)}"
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5),
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
                            (shiftModel!.totalKasbon != null)
                                ? "Rp ${NumberFormats.convertToIdr(shiftModel!.totalKasbon!)}"
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5),
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
                            (shiftModel!.totalGula! != "null")
                                ? "Rp ${NumberFormats.convertToIdr(shiftModel!.totalGula!)}"
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5),
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5),
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
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Uang Yang Di Input",
                            style: TextStyle(
                              color: Color(0XFF1a278a),
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            "Rp ${NumberFormats.convertToIdr(shiftModel!.totalUang!)}",
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Selisih",
                            style: TextStyle(
                              color: Color(0XFF1a278a),
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            "Rp ${NumberFormats.convertToIdr(shiftModel!.selisih!)}",
                            style: TextStyle(
                              color: (int.parse(shiftModel!.selisih!) > 0)
                                  ? const Color(0XFF1a278a)
                                  : const Color(0xFFE71809),
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
        return Container();
      },
    );
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
                            (!detail)
                                ? Text(
                                    "History Shift",
                                    style: GoogleFonts.playfairDisplay(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w600),
                                  )
                                : Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            detail = false;
                                            shiftModel = null;
                                            jumlah = 0;
                                          });
                                        },
                                        child: const Icon(
                                          Icons.arrow_back,
                                          size: 34,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        "Detail Shift",
                                        style: GoogleFonts.playfairDisplay(
                                            fontSize: 30,
                                            fontWeight: FontWeight.w600),
                                      )
                                    ],
                                  ),
                          ],
                        ),
                      ),
                      // Container(
                      //   padding: const EdgeInsets.only(
                      //       left: 20.0, right: 20.0, top: 20.0, bottom: 10),
                      //   width: MediaQuery.of(context).size.width * 0.8,
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       SizedBox(
                      //         width: MediaQuery.of(context).size.width * 0.34,
                      //         child: TextField(
                      //           controller: orderId,
                      //           minLines: 1,
                      //           keyboardType: TextInputType.text,
                      //           maxLines: null,
                      //           decoration: const InputDecoration(
                      //             border: OutlineInputBorder(),
                      //             hintText: "Search Transaksi",
                      //             hintStyle: TextStyle(color: Colors.grey),
                      //             contentPadding: EdgeInsets.symmetric(
                      //                 vertical: 15, horizontal: 10),
                      //             isDense: true,
                      //           ),
                      //           style: const TextStyle(
                      //             fontSize: 14.0,
                      //             color: Colors.black,
                      //           ),
                      //         ),
                      //       ),
                      //       SizedBox(
                      //         width: MediaQuery.of(context).size.width * 0.20,
                      //         child: TextField(
                      //           controller: tanggal,
                      //           minLines: 1,
                      //           keyboardType: TextInputType.text,
                      //           maxLines: null,
                      //           readOnly: true,
                      //           onTap: () async {
                      //             DateTime? pickerdate = await showDatePicker(
                      //                 context: context,
                      //                 initialDate: _date,
                      //                 firstDate: DateTime(_date!.year - 200),
                      //                 lastDate: DateTime(_date!.year + 100));
                      //             if (pickerdate != null) {
                      //               setState(() {
                      //                 _date = pickerdate;
                      //                 String dateStr = DateFormat("yyyy-MM-dd")
                      //                     .format(_date!)
                      //                     .toString();
                      //                 tanggal?.text = dateStr;
                      //               });
                      //             }
                      //           },
                      //           decoration: const InputDecoration(
                      //             border: OutlineInputBorder(),
                      //             hintText: "tanggal",
                      //             hintStyle: TextStyle(color: Colors.grey),
                      //             contentPadding: EdgeInsets.symmetric(
                      //                 vertical: 15, horizontal: 10),
                      //             isDense: true,
                      //           ),
                      //           style: const TextStyle(
                      //             fontSize: 14.0,
                      //             color: Colors.black,
                      //           ),
                      //         ),
                      //       ),
                      //       SizedBox(
                      //         width: MediaQuery.of(context).size.width * 0.2,
                      //         child: ElevatedButton(
                      //           onPressed: () {
                      //             Map<String, dynamic> request = {
                      //               "no_order": (orderId?.text != null)
                      //                   ? orderId!.text
                      //                   : " ",
                      //               "tanggal": tanggal!.text,
                      //             };
                      //             context
                      //                 .read<TransaksiBloc>()
                      //                 .add(GetSearchTrans(params: request));
                      //           },
                      //           style: ElevatedButton.styleFrom(
                      //               shape: RoundedRectangleBorder(
                      //                 borderRadius: BorderRadius.circular(10),
                      //               ),
                      //               fixedSize: const Size(10, 50),
                      //               backgroundColor: const Color(0XFF2334A6)),
                      //           child: Text(
                      //             "Search",
                      //             style: GoogleFonts.playfairDisplay(
                      //                 color: const Color(0XFFFFFFFF),
                      //                 fontSize: 20),
                      //           ),
                      //         ),
                      //       )
                      //     ],
                      //   ),
                      // ),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.zero,
                          scrollDirection: Axis.vertical,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: 500,
                            padding: const EdgeInsets.only(
                                left: 20.0, right: 20.0, bottom: 20.0),
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
}

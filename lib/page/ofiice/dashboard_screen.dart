import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kasir_dekstop/bloc/transaksi/transaksi_bloc.dart';
import 'package:kasir_dekstop/models/transaksi_model.dart';
import 'package:kasir_dekstop/widget/bottom_nav.dart';
import 'package:kasir_dekstop/widget/sidebar.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DashboardScreen extends StatefulWidget {
  static String routeName = '/ofice/dashboard';
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TransaksiBloc>().add(GetTransHari());
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
    final transHari = BlocBuilder<TransaksiBloc, TransaksiState>(
      builder: (context, state) {
        if (state is TransaksiHariSuccess) {
          double jumlahBerat = 0;
          return Column(
            children: [
              SfCartesianChart(
                title: const ChartTitle(text: "Data Penjualan dalam 1 Jam"),
                primaryXAxis: const CategoryAxis(),
                series: <LineSeries<TransaksiJamModel, String>>[
                  LineSeries<TransaksiJamModel, String>(
                      dataLabelSettings:
                          const DataLabelSettings(isVisible: true),
                      // Bind data source
                      dataSource: state.jam.map((e) {
                        return TransaksiJamModel(jam: e.jam, sales: e.sales);
                      }).toList(),
                      xValueMapper: (TransaksiJamModel sales, _) => sales.jam,
                      yValueMapper: (TransaksiJamModel sales, _) =>
                          sales.sales),
                ],
              ),
              const SizedBox(height: 20),
              SfCartesianChart(
                title: const ChartTitle(text: "Data Penjualan dalam 7 hari"),
                primaryXAxis: const CategoryAxis(),
                series: <LineSeries<TransaksiHariModel, String>>[
                  LineSeries<TransaksiHariModel, String>(
                      dataLabelSettings:
                          const DataLabelSettings(isVisible: true),
                      // Bind data source
                      dataSource: state.transaksi.map((e) {
                        return TransaksiHariModel(hari: e.hari, sales: e.sales);
                      }).toList(),
                      xValueMapper: (TransaksiHariModel sales, _) => sales.hari,
                      yValueMapper: (TransaksiHariModel sales, _) =>
                          sales.sales),
                ],
              ),
              const SizedBox(height: 20),
              SfCartesianChart(
                title: const ChartTitle(
                    text: "Data Jumlah Pembelian Gula Dalam Seminggu"),
                primaryXAxis: const CategoryAxis(),
                series: <LineSeries<TransaksiWeightmModel, String>>[
                  LineSeries<TransaksiWeightmModel, String>(
                      dataLabelSettings:
                          const DataLabelSettings(isVisible: true),
                      // Bind data source
                      dataSource: state.gula.map((e) {
                        jumlahBerat += e.berat;
                        return TransaksiWeightmModel(
                            minggu: e.minggu, berat: e.berat);
                      }).toList(),
                      xValueMapper: (TransaksiWeightmModel sales, _) =>
                          sales.minggu,
                      yValueMapper: (TransaksiWeightmModel sales, _) =>
                          sales.berat),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                'Rata-rata Jumlah Gula Dalam Seminggu: ${(jumlahBerat / 4).toStringAsFixed(1)}',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              SfCircularChart(
                title: const ChartTitle(text: "Product Terlaris"),
                legend: const Legend(
                  isVisible: true,
                  overflowMode: LegendItemOverflowMode.wrap,
                ),
                series: <PieSeries<TransaksiProductTerlarisModel, String>>[
                  PieSeries<TransaksiProductTerlarisModel, String>(
                    dataSource: state.terlaris.map((t) {
                      return TransaksiProductTerlarisModel(
                          namaProduct: t.namaProduct, sales: t.sales);
                    }).toList(),
                    xValueMapper: (TransaksiProductTerlarisModel data, _) =>
                        data.namaProduct,
                    yValueMapper: (TransaksiProductTerlarisModel data, _) =>
                        data.sales,
                    dataLabelMapper: (TransaksiProductTerlarisModel data, _) =>
                        data.namaProduct,
                    startAngle: 100,
                    endAngle: 100,
                    dataLabelSettings: const DataLabelSettings(
                        isVisible: true,
                        labelPosition: ChartDataLabelPosition.outside),
                  )
                ],
              )
            ],
          );
        }
        return Container();
      },
    );
    return Scaffold(
      body: Container(
        width: double.infinity,
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  const SideBar(),
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(30),
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Text(
                          "Dashboard",
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
                            child: transHari,
                          ),
                        ),
                      ),
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

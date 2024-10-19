// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:kasir_dekstop/models/product_models.dart';
import 'package:kasir_dekstop/service/product_helper.dart';
import 'package:kasir_dekstop/models/transaksi_model.dart';
import 'package:kasir_dekstop/models/debt_sugar_model.dart';
import 'package:kasir_dekstop/models/debt_watch_model.dart';
import 'package:kasir_dekstop/models/transaksi_detail_model.dart';
import 'package:meta/meta.dart';

part 'transaksi_event.dart';
part 'transaksi_state.dart';

class TransaksiBloc extends Bloc<TransaksiEvent, TransaksiState> {
  bool isWholeNumber(double value) {
    return value == value.toInt().toDouble();
  }

  final ProductHelper productHelper = ProductHelper();
  TransaksiBloc() : super(TransaksiInitial()) {
    on<GetTrans>((event, emit) async {
      emit(TransaksiLoading());
      final response = await productHelper.getTransaksi();
      if (response.isNotEmpty) {
        emit(TransaksiSuccess(transaksi: response));
      } else {
        emit(TransaksiError(message: 'transaksi gagal'));
      }
    });
    on<GetTransHari>((event, emit) async {
      emit(TransaksiLoading());
      final response = await productHelper.getTransaksiHari();
      final terlaris = await productHelper.getTransaksiProductTerlaris();
      final jam = await productHelper.getTransaksiJam();
      final gula = await productHelper.getWeightSugar();
      if (response.isNotEmpty && terlaris.isNotEmpty) {
        emit(TransaksiHariSuccess(
            transaksi: response, terlaris: terlaris, jam: jam, gula: gula));
      } else {
        emit(TransaksiError(message: 'transaksi gagal'));
      }
    });
    on<GetSearchTrans>((event, emit) async {
      emit(TransaksiLoading());
      final response = await productHelper.getSearchTrans(event.params);
      if (response.isNotEmpty) {
        emit(TransaksiSuccess(transaksi: response));
      } else {
        emit(TransaksiError(message: 'transaksi gagal'));
      }
    });
    on<CreateTransaksi>((event, emit) async {
      emit(TransaksiLoading());
      final response = await productHelper.insertTransaksi(event.trans);
      int no = 0;
      if (event.trans.setorGula != null) {
        final debtSugar = await productHelper.getDebtSugar();

        var debt = debtSugar
            .firstWhere((val) => val.idCustomer == event.trans.idCustomer);
        if (debt.idCustomer != null) {
          var totalHutang =
              int.parse(debt.nominal!) - int.parse(event.trans.setorGula!);
          List<DebtSugarDetailModel> detail = [];
          detail.add(DebtSugarDetailModel(
            idHutang: debt.id.toString(),
            type: "Setor",
            nominal: event.trans.setorGula,
            note: event.trans.noteGula,
            created: event.trans.created,
          ));
          var reqSugar = DebtSugarModel(
            idCustomer: event.trans.idCustomer,
            nominal: totalHutang.toString(),
            created: event.trans.created,
            sugarDetail: detail,
          );
          await productHelper.tambahDebtSugarDetail(reqSugar);
        }
      }
      if (event.trans.setorKasbon != null) {
        final debtSugar = await productHelper.getDebtWatch();

        var debt = debtSugar
            .firstWhere((val) => val.idCustomer == event.trans.idCustomer);
        if (debt.idCustomer != null) {
          var totalHutang =
              int.parse(debt.nominal!) - int.parse(event.trans.setorKasbon!);
          List<DebtWatchDetailModel> detail = [];
          detail.add(DebtWatchDetailModel(
            idKasbon: debt.id.toString(),
            type: "Setor",
            nominal: event.trans.setorKasbon,
            note: event.trans.noteKasbon,
            created: event.trans.created,
          ));
          var reqSugar = DebtWatchModel(
            idCustomer: event.trans.idCustomer,
            nominal: totalHutang.toString(),
            created: event.trans.created,
            kasbonDetail: detail,
          );
          await productHelper.tambahDebtWatchDetail(reqSugar);
        }
      }

      if (event.trans.totalKasbon != null) {
        final debtSugar = await productHelper.getDebtWatch();

        var debt = debtSugar
            .firstWhere((val) => val.idCustomer == event.trans.idCustomer);
        if (debt.idCustomer != null) {
          var totalHutang =
              int.parse(debt.nominal!) + int.parse(event.trans.totalKasbon!);
          List<DebtWatchDetailModel> detail = [];
          detail.add(DebtWatchDetailModel(
            idKasbon: debt.id.toString(),
            type: "Hutang",
            nominal: event.trans.totalKasbon,
            note: "transaksi",
            created: event.trans.created,
          ));
          var reqSugar = DebtWatchModel(
            idCustomer: event.trans.idCustomer,
            nominal: totalHutang.toString(),
            created: event.trans.created,
            kasbonDetail: detail,
          );
          await productHelper.tambahDebtWatchDetail(reqSugar);
        }
      }
      for (var deta in event.trans.detail!) {
        deta.idTransaksi = "$response";
        await productHelper.insertTransaksiDetail(deta);
        no += 1;
      }
      final Map<int, double> groupedSums = {};
      for (var item in event.trans.detail!) {
        final idProduct = int.parse(item.idProduct!);
        double qty = 0;
        if (item.idVarian != null) {
          qty = double.parse(item.varian!.stokVarian) * double.parse(item.qty!);
        } else {
          qty = double.parse(item.qty!);
        }
        if (groupedSums.containsKey(idProduct)) {
          groupedSums[idProduct] = (groupedSums[idProduct] ?? 0) + qty;
        } else {
          groupedSums[idProduct] = qty;
        }
      }
      groupedSums.forEach((key, value) async {
        var dataProduct = event.trans.detail!.firstWhere(
          (element) => element.idProduct == key.toString(),
        );
        String stok = "";
        var total = double.parse(dataProduct.product!.stock) - value.toDouble();
        if (isWholeNumber(value)) {
          stok = total.toInt().toString();
        } else {
          stok = total.toString();
        }
        var request = ProductsModel(
            id: dataProduct.product!.id,
            namaBarang: dataProduct.product!.namaBarang,
            idCategory: dataProduct.product!.idCategory,
            idVarian: dataProduct.product!.idVarian,
            deskripsi: dataProduct.product!.deskripsi,
            harga: dataProduct.product!.harga,
            sku: dataProduct.product!.sku,
            hargaModal: dataProduct.product!.hargaModal,
            stock: stok,
            createdAt: dataProduct.product!.createdAt);

        await productHelper.updateProduct(request);
      });
      if (no == event.trans.detail!.length) {
        emit(RequestSuccess(id: response));
      } else {
        emit(TransaksiError(message: 'transaksi gagal'));
      }
    });
    on<ShowTransaksi>((event, emit) async {
      emit(TransaksiLoading());
      final response = await productHelper.showTransaksi(event.id);
      if (response != null) {
        emit(ShowTransaksiSuccess(transaksi: response));
      } else {
        emit(TransaksiError(message: 'transaksi gagal'));
      }
    });
    on<GetTransaksiDetailSales>((event, emit) async {
      emit(TransaksiDetailLoading());
      final response =
          await productHelper.getTransaksiDetaiilSales(event.params);
      if (response.isNotEmpty) {
        emit(TransaksiDetailSuccess(transaksiDetail: response));
      } else {
        emit(TransaksiError(message: "data tidak ditemukan"));
      }
    });
    on<GetTransaksiDetailCategory>((event, emit) async {
      emit(TransaksiDetailLoading());
      final response =
          await productHelper.getTransaksiDetaiilCategory(event.params);
      if (response.isNotEmpty) {
        emit(TransaksiDetailSuccess(transaksiDetail: response));
      } else {
        emit(TransaksiError(message: "data tidak ditemukan"));
      }
    });
    on<GetNoOrder>((event, emit) async {
      emit(TransaksiLoading());
      final response = await productHelper.generateOrderId();
      if (response.isNotEmpty) {
        emit(NoOrderSucces(noOrder: response));
      } else {
        emit(TransaksiError(message: "data tidak ditemukan"));
      }
    });
  }
}

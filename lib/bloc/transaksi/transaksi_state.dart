part of 'transaksi_bloc.dart';

@immutable
abstract class TransaksiState {}

class TransaksiInitial extends TransaksiState {}

class TransaksiLoading extends TransaksiState {}

class TransaksiSuccess extends TransaksiState {
  final List<TransaksiModel> transaksi;
  TransaksiSuccess({required this.transaksi});
}

class TransaksiHariSuccess extends TransaksiState {
  final List<TransaksiHariModel> transaksi;
  final List<TransaksiProductTerlarisModel> terlaris;
  final List<TransaksiJamModel> jam;
  final List<TransaksiWeightmModel> gula;
  TransaksiHariSuccess(
      {required this.transaksi,
      required this.terlaris,
      required this.jam,
      required this.gula});
}

class TransaksiError extends TransaksiState {
  final String message;
  TransaksiError({required this.message});
}

class RequestSuccess extends TransaksiState {
  final int id;
  RequestSuccess({required this.id});
}

class ShowTransaksiSuccess extends TransaksiState {
  final TransaksiModel transaksi;
  ShowTransaksiSuccess({required this.transaksi});
}

class TransaksiDetailSuccess extends TransaksiState {
  final List<TransaksiDetailModel> transaksiDetail;
  TransaksiDetailSuccess({required this.transaksiDetail});
}

class TransaksiDetailLoading extends TransaksiState {}

class NoOrderSucces extends TransaksiState {
  final String noOrder;
  NoOrderSucces({required this.noOrder});
}

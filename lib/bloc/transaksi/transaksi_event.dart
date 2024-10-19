part of 'transaksi_bloc.dart';

@immutable
abstract class TransaksiEvent {}

class GetTrans extends TransaksiEvent {}

class GetTransHari extends TransaksiEvent {}

class GetSearchTrans extends TransaksiEvent {
  final Map<String, dynamic> params;
  GetSearchTrans({required this.params});
}

class CreateTransaksi extends TransaksiEvent {
  final TransaksiModel trans;
  CreateTransaksi({required this.trans});
}

class ShowTransaksi extends TransaksiEvent {
  final int id;
  ShowTransaksi({required this.id});
}

class GetTransaksiDetailSales extends TransaksiEvent {
  final Map<String, dynamic> params;
  GetTransaksiDetailSales({required this.params});
}

class GetTransaksiDetailCategory extends TransaksiEvent {
  final Map<String, dynamic> params;
  GetTransaksiDetailCategory({required this.params});
}

class GetNoOrder extends TransaksiEvent {}

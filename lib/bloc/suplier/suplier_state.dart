part of 'suplier_bloc.dart';

@immutable
abstract class SuplierState {}

class SuplierInitial extends SuplierState {}

class SuplierLoading extends SuplierState {}

class SuplierSuccess extends SuplierState {
  final List<SuplierModel> suplier;
  SuplierSuccess({required this.suplier});
}

class SuplierError extends SuplierState {}

class RequestSuplier extends SuplierState {
  final int id;
  RequestSuplier({required this.id});
}

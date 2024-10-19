part of 'suplier_bloc.dart';

@immutable
abstract class SuplierEvent {}

class GetSuplier extends SuplierEvent {}

class GetSuplierName extends SuplierEvent {
  final String name;
  GetSuplierName({required this.name});
}

class CreateSuplier extends SuplierEvent {
  final SuplierModel suplier;
  CreateSuplier({required this.suplier});
}

class UpdateSuplier extends SuplierEvent {
  final SuplierModel suplier;
  UpdateSuplier({required this.suplier});
}

class DeleteSuplier extends SuplierEvent {
  final int id;
  DeleteSuplier({required this.id});
}

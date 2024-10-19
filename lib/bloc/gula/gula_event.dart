part of 'gula_bloc.dart';

@immutable
abstract class GulaEvent {}

class GetGula extends GulaEvent {}

class CreateGula extends GulaEvent {
  final GulaModel gulaModel;
  CreateGula({required this.gulaModel});
}

class UpdateGula extends GulaEvent {
  final GulaModel gulaModel;
  UpdateGula({required this.gulaModel});
}

class DeleteGula extends GulaEvent {
  final int idGula;
  DeleteGula({required this.idGula});
}

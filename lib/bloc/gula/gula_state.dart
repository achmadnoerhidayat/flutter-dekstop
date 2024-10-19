part of 'gula_bloc.dart';

@immutable
abstract class GulaState {}

class GulaInitial extends GulaState {}

class GulaLoading extends GulaState {}

class GulaError extends GulaState {}

class GulaSuccess extends GulaState {
  final List<GulaModel> gula;
  GulaSuccess({required this.gula});
}

class RequestGulaSuccess extends GulaState {
  final int id;
  RequestGulaSuccess({required this.id});
}

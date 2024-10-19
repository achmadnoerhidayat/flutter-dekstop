part of 'shift_bloc.dart';

@immutable
abstract class ShiftState {}

class ShiftInitial extends ShiftState {}

class ShiftLoading extends ShiftState {}

class ShiftSuccess extends ShiftState {
  final List<ShiftModel> shift;
  ShiftSuccess({required this.shift});
}

class ShowShiftSuccess extends ShiftState {
  final ShiftModel shift;
  ShowShiftSuccess({required this.shift});
}

class RequestShiftSuccess extends ShiftState {
  final int id;
  RequestShiftSuccess({required this.id});
}

class ShiftError extends ShiftState {}

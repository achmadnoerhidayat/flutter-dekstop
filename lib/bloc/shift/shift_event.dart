part of 'shift_bloc.dart';

@immutable
abstract class ShiftEvent {}

class GetShiftEvent extends ShiftEvent {}

class ShowShiftEvent extends ShiftEvent {
  final String date;
  ShowShiftEvent({required this.date});
}

class CreateShiftEvent extends ShiftEvent {
  final ShiftModel shift;
  CreateShiftEvent({required this.shift});
}

class UpdateShiftEvent extends ShiftEvent {
  final ShiftModel shift;
  UpdateShiftEvent({required this.shift});
}

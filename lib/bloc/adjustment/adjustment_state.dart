part of 'adjustment_bloc.dart';

@immutable
abstract class AdjustmentState {}

class AdjustmentInitial extends AdjustmentState {}

class AdjustmentLoading extends AdjustmentState {}

class AdjustmentSuccess extends AdjustmentState {
  final List<AdjustmentModel> adjustment;
  AdjustmentSuccess({required this.adjustment});
}

class ShowAdjustmentSuccess extends AdjustmentState {
  final List<AdjustmentModelDetail> adjustment;
  final int totalAdj;
  final int totalItem;
  final int totalExpen;
  final int totalIncome;
  ShowAdjustmentSuccess(
      {required this.adjustment,
      required this.totalAdj,
      required this.totalItem,
      required this.totalExpen,
      required this.totalIncome});
}

class AdjustmentError extends AdjustmentState {}

class Requestadjustment extends AdjustmentState {}

class ModalShow extends AdjustmentState {
  final BuildContext context;
  ModalShow({required this.context});
}

class ListUdjestment extends AdjustmentState {
  final List<AdjustmentModel> adjustment;
  ListUdjestment({required this.adjustment});
}

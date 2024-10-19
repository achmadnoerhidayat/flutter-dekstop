part of 'adjustment_bloc.dart';

@immutable
abstract class AdjustmentEvent {}

class GetAdjustment extends AdjustmentEvent {}

class ShowAdjustmentDetail extends AdjustmentEvent {
  final String date;
  ShowAdjustmentDetail({required this.date});
}

class Modal extends AdjustmentEvent {
  final BuildContext context;
  Modal({required this.context});
}

class CreatModalAdjustment extends AdjustmentEvent {
  final List<AdjustmentModel> adjustment;
  CreatModalAdjustment({required this.adjustment});
}

class CreateAdjustment extends AdjustmentEvent {
  final AdjustmentModel adjustment;
  CreateAdjustment({required this.adjustment});
}

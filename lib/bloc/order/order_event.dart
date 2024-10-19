part of 'order_bloc.dart';

@immutable
abstract class OrderEvent {}

class GetOrder extends OrderEvent {
  final String date;
  GetOrder({required this.date});
}

class GetOrderSuplier extends OrderEvent {
  final String suplier;
  GetOrderSuplier({required this.suplier});
}

class CreateOrder extends OrderEvent {
  final OrderModel order;
  CreateOrder({required this.order});
}

class UpdateOrder extends OrderEvent {
  final OrderModel order;
  UpdateOrder({required this.order});
}

class DeleteOrder extends OrderEvent {
  final int id;
  DeleteOrder({required this.id});
}

class Modal extends OrderEvent {
  final BuildContext context;
  Modal({required this.context});
}

class GetOrderDetail extends OrderEvent {
  final String date;
  GetOrderDetail({required this.date});
}

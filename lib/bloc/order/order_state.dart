part of 'order_bloc.dart';

@immutable
abstract class OrderState {}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class OrderSuccess extends OrderState {
  final List<OrderModel> order;
  OrderSuccess({required this.order});
}

class OrderError extends OrderState {}

class RequestOrderSuccess extends OrderState {
  final int id;
  RequestOrderSuccess({required this.id});
}

class OrderDetailSucces extends OrderState {
  final List<OrderDetailModel> orderDetail;
  OrderDetailSucces({required this.orderDetail});
}

class ModalShow extends OrderState {
  final BuildContext context;
  ModalShow({required this.context});
}

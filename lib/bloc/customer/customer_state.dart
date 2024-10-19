part of 'customer_bloc.dart';

@immutable
abstract class CustomerState {}

class CustomerInitial extends CustomerState {}

class CustomerLoading extends CustomerState {}

class CustomerError extends CustomerState {}

class CustomerSuccess extends CustomerState {
  final List<CustomerModel> custModel;
  CustomerSuccess({required this.custModel});
}

class RequestCustomerSuccess extends CustomerState {
  final int id;
  RequestCustomerSuccess({required this.id});
}

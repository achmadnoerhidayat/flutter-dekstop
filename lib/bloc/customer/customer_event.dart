part of 'customer_bloc.dart';

@immutable
abstract class CustomerEvent {}

class GetCustomer extends CustomerEvent {}

class GetSearchCustomer extends CustomerEvent {
  final String nama;
  GetSearchCustomer({required this.nama});
}

class CreateCustomer extends CustomerEvent {
  final CustomerModel customerModel;
  CreateCustomer({required this.customerModel});
}

class UpdateCustomer extends CustomerEvent {
  final CustomerModel customerModel;
  UpdateCustomer({required this.customerModel});
}

class DeleteCustomer extends CustomerEvent {
  final int id;
  DeleteCustomer({required this.id});
}

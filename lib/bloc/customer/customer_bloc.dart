// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:kasir_dekstop/models/customer_model.dart';
import 'package:kasir_dekstop/service/product_helper.dart';
import 'package:meta/meta.dart';

part 'customer_event.dart';
part 'customer_state.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  final ProductHelper productHelper = ProductHelper();
  CustomerBloc() : super(CustomerInitial()) {
    on<GetCustomer>((event, emit) async {
      emit(CustomerLoading());
      final response = await productHelper.getCustomer(null);
      emit(CustomerSuccess(custModel: response));
    });
    on<GetSearchCustomer>((event, emit) async {
      emit(CustomerLoading());
      final response = await productHelper.getCustomer(event.nama);
      emit(CustomerSuccess(custModel: response));
    });
    on<CreateCustomer>((event, emit) async {
      emit(CustomerLoading());
      final response = await productHelper.insertCustomer(event.customerModel);
      emit(RequestCustomerSuccess(id: response));
    });
    on<UpdateCustomer>((event, emit) async {
      emit(CustomerLoading());
      final response = await productHelper.updateCustomer(event.customerModel);
      emit(RequestCustomerSuccess(id: response));
    });
    on<DeleteCustomer>((event, emit) async {
      emit(CustomerLoading());
      final response = await productHelper.deleteCustomer(event.id);
      emit(RequestCustomerSuccess(id: response));
    });
  }
}

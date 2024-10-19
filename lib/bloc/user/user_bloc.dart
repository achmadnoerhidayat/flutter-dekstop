// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:kasir_dekstop/models/user_model.dart';
import 'package:kasir_dekstop/service/product_helper.dart';
import 'package:meta/meta.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  ProductHelper productHelper = ProductHelper();
  UserBloc() : super(UserInitial()) {
    on<RegisterEvent>((event, emit) async {
      emit(UserLoading());
      final response = await productHelper.register(event.user);
      emit(RegisterUser(id: response));
    });
    on<LoginEvent>((event, emit) async {
      emit(UserLoading());
      final response = await productHelper.login(event.user);
      if (response != null) {
        emit(LoginUser(user: response));
      } else {
        emit(UserError());
      }
    });
  }
}

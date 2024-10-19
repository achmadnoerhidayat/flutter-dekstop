part of 'user_bloc.dart';

@immutable
abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserSuccess extends UserState {}

class UserError extends UserState {}

class LoginUser extends UserState {
  final UserModel user;
  LoginUser({required this.user});
}

class RegisterUser extends UserState {
  final int id;
  RegisterUser({required this.id});
}

part of 'user_bloc.dart';

@immutable
abstract class UserEvent {}

class LoginEvent extends UserEvent {
  final UserModel user;
  LoginEvent({required this.user});
}

class RegisterEvent extends UserEvent {
  final UserModel user;
  RegisterEvent({required this.user});
}

part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthLogin extends AuthEvent {
  final String email;
  final String password;

  const AuthLogin({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}
class AuthRegister extends AuthEvent {
  final String email;
  final String password;

  const AuthRegister({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}
class AuthLogout extends AuthEvent {}

class AuthRestoreToken extends AuthEvent {
  final String token;

  const AuthRestoreToken({required this.token});

  @override
  List<Object> get props => [token];
}

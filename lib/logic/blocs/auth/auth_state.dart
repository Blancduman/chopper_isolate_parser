part of 'auth_bloc.dart';

class AuthState extends Equatable {
  final String token;
  const AuthState(this.token);
  
  @override
  List<Object> get props => [token];
}

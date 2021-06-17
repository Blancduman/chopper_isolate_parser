import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chopper/chopper.dart';
import 'package:chopper_test/data/api/product_api.dart';
import 'package:chopper_test/data/model/auth.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:worker_manager/worker_manager.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> with HydratedMixin {
  late AuthApiService authApiService;
  AuthBloc()
      : super(AuthState('')) {
    initService();
    hydrate();
  }

  Future<void> initService() async {
    this.authApiService = (await ApiService.create()).getService<AuthApiService>();
  }

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is AuthLogin) {
      yield* _mapLoginToState(event);
    } else if (event is AuthLogout) {
      yield* _mapLogoutToState(event);
    } else if (event is AuthRegister) {
      yield* _mapRegisterToState(event);
    } else if (event is AuthRestoreToken) {
      yield AuthState(event.token);
    }
  }

  Stream<AuthState> _mapLoginToState(AuthLogin event) async* {
    try {
      final Response<Auth> response = await authApiService.login(event.email, event.password);
      if (response.isSuccessful) {
        final Auth? auth = response.body;
        yield AuthState('${auth!.token}');
      } else {
        yield AuthState('');
      }
    } catch (e) {
      yield AuthState('');
    }
  }

  Stream<AuthState> _mapRegisterToState(AuthRegister event) async* {
    try {
      final Response<Auth> response =
          await authApiService.register(event.email, event.password);
      if (response.isSuccessful) {
        final Auth? auth = response.body;
        yield AuthState('${auth!.token}');
      } else {
        yield AuthState('');
      }
    } catch (e) {
      yield AuthState('');
    }
  }

  Stream<AuthState> _mapLogoutToState(AuthLogout event) async* {
    yield AuthState('');
  }

  @override
  AuthState? fromJson(Map<String, dynamic> json) {
    if (json['token'] != null)
      add(AuthRestoreToken(token: json['token'] as String));
    return AuthState(json['token'] as String);
  }

  @override
  Map<String, dynamic>? toJson(AuthState state) {
    return <String, dynamic>{
      'token': state.token,
    };
  }
}

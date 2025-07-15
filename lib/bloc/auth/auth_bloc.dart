import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:manajemen_keuangan/constants/auth_constants.dart';
import 'package:manajemen_keuangan/datasource/auth_datasource.dart';
import 'package:manajemen_keuangan/models/response_model_auth.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthDatasource datasource = AuthDatasource();
  AuthBloc() : super(AuthInitial()) {
    on<AuthLoginEvent>(_authLoginEvent);
    on<AuthRegisterEvent>(_authRegisterEvent);
  }

  _authLoginEvent(AuthLoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoginLoading());
    // Handle login logic here
    // For example, call an API to authenticate the user
    // and then emit a success or failure state
    ResponseModelAuth? data = await datasource.login(
      email: event.email,
      password: event.password,
    );

    debugPrint('Login response: ${data?.toJson()}');

    if (data != null && data.accessToken != null && data.user != null) {
      User user = data.user!;

      AuthConstants.saveToken(data.accessToken!);
      AuthConstants.saveUserData(
        userId: user.id!,
        userName: user.name!,
        userEmail: user.email!,
      );
      emit(AuthLoginSuccessListener());
    } else {
      emit(
        AuthLoginFailedListener(
          message: 'Login gagal, silakan periksa email dan password Anda.',
        ),
      );
    }
  }

  _authRegisterEvent(AuthRegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthRegisterLoading());
    // Handle registration logic here
    // For example, call an API to register the user
    // and then emit a success or failure state
    ResponseModelAuth? data = await datasource.register(
      name: event.name,
      email: event.email,
      password: event.password,
    );

    debugPrint('Register response: ${data?.toJson()}');

    if (data != null && data.accessToken != null) {
      emit(AuthRegisterSuccessListener());
    } else {
      emit(
        AuthRegisterFailedListener(
          message: 'Registrasi gagal, silakan periksa data Anda.',
        ),
      );
    }
  }
}

part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

// login loading
final class AuthLoginLoading extends AuthState {}

// login berhasil listener saja
final class AuthLoginSuccessListener extends AuthState {}

// login gagal listener saja
final class AuthLoginFailedListener extends AuthState {
  final String message;
  AuthLoginFailedListener({required this.message});
}

// register loading
final class AuthRegisterLoading extends AuthState {}

// register berhasil listener saja
final class AuthRegisterSuccessListener extends AuthState {}

// register gagal listener saja
final class AuthRegisterFailedListener extends AuthState {
  final String message;
  AuthRegisterFailedListener({required this.message});
}

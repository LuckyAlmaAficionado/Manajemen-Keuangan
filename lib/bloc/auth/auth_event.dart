part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class AuthRegisterEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;

  AuthRegisterEvent({
    required this.name,
    required this.email,
    required this.password,
  });
}

final class AuthLoginEvent extends AuthEvent {
  final String email;
  final String password;

  AuthLoginEvent({required this.email, required this.password});
}

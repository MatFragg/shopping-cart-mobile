import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class RegisterButtonPressed extends AuthEvent {
  final String username;
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String phone;
  final String shippingAddress;

  const RegisterButtonPressed({
    required this.username,
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.shippingAddress,
  });

  @override
  List<Object?> get props => [
    username,
    email,
    password,
    firstName,
    lastName,
    phone,
    shippingAddress,
  ];
}

class LoginButtonPressed extends AuthEvent {
  final String username;
  final String password;

  const LoginButtonPressed({
    required this.username,
    required this.password,
  });

  @override
  List<Object?> get props => [username, password];
}

class CheckAuthStatus extends AuthEvent {
  final String? token;

  const CheckAuthStatus({this.token});

  @override
  List<Object?> get props => [token];
}

class LogoutRequested extends AuthEvent {}

class UpdateProfileRequested extends AuthEvent {
  final String firstName;
  final String lastName;
  final String phone;
  final String shippingAddress;

  const UpdateProfileRequested({
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.shippingAddress,
  });

  @override
  List<Object?> get props => [firstName, lastName, phone, shippingAddress];
}
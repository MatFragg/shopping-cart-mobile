import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String username;
  final String email;
  final String? customerId;
  final String firstName;
  final String lastName;
  final String phone;
  final String shippingAddress;
  final List<String> roles;
  final DateTime? createdAt;

  const User({
    required this.id,
    required this.username,
    required this.email,
    this.customerId,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.shippingAddress,
    this.roles = const [],
    this.createdAt,
  });

  String get fullName => '$firstName $lastName';
  bool get hasCustomerProfile => customerId != null;

  @override
  List<Object?> get props => [
    id,
    username,
    email,
    customerId,
    firstName,
    lastName,
    phone,
    shippingAddress,
    roles,
    createdAt,
  ];
}

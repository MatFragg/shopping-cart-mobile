import 'package:shopping_cart/features/authentication/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.username,
    required super.email,
    super.customerId,
    required super.firstName,
    required super.lastName,
    required super.phone,
    required super.shippingAddress,
    super.roles = const [],
    super.createdAt,
  });
  factory UserModel.fromJson(Map<String, dynamic> json) {
    final customer = json['customer'] as Map<String, dynamic>?;

    List<String> parsedRoles = [];
    final rolesRaw = json['roles'];
    if (rolesRaw is List) {
      parsedRoles = rolesRaw.map((e) => e.toString()).toList();
    } else if (rolesRaw is String) {
      parsedRoles = rolesRaw.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
    }

    DateTime? parsedCreatedAt;
    final createdRaw = json['created_at'] ?? json['createdAt'];
    if (createdRaw is String) {
      parsedCreatedAt = DateTime.tryParse(createdRaw);
    }
    return UserModel(
      id: json['id']?.toString() ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      customerId: customer?['customerId']?.toString(),
      firstName: customer?['firstName'] ?? '',
      lastName: customer?['lastName'] ?? '',
      phone: customer?['phone'] ?? '',
      shippingAddress: customer?['shippingAddress'] ?? '',
      roles: parsedRoles,
      createdAt: parsedCreatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'customer': customerId != null ? {
        'customerId': customerId,
        'firstName': firstName,
        'lastName': lastName,
        'phone': phone,
        'shippingAddress': shippingAddress,
      } : null,
    };
  }

  factory UserModel.fromDrift(Map<String, dynamic> driftData) {
    final rolesString = driftData['roles'] as String?;
    final rolesList = rolesString != null
        ? rolesString.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList()
        : <String>[];

    DateTime? parsedCreatedAt;
    final createdRaw = driftData['created_at'] ?? driftData['createdAt'];
    if (createdRaw is String) {
      parsedCreatedAt = DateTime.tryParse(createdRaw);
    } else if (createdRaw is DateTime) {
      parsedCreatedAt = createdRaw;
    }

    return UserModel(
      id: driftData['id']?.toString() ?? '',
      username: driftData['username'] ?? '',
      email: driftData['email'] ?? '',
      customerId: driftData['customer_id']?.toString(),
      firstName: driftData['first_name'] ?? '',
      lastName: driftData['last_name'] ?? '',
      phone: driftData['phone'] ?? '',
      shippingAddress: driftData['shipping_address'] ?? '',
      roles: rolesList,
      createdAt: parsedCreatedAt,
    );
  }

  Map<String, dynamic> toDrift() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'roles': roles.join(','),
      'customer_id': customerId,
      'first_name': firstName,
      'last_name': lastName,
      'phone': phone,
      'shipping_address': shippingAddress,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? id,
    String? username,
    String? email,
    String? customerId,
    String? firstName,
    String? lastName,
    String? phone,
    String? shippingAddress,
    List<String>? roles,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      customerId: customerId ?? this.customerId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      roles: roles ?? this.roles,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
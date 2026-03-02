// features/authentication/data/datasources/auth_local_data_source.dart
import 'package:drift/drift.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/database/app_database.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<UserModel> getCachedUser();
  Future<void> cacheUser(UserModel user);
  Future<void> clearCache();
  Future<String?> getToken();
  Future<void> cacheToken(String token);
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final AppDatabase database;

  AuthLocalDataSourceImpl({required this.database});

  @override
  Future<UserModel> getCachedUser() async {
    final user = await database.select(database.users).getSingleOrNull();

    if (user == null) {
      throw CacheException();
    }

    return UserModel.fromDrift({
      'id': user.id,
      'username': user.username,
      'email': user.email,
      'roles': user.roles,
      'customer_id': user.customerId,
      'first_name': user.firstName,
      'last_name': user.lastName,
      'phone': user.phone,
      'shipping_address': user.shippingAddress,
      'created_at': user.createdAt?.toIso8601String(),
    });
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    await database.into(database.users).insert(
      UsersCompanion.insert(
        id: user.id,
        username: user.username,
        email: user.email,
        roles: user.roles.join(','),
        customerId: Value(user.customerId),
        firstName: user.firstName,
        lastName: user.lastName,
        phone: user.phone,
        shippingAddress: user.shippingAddress,
        createdAt: Value(user.createdAt),
      ),
      mode: InsertMode.replace,
    );
  }

  @override
  Future<void> clearCache() async {
    await database.delete(database.users).go();
  }

  @override
  Future<String?> getToken() async {
    // Implementar usando shared_preferences o secure_storage
    // Por simplicidad, aquí está el esqueleto
    throw UnimplementedError();
  }

  @override
  Future<void> cacheToken(String token) async {
    // Implementar usando shared_preferences o secure_storage
    throw UnimplementedError();
  }
}
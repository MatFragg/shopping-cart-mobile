import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/error/exceptions.dart';

abstract class TokenDataSource {
  Future<String?> getToken();
  Future<void> saveToken(String token);
  Future<void> deleteToken();
}

class TokenDataSourceImpl implements TokenDataSource {
  final FlutterSecureStorage secureStorage;

  TokenDataSourceImpl({required this.secureStorage});

  static const String _tokenKey = 'auth_token';

  @override
  Future<String?> getToken() async {
    try {
      return await secureStorage.read(key: _tokenKey);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> saveToken(String token) async {
    try {
      await secureStorage.write(key: _tokenKey, value: token);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> deleteToken() async {
    try {
      await secureStorage.delete(key: _tokenKey);
    } catch (e) {
      throw CacheException();
    }
  }
}
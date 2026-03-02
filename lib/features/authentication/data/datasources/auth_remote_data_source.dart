import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResult> register({
    required String username,
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phone,
    required String shippingAddress,
  });

  Future<AuthResult> login({
    required String username,
    required String password,
  });

  Future<UserModel> getCurrentUser(String token);
}

class AuthResult {
  final UserModel user;
  final String token;

  AuthResult({required this.user, required this.token});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl({required this.dio});

  @override
  Future<AuthResult> register({
    required String username,
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phone,
    required String shippingAddress,
  }) async {
    final response = await dio.post(
      '/api/v1/auth/register',
      data: {
        'username': username,
        'email': email,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
        'phone': phone,
        'shippingAddress': shippingAddress,
      },
      options: Options(headers: {'Content-Type': 'application/json'}),
    );

    final status = response.statusCode ?? 0;
    if (status == 201 || status == 200) {
      final data = _extractData(response.data);
      final String token = data['token'] as String;
      final UserModel user = UserModel.fromJson(data);
      return AuthResult(user: user, token: token);
    } else if (status == 400) {
      final error = _extractData(response.data);
      throw BadRequestException(error['message'] ?? 'Registration failed');
    } else {
      throw ServerException();
    }
  }

  @override
  Future<AuthResult> login({
    required String username,
    required String password,
  }) async {
    final response = await dio.post(
      '/api/v1/auth/login',
      data: {'username': username, 'password': password},
      options: Options(headers: {'Content-Type': 'application/json'}),
    );

    final status = response.statusCode ?? 0;
    if (status == 200) {
      final data = _extractData(response.data);
      final String token = data['token'] as String;
      final UserModel user = UserModel.fromJson(data);
      return AuthResult(user: user, token: token);
    } else if (status == 401) {
      throw UnauthorizedException();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<UserModel> getCurrentUser(String token) async {
    final response = await dio.get(
      '/api/v1/auth/me',
      options: Options(headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'}),
    );

    final status = response.statusCode ?? 0;
    if (status == 200) {
      final data = _extractData(response.data);
      return UserModel.fromJson(data);
    } else if (status == 401) {
      throw UnauthorizedException();
    } else {
      throw ServerException();
    }
  }

  // Normaliza response.data que puede venir como Map, String o estar anidado en { "data": ... }
  Map<String, dynamic> _extractData(dynamic responseData) {
    if (responseData is Map<String, dynamic>) {
      final payload = responseData['data'] ?? responseData;
      if (payload is Map<String, dynamic>) return payload;
      return Map<String, dynamic>.from(payload);
    } else if (responseData is String) {
      final decoded = json.decode(responseData) as Map<String, dynamic>;
      return decoded['data'] ?? decoded;
    } else {
      return {};
    }
  }
}
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import '../../../../core/error/exceptions.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/cart_model.dart';

abstract class CartRemoteDataSource {
  Future<CartModel> getActiveCart(String token);
  Future<CartModel> addItem(String token, String productId, int quantity);
  Future<CartModel> updateItemQuantity(String token, String productId, int quantity);
  Future<void> removeItem(String token, String productId);
  Future<void> clearCart(String token);
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final Dio dio;

  CartRemoteDataSourceImpl({required this.dio});

  @override
  Future<CartModel> getActiveCart(String token) async {
    final response = await dio.get('${ApiConstants.baseUrl}/api/v1/cart',
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      }),);

    if (response.statusCode == 200) {
      final responseData = response.data as Map<String, dynamic>;
      final data = responseData['data'] as Map<String, dynamic>;
      return CartModel.fromJson(data);
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<CartModel> addItem(String token, String productId, int quantity) async {
    final response = await dio.post(
      '${ApiConstants.baseUrl}/api/v1/cart/items',
      data: {
        'productId': productId,
        'quantity': quantity,
      },
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        }),);
    if (response.statusCode == 201) {
      final responseData = response.data as Map<String, dynamic>;
      final data = responseData['data'] as Map<String, dynamic>;
      return CartModel.fromJson(data);
    }
    else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<CartModel> updateItemQuantity(
      String token,
      String productId,
      int quantity,
      ) async {
    try {
      final response = await dio.put(
        '${ApiConstants.baseUrl}/api/v1/cart/items/$productId',
        data: {'quantity': quantity},
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        }),
      );

      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;
        final data = responseData['data'] as Map<String, dynamic>;
        return CartModel.fromJson(data);
      } else if (response.statusCode == 401) {
        throw UnauthorizedException();
      } else {
        throw ServerException();
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 500) {
        final errorData = e.response?.data;
        if (errorData != null && errorData['message'] != null) {
          final message = errorData['message'] as String;
          if (message.contains('Insufficient stock')) {
            final regex = RegExp(r'Available: (\d+)');
            final match = regex.firstMatch(message);
            final available = match != null ? int.parse(match.group(1)!) : 0;

            throw InsufficientStockException(
              message: message,
              availableStock: available,
            );
          }
        }
      }
      throw ServerException();
    }
  }

  @override
  Future<void> removeItem(String token, String productId) async {

    final response = await dio.delete(
      '${ApiConstants.baseUrl}/api/v1/cart/items/$productId',
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        }));

    if (response.statusCode == 200) {
      return;
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<void> clearCart(String token) async {
    final response = await dio.delete(
      '${ApiConstants.baseUrl}/api/v1/cart/clear',
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        }));

    if (response.statusCode == 200) {
      return;
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else {
      throw ServerException();
    }
  }
}
import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getAllProducts(String token);
  Future<List<ProductModel>> getMyProducts(String token);
  Future<ProductModel> getProductById(String token, String productId);
  Future<List<ProductModel>> searchProducts(String token, String query);
  Future<List<ProductModel>> getProductsByCategory(String token, String category);
  Future<ProductModel> createProduct(String token, Map<String, dynamic> productData);
  Future<ProductModel> updateProduct(String token, String productId, Map<String, dynamic> productData);
  Future<void> deleteProduct(String token, String productId);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final Dio dio;

  ProductRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<ProductModel>> getAllProducts(String token) async {
    final response = await dio.get(
      '${ApiConstants.baseUrl}/api/v1/products',
      options: Options(headers: {'Authorization': 'Bearer $token','Content-Type': 'application/json'}),
    );

    final status = response.statusCode ?? 0;
    if (status == 200) {
      final responseData = response.data as Map<String, dynamic>;
      final data = responseData['data'] as List<dynamic>;
      return List<ProductModel>.from(data.map((x) => ProductModel.fromJson(x)));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<ProductModel>> getMyProducts(String token) async {
    try {
      final response = await dio.get(
        '${ApiConstants.baseUrl}/api/v1/products/my-products',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        }),
      );

      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;
        final data = responseData['data'] as List<dynamic>;

        final products = data.map((json) => ProductModel.fromJson(json)).toList();

        return products;
      } else {
        throw ServerException();
      }
    } on DioException catch (e) {
      throw ServerException();
    } catch (e, stackTrace) {
      throw ServerException();
    }
  }

  @override
  Future<ProductModel> createProduct(String token, Map<String, dynamic> productData) async {
    final response = await dio.post(
      '${ApiConstants.baseUrl}/api/v1/products',
      data: productData,
      options: Options(headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      }),
    );

    final status = response.statusCode ?? 0;
    if (status == 201) {
      final responseData = response.data as Map<String, dynamic>;
      final data = responseData['data'] as Map<String, dynamic>;
      return ProductModel.fromJson(data);
    } else if (status == 400) {
      final error = response.data as Map<String, dynamic>;
      throw BadRequestException(error['message'] ?? 'Product creation failed');
    } else if (status == 401) {
      throw ServerException();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<ProductModel> getProductById(String token, String productId) async {
    final response = await dio.get(
      '${ApiConstants.baseUrl}/api/v1/products/$productId',
      options: Options(headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      }),
    );

    final status = response.statusCode ?? 0;
    if (status == 200) {
      final data = json.decode(response.data);
      return ProductModel.fromJson(data);
    } else if (status == 401) {
      throw ServerException();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<ProductModel>> searchProducts(String token, String query) async {
    final response = await dio.get(
      '${ApiConstants.baseUrl}/api/v1/products/search?query=$query',
      options: Options(headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      }),
    );

    final status = response.statusCode ?? 0;
    if (status == 200) {
      final data = json.decode(response.data);
      return List<ProductModel>.from(data.map((x) => ProductModel.fromJson(x)));
    } else if (status == 401) {
      throw ServerException();
    } else {
      throw ServerException();
    }

  }

  @override
  Future<List<ProductModel>> getProductsByCategory(String token,
      String category) async {
    final response = await dio.get(
      '${ApiConstants.baseUrl}/api/v1/products/category/$category',
    options: Options(headers: { 'Authorization': 'Bearer $token', 'Content-Type': 'application/json' }),
    );
    final status = response.statusCode ?? 0;
    if (status == 200) {
      final data = json.decode(response.data);
      return List<ProductModel>.from(data.map((x) => ProductModel.fromJson(x)));
    } else if (status == 401) {
      throw ServerException();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<ProductModel> updateProduct(String token,
      String productId,
      Map<String, dynamic> productData,) async {
    final response = await dio.put(
        '${ApiConstants.baseUrl}/api/v1/products/$productId',
        data: productData,
        options: Options(headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        }));

    final status = response.statusCode ?? 0;
    if (status == 200) {
      final responseData = response.data as Map<String, dynamic>;
      final data = responseData['data'] as Map<String, dynamic>;
      return ProductModel.fromJson(data);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<void> deleteProduct(String token, String productId) async {
    final response = await dio.delete(
        '${ApiConstants.baseUrl}/api/v1/products/$productId',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        }));

    final status = response.statusCode ?? 0;
    if (status == 200) {
      return;
    } else {
      throw ServerException();
    }
  }
}

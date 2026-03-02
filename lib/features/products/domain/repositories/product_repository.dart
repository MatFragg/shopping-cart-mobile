import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/product.dart';

abstract class ProductRepository {
  // TODO: Definir contratos para:

  // Browsing (Comprador)
  Future<Either<Failure, List<Product>>> getAllProducts(String token);
  Future<Either<Failure, List<Product>>> searchProducts(String token, String query);
  Future<Either<Failure, List<Product>>> getProductsByCategory(String token, String category);
  Future<Either<Failure, Product>> getProductById(String token, String productId);

  // Managing (Vendedor)
  Future<Either<Failure, List<Product>>> getMyProducts(String token);
  Future<Either<Failure, Product>> createProduct(String token,{
    required String name,
    required String description,
    required double price,
    required int stock,
    required String category,
    String? imageUrl,
  });
  Future<Either<Failure, Product>> updateProduct(String token,{
    required String productId,
    String? name,
    String? description,
    double? price,
    int? stock,
    String? category,
    String? imageUrl,
    required bool active,
    required bool available,
  });
  Future<Either<Failure, void>> deleteProduct(String token,String productId);
}
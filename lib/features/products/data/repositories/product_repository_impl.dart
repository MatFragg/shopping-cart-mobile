import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_local_data_source.dart';
import '../datasources/product_remote_data_source.dart';
import '../../../authentication/data/datasources/token_data_source.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;
  final TokenDataSource tokenDataSource;
  final NetworkInfo networkInfo;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.tokenDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Product>>> getAllProducts(String token) async {
    // TODO: Implementar estrategia offline-first
    // 1. Verificar conectividad
    // 2. Si hay internet: obtener de remoto, cachear, retornar
    // 3. Si no hay internet: obtener de cache
    // 4. Manejar excepciones y convertir a Failures

    if (token.trim().isEmpty) {
      return Left(AuthenticationFailure('Token no válido'));
    }

    if (await networkInfo.isConnected) {
      try {
        final products = await remoteDataSource.getAllProducts(token);
        await localDataSource.cacheProducts(products);
        return Right(products);
      } on ServerException {
        return Left(ServerFailure());
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      try {
        final cachedProducts = await localDataSource.getCachedProducts();
        return Right(cachedProducts);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  // TODO: Implementar resto de métodos siguiendo el patrón:
  // - Verificar red
  // - Obtener token si es necesario (para operaciones autenticadas)
  // - Llamar remoteDataSource
  // - Cachear si aplica
  // - Manejar errores

  @override
  Future<Either<Failure, List<Product>>> getMyProducts(String token) async {
    if (token.trim().isEmpty) {
      return Left(AuthenticationFailure('Token no válido'));
    }

    if (await networkInfo.isConnected) {
      try {
        final products = await remoteDataSource.getMyProducts(token);
        // Cachea específicamente "mis productos"
        await localDataSource.cacheProducts(products);
        return Right(products);
      } on ServerException {
        return Left(ServerFailure());
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      try {
        // El LocalDataSource internamente consulta Users para obtener customerId
        final cachedProducts = await localDataSource.getCachedMyProducts();
        return Right(cachedProducts);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, Product>> createProduct(String token, {
    required String name,
    required String description,
    required double price,
    required int stock,
    required String category,
    String? imageUrl,
  }) async {
    if (token.trim().isEmpty) {
      return Left(AuthenticationFailure('Token no válido'));
    }

    try {
      final product = await remoteDataSource.createProduct(token, {
        'name': name,
        'description': description,
        'price': price,
        'stock': stock,
        'category': category,
        'imageUrl': imageUrl,
      });
      return Right(product);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }



  @override
  Future<Either<Failure, Product>> updateProduct(String token, {
    required String productId,
    String? name,
    String? description,
    double? price,
    int? stock,
    String? category,
    String? imageUrl,
    required bool active,
    required bool available,
  }) async {
    if (token.trim().isEmpty) {
      return Left(AuthenticationFailure('Token no válido'));
    }

    try {
      final product = await remoteDataSource.updateProduct(token, productId, {
        'name': name,
        'description': description,
        'price': price,
        'stock': stock,
        'category': category,
        'imageUrl': imageUrl,
        'active': active,
        'available': available,
      });
      return Right(product);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteProduct(String token, String productId) async {
  if (token.trim().isEmpty) {
  return Left(AuthenticationFailure('Token no válido'));
  }

  try {
  await remoteDataSource.deleteProduct(token, productId);
  return Right(null);
  } on ServerException {
  return Left(ServerFailure());
  } catch (e) {
  return Left(ServerFailure());
  }
  }

  @override
  Future<Either<Failure, Product>> getProductById(String token, String productId) async {
    if (token.trim().isEmpty) {
      return Left(AuthenticationFailure('Token no válido'));
    }

    try {
      final product = await remoteDataSource.getProductById(token, productId);
      return Right(product);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Product>>> searchProducts(String token, String query) async {
    if (token.trim().isEmpty) {
      return Left(AuthenticationFailure('Token no válido'));
    }

    try {
      final products = await remoteDataSource.searchProducts(token, query);
      return Right(products);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getProductsByCategory(String token, String category) async {
    if (token.trim().isEmpty) {
      return Left(AuthenticationFailure('Token no válido'));
    }

    try {
      final products = await remoteDataSource.getProductsByCategory(token, category);
      return Right(products);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
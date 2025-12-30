import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../authentication/data/datasources/token_data_source.dart';
import '../../domain/entities/cart.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_remote_data_source.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource remoteDataSource;
  final TokenDataSource tokenDataSource;
  final NetworkInfo networkInfo;

  CartRepositoryImpl({
    required this.remoteDataSource,
    required this.tokenDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Cart>> getActiveCart() async {
    // TODO: Implementar
    // 1. Verificar conectividad
    // 2. Obtener token
    // 3. Llamar remoteDataSource.getActiveCart()
    // 4. Manejar excepciones

    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure());
    }

    try {
      final token = await tokenDataSource.getToken();
      if (token == null) {
        return Left(AuthenticationFailure('No token available'));
      }

      final cart = await remoteDataSource.getActiveCart(token);
      return Right(cart);
    } on UnauthorizedException {
      return Left(AuthenticationFailure('Session expired'));
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  // TODO: Implementar resto de métodos siguiendo el patrón

  @override
  Future<Either<Failure, Cart>> addItem({
    required String productId,
    required int quantity,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Cart>> updateItemQuantity({
    required String productId,
    required int quantity,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> removeItem(String productId) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> clearCart() {
    throw UnimplementedError();
  }
}
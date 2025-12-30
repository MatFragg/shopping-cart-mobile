import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../authentication/data/datasources/token_data_source.dart';
import '../../domain/entities/cart.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_local_data_source.dart';
import '../datasources/cart_remote_data_source.dart';
import '../models/cart_item_model.dart';
import '../models/cart_model.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource remoteDataSource;
  final CartLocalDataSource localDataSource;
  final TokenDataSource tokenDataSource;
  final NetworkInfo networkInfo;

  CartRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.tokenDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Cart>> getActiveCart() async {
    try {
      final token = await tokenDataSource.getToken();
      if (token == null || token.trim().isEmpty) {
        return Left(AuthenticationFailure('Token no válido'));
      }

      if (await networkInfo.isConnected) {
        try {
          final cart = await remoteDataSource.getActiveCart(token);
          await _cacheCartData(cart);
          return Right(cart);
        } on UnauthorizedException {
          return Left(AuthenticationFailure('Session expired'));
        } on ServerException {
          try {
            final cachedCart = await _getCachedCartWithItems();
            if (cachedCart != null) {
              return Right(cachedCart);
            }
          } on CacheException {
            // Ignorar error de caché
          }
          return Left(ServerFailure());
        }
      } else {
        try {
          final cachedCart = await _getCachedCartWithItems();
          if (cachedCart != null) {
            return Right(cachedCart);
          }
          return Left(CacheFailure());
        } on CacheException {
          return Left(CacheFailure());
        }
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Cart>> addItem({
    required String productId,
    required int quantity,
  }) async {
    try {
      final token = await tokenDataSource.getToken();
      if (token == null || token.trim().isEmpty) {
        return Left(AuthenticationFailure('Token no válido'));
      }

      if (!await networkInfo.isConnected) {
        return Left(NetworkFailure());
      }

      final cart = await remoteDataSource.addItem(token, productId, quantity);
      await _cacheCartData(cart);
      return Right(cart);
    } on UnauthorizedException {
      return Left(AuthenticationFailure('Session expired'));
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Cart>> updateItemQuantity({
    required String productId,
    required int quantity,
  }) async {
    try {
      final token = await tokenDataSource.getToken();
      if (token == null || token.trim().isEmpty) {
        return Left(AuthenticationFailure('Token no válido'));
      }

      if (!await networkInfo.isConnected) {
        return Left(NetworkFailure());
      }

      final cart = await remoteDataSource.updateItemQuantity(
        token,
        productId,
        quantity,
      );
      await _cacheCartData(cart);
      return Right(cart);
    } on InsufficientStockException catch (e) {
      return Left(InsufficientStockFailure(
        message: e.message,
        availableStock: e.availableStock,
      ));
    } on UnauthorizedException {
      return Left(AuthenticationFailure('Session expired'));
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> removeItem(String productId) async {
    try {
      final token = await tokenDataSource.getToken();
      if (token == null || token.trim().isEmpty) {
        return Left(AuthenticationFailure('Token no válido'));
      }

      if (!await networkInfo.isConnected) {
        return Left(NetworkFailure());
      }

      await remoteDataSource.removeItem(token, productId);
      await localDataSource.removeCartItem(productId);
      return const Right(null);
    } on UnauthorizedException {
      return Left(AuthenticationFailure('Session expired'));
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> clearCart() async {
    try {
      final token = await tokenDataSource.getToken();
      if (token == null || token.trim().isEmpty) {
        return Left(AuthenticationFailure('Token no válido'));
      }

      if (!await networkInfo.isConnected) {
        return Left(NetworkFailure());
      }

      await remoteDataSource.clearCart(token);
      await localDataSource.clearCart();
      return const Right(null);
    } on UnauthorizedException {
      return Left(AuthenticationFailure('Session expired'));
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  Future<void> _cacheCartData(CartModel cart) async {
    try {
      await localDataSource.cacheCart(cart);

      for (final item in cart.items) {
        final itemModel = item is CartItemModel
            ? item
            : CartItemModel(
          id: item.id,
          cartId: cart.id,
          productId: item.productId,
          sellerId: item.sellerId,
          productName: item.productName,
          quantity: item.quantity,
          unitPrice: item.unitPrice,
          subtotal: item.subtotal,
          imageUrl: item.imageUrl,
        );
        await localDataSource.addCartItem(itemModel);
      }
    } catch (e) {
    }
  }

  Future<CartModel?> _getCachedCartWithItems() async {
    final cachedCart = await localDataSource.getCachedCart();
    if (cachedCart == null) return null;

    final cachedItems = await localDataSource.getCachedCartItems();

    return CartModel(
      id: cachedCart.id,
      customerId: cachedCart.customerId,
      status: cachedCart.status,
      total: cachedCart.total,
      items: cachedItems,
    );
  }
}

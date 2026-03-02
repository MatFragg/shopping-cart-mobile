import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/cart.dart';

abstract class CartRepository {
  Future<Either<Failure, Cart>> getActiveCart();
  Future<Either<Failure, Cart>> addItem({
    required String productId,
    required int quantity,
  });
  Future<Either<Failure, Cart>> updateItemQuantity({
    required String productId,
    required int quantity,
  });
  Future<Either<Failure, void>> removeItem(String productId);
  Future<Either<Failure, void>> clearCart();
}
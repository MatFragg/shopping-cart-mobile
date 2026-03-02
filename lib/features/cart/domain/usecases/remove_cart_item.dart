import 'package:dartz/dartz.dart';
import 'package:shopping_cart/core/error/failures.dart';
import 'package:shopping_cart/core/usecases/usecase.dart';
import 'package:shopping_cart/features/cart/domain/repositories/cart_repository.dart';

class RemoveCartItem implements UseCase<void, RemoveCartItemParams> {
  final CartRepository repository;

  RemoveCartItem(this.repository);

  @override
  Future<Either<Failure, void>> call(RemoveCartItemParams params) async {
    if (params.productId.isEmpty) {
      return Left(ValidationFailure('Product ID cannot be empty'));
    }
    return repository.removeItem(params.productId);
  }
}

class RemoveCartItemParams {
  final String productId;

  RemoveCartItemParams({required this.productId});
}
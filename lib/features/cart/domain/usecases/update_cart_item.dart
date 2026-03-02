import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:shopping_cart/core/error/failures.dart';
import 'package:shopping_cart/core/usecases/usecase.dart';
import 'package:shopping_cart/features/cart/domain/entities/cart.dart';
import 'package:shopping_cart/features/cart/domain/repositories/cart_repository.dart';

class UpdateCartItem implements UseCase<Cart, UpdateCartItemParams>{
  final CartRepository repository;

  UpdateCartItem(this.repository);

  @override
  Future<Either<Failure, Cart>> call(UpdateCartItemParams params) async {
    if (params.productId.isEmpty) {
      return Left(ValidationFailure('Product ID cannot be empty'));
    }

    if (params.quantity <= 0) {
      return Left(ValidationFailure('Quantity must be greater than 0'));
    }

    return await repository.updateItemQuantity(
      productId: params.productId,
      quantity: params.quantity,
    );
  }
}

class UpdateCartItemParams extends Equatable {
  final String productId;
  final int quantity;

  const UpdateCartItemParams({required this.productId, required this.quantity});

  @override
  List<Object?> get props => [productId, quantity];
}


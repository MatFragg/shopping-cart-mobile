import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/cart.dart';
import '../repositories/cart_repository.dart';

class AddItemToCart implements UseCase<Cart, AddItemParams> {
  final CartRepository repository;

  AddItemToCart(this.repository);

  @override
  Future<Either<Failure, Cart>> call(AddItemParams params) async {
    // TODO: Validaciones antes de llamar al repository
    if (params.quantity <= 0) {
      return Left(ValidationFailure('Quantity must be greater than 0'));
    }

    return await repository.addItem(
      productId: params.productId,
      quantity: params.quantity,
    );
  }
}

class AddItemParams extends Equatable {
  final String productId;
  final int quantity;

  const AddItemParams({
    required this.productId,
    required this.quantity,
  });

  @override
  List<Object?> get props => [productId, quantity];
}
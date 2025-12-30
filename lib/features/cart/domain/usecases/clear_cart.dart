import 'package:dartz/dartz.dart';
import 'package:shopping_cart/core/error/failures.dart';
import 'package:shopping_cart/core/usecases/usecase.dart';
import 'package:shopping_cart/features/cart/domain/repositories/cart_repository.dart';

class ClearCart implements UseCase<void, void> {
  final CartRepository repository;

  ClearCart(this.repository);

  @override
  Future<Either<Failure, void>> call(void params) async {
    return repository.clearCart();
  }
}
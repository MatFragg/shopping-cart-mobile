import 'package:dartz/dartz.dart';
import 'package:shopping_cart/core/error/failures.dart';
import 'package:shopping_cart/core/usecases/usecase.dart';
import 'package:shopping_cart/features/cart/domain/entities/cart.dart';
import 'package:shopping_cart/features/cart/domain/repositories/cart_repository.dart';

class GetActiveCart implements UseCase<Cart, void> {
  final CartRepository repository;

  GetActiveCart(this.repository);

  @override
  Future<Either<Failure, Cart>> call(void params) async {
    return await repository.getActiveCart();
  }

}
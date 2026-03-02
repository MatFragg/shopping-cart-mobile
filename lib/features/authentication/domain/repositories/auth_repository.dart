import 'package:dartz/dartz.dart';
import 'package:shopping_cart/core/error/failures.dart';
import 'package:shopping_cart/features/authentication/domain/entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> register({
    required String username,
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phone,
    required String shippingAddress,
  });

  Future<Either<Failure, User>> login({
    required String username,
    required String password,
  });

  Future<Either<Failure, User>> getCurrentUser(String token);

  Future<Either<Failure, void>> logout();
}
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetMyProducts implements UseCase<List<Product>, GetMyProductsParams> {
  final ProductRepository repository;

  GetMyProducts(this.repository);

  @override
  Future<Either<Failure, List<Product>>> call(GetMyProductsParams params) {
    return repository.getMyProducts(params.token);
  }
}

class GetMyProductsParams extends Equatable {
  final String token;

  const GetMyProductsParams(this.token);

  @override
  List<Object?> get props => [token];
}

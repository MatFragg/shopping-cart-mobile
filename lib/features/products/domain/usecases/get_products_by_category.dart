import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProductsByCategory implements UseCase<List<Product>, GetProductsByCategoryParams> {
  final ProductRepository repository;

  GetProductsByCategory(this.repository);

  @override
  Future<Either<Failure, List<Product>>> call(GetProductsByCategoryParams params) {
    return repository.getProductsByCategory(params.token, params.category);
  }
}

class GetProductsByCategoryParams extends Equatable {
  final String token;
  final String category;

  const GetProductsByCategoryParams(this.token, this.category);

  @override
  List<Object?> get props => [token, category];
}

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetAllProducts implements UseCase<List<Product>, GetAllProductsParams> {
  final ProductRepository repository;

  GetAllProducts(this.repository);

  @override
  Future<Either<Failure, List<Product>>> call(GetAllProductsParams params) async {
    return await repository.getAllProducts(params.token);
  }
}

class GetAllProductsParams extends Equatable {
  final String token;

  const GetAllProductsParams(this.token);

  @override
  List<Object?> get props => [token];
}
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class SearchProducts implements UseCase<List<Product>, SearchProductsParams> {
  final ProductRepository repository;

  SearchProducts(this.repository);

  @override
  Future<Either<Failure, List<Product>>> call(SearchProductsParams params) {
    return repository.searchProducts(params.token, params.query);
  }
}

class SearchProductsParams extends Equatable {
  final String token;
  final String query;

  const SearchProductsParams(this.token, this.query);

  @override
  List<Object?> get props => [token, query];
}

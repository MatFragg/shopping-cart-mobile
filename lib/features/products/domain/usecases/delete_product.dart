import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/product_repository.dart';

class DeleteProduct implements UseCase<void, DeleteProductParams> {
  final ProductRepository repository;

  DeleteProduct(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteProductParams params) {
    return repository.deleteProduct(params.token, params.productId);
  }
}

class DeleteProductParams extends Equatable {
  final String token;
  final String productId;

  const DeleteProductParams(this.token, this.productId);

  @override
  List<Object?> get props => [token, productId];
}

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:shopping_cart/core/error/failures.dart';
import 'package:shopping_cart/core/usecases/usecase.dart';
import 'package:shopping_cart/features/products/domain/entities/product.dart';
import 'package:shopping_cart/features/products/domain/repositories/product_repository.dart';


class UpdateProduct implements UseCase<Product, UpdateProductParams> {
  final ProductRepository repository;

  UpdateProduct(this.repository);

  @override
  Future<Either<Failure, Product>> call(UpdateProductParams params) async {
    return await repository.updateProduct(
      params.token,
      productId: params.productId,
      name: params.name,
      description: params.description,
      price: params.price,
      stock: params.stock,
      category: params.category,
      imageUrl: params.imageUrl,
      active: params.active,
      available: params.available,
    );
  }
}

class UpdateProductParams extends Equatable {
  final String token;
  final String productId;
  final String? name;
  final String? description;
  final double? price;
  final int? stock;
  final String? category;
  final String? imageUrl;
  final bool active;
  final bool available;

  const UpdateProductParams(this.token, this.productId, {
    this.name,
    this.description,
    this.price,
    this.stock,
    this.category,
    this.imageUrl,
    required this.active,
    required this.available,
  });

  @override
  List<Object?> get props => [token, productId, name, description, price, stock, category, imageUrl, active, available];
}
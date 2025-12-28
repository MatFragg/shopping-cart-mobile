import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:shopping_cart/core/error/failures.dart';
import 'package:shopping_cart/core/usecases/usecase.dart';
import 'package:shopping_cart/features/products/domain/entities/product.dart';
import 'package:shopping_cart/features/products/domain/repositories/product_repository.dart';

class CreateProduct implements UseCase<Product, CreateProductParams> {
  final ProductRepository repository;

  CreateProduct(this.repository);

  @override
  Future<Either<Failure, Product>> call(CreateProductParams params) async {
    return await repository.createProduct(
      params.token,
      name: params.name,
      description: params.description,
      price: params.price,
      stock: params.stock,
      category: params.category,
      imageUrl: null,
    );
  }
}

class CreateProductParams extends Equatable {
  final String token;
  final String name;
  final String description;
  final double price;
  final int stock;
  final String category;
  final String? imageUrl;
  final bool active;
  final bool available;


  const CreateProductParams(this.token,{
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.category,
    this.imageUrl,
    this.active = true,
    this.available = true,
  });

  @override
  List<Object?> get props => [
    token,
    name,
    description,
    price,
    stock,
    category,
    imageUrl,
    active,
    available,
  ];
}
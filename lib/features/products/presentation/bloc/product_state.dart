import 'package:equatable/equatable.dart';
import '../../domain/entities/product.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

// States para lista de productos
class ProductsLoaded extends ProductState {
  final List<Product> products;
  final String? activeCategory; // Para filtros

  const ProductsLoaded({
    required this.products,
    this.activeCategory,
  });

  @override
  List<Object?> get props => [products, activeCategory];
}

// State para detalle de producto
class ProductDetailLoaded extends ProductState {
  final Product product;

  const ProductDetailLoaded(this.product);

  @override
  List<Object?> get props => [product];
}

// State para operaciones exitosas
class ProductOperationSuccess extends ProductState {
  final String message;

  const ProductOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class ProductError extends ProductState {
  final String message;

  const ProductError(this.message);

  @override
  List<Object?> get props => [message];
}

class ProductEmpty extends ProductState {
  final String message;

  const ProductEmpty(this.message);

  @override
  List<Object?> get props => [message];
}
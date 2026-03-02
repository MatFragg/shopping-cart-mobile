import 'package:equatable/equatable.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

// Browsing Events
class LoadAllProducts extends ProductEvent {
  final bool excludeMine;
  final String? token;

  const LoadAllProducts({this.excludeMine = true, this.token});

  @override
  List<Object?> get props => [excludeMine, token];
}

class SearchProductsEvent extends ProductEvent {
  final String? token;
  final String query;

  const SearchProductsEvent(this.query, {this.token});

  @override
  List<Object?> get props => [token, query];
}

class FilterByCategory extends ProductEvent {
  final String? token;
  final String category;

  const FilterByCategory(this.category, {this.token});

  @override
  List<Object?> get props => [token, category];
}

class LoadProductDetail extends ProductEvent {
  final String productId;

  const LoadProductDetail(this.productId);

  @override
  List<Object?> get props => [productId];
}

// Managing Events (Seller)
class LoadMyProducts extends ProductEvent {
  final String? token;

  const LoadMyProducts({this.token});

  @override
  List<Object?> get props => [token];
}

class CreateProductEvent extends ProductEvent {
  final String? token;
  final String name;
  final String description;
  final double price;
  final int stock;
  final String category;
  final String? imageUrl;
  final bool active;
  final bool available;


  const CreateProductEvent({
    this.token,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.category,
    this.imageUrl,
    required this.active,
    required this.available,
  });

  @override
  List<Object?> get props =>
      [token, name, description, price, stock, category, imageUrl, active, available];
}

class UpdateProductEvent extends ProductEvent {
  final String? token;
  final String productId;
  final String? name;
  final String? description;
  final double? price;
  final int? stock;
  final String? category;
  final String? imageUrl;
  final bool active;
  final bool available;

  const UpdateProductEvent({
    this.token,
    required this.productId,
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

class DeleteProductEvent extends ProductEvent {
  final String? token;
  final String productId;

  const DeleteProductEvent(this.productId, {this.token});

  @override
  List<Object?> get props => [token, productId];
}
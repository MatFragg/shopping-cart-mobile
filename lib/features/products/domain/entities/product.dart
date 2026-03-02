import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final int stock;
  final String category;
  final String? imageUrl;
  final String sellerId;
  final bool active;
  final bool available;
  final DateTime? createdAt;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.category,
    this.imageUrl,
    required this.sellerId,
    required this.active,
    required this.available,
    this.createdAt,
  });

  bool get isInStock => stock > 0;
  bool get isAvailable => active && available && stock > 0;
  String get formattedPrice => '\$${price.toStringAsFixed(2)}';
  String get stockStatus => stock > 10 ? 'In Stock' :
                              stock > 0 ? 'Low Stock' : 'Out of Stock';

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    price,
    stock,
    category,
    imageUrl,
    sellerId,
    active,
    available,
    createdAt,
  ];
}
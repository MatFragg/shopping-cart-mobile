import 'package:equatable/equatable.dart';
import 'cart_item.dart';

class Cart extends Equatable {
  final String id;
  final String customerId;
  final List<CartItem> items;
  final double total;
  final String status; // ACTIVE, CONVERTED, ABANDONED
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Cart({
    required this.id,
    required this.customerId,
    required this.items,
    required this.total,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  int get itemCount => items.length;
  int get totalQuantity => items.fold(0, (sum, item) => sum + item.quantity);
  bool get isEmpty => items.isEmpty;
  bool get isNotEmpty => items.isNotEmpty;
  String get formattedTotal => '\$${total.toStringAsFixed(2)}';
  bool hasProduct(String productId) => items.any((item) => item.productId == productId);

  @override
  List<Object?> get props => [id, customerId, items, total, status, createdAt, updatedAt];
}
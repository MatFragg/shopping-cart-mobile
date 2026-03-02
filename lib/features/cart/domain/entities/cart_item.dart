import 'package:equatable/equatable.dart';

class CartItem extends Equatable {
  final String id;
  final String cartId;
  final String productId;
  final String sellerId;
  final String productName;
  final int quantity;
  final double unitPrice;
  final double subtotal;
  final String? imageUrl;

  const CartItem({
    required this.id,
    required this.cartId,
    required this.productId,
    required this.sellerId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.subtotal,
    this.imageUrl,
  });

  String get formattedUnitPrice => '\$${unitPrice.toStringAsFixed(2)}';
  String get formattedSubtotal => '\$${subtotal.toStringAsFixed(2)}';
  bool get isMultiple => quantity > 1;

  @override
  List<Object?> get props => [
    id,
    cartId,
    productId,
    sellerId,
    productName,
    quantity,
    unitPrice,
    subtotal,
    imageUrl
  ];
}
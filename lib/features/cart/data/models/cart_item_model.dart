import '../../domain/entities/cart_item.dart';

class CartItemModel extends CartItem {
  const CartItemModel({
    required super.id,
    required super.cartId,
    required super.productId,
    required super.sellerId,
    required super.productName,
    required super.quantity,
    required super.unitPrice,
    required super.subtotal,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id']?.toString() ?? '',
      cartId: json['cartId']?.toString() ?? '',
      productId: json['productId']?.toString() ?? '',
      sellerId: json['sellerId']?.toString() ?? '',
      productName: json['productName'] ?? '',
      quantity: json['quantity'] ?? 0,
      unitPrice: (json['unitPrice'] as num?)?.toDouble() ?? 0.0,
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cartId': cartId,
      'productId': productId,
      'sellerId': sellerId,
      'productName': productName,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'subtotal': subtotal
    };
  }

  factory CartItemModel.fromDrift(Map<String, dynamic> driftData) {
    return CartItemModel(
      id: driftData['id']?.toString() ?? '',
      cartId: driftData['cartId']?.toString() ?? '',
      productId: driftData['productId']?.toString() ?? '',
      sellerId: driftData['sellerId']?.toString() ?? '',
      productName: driftData['productName'] ?? '',
      quantity: driftData['quantity'] ?? 0,
      unitPrice: driftData['unitPrice']?.toDouble() ?? 0.0,
      subtotal: driftData['subtotal']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toDrift() {
    return {
      'id': id,
      'cartId': cartId,
      'productId': productId,
      'sellerId': sellerId,
      'productName': productName,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'subtotal': subtotal
    };
  }

  CartItemModel copyWith({
    String? id,
    String? cartId,
    String? productId,
    String? sellerId,
    String? productName,
    int? quantity,
    double? unitPrice,
    double? subtotal}) {
    return CartItemModel(
      id: id ?? this.id,
      cartId: cartId ?? this.cartId,
      productId: productId ?? this.productId,
      sellerId: sellerId ?? this.sellerId,
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      subtotal: subtotal ?? this.subtotal,
    );
  }
}
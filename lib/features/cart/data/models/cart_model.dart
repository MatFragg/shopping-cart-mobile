import 'package:shopping_cart/features/cart/data/models/cart_item_model.dart';
import 'package:shopping_cart/features/cart/domain/entities/cart.dart';

class CartModel extends Cart {
  const CartModel({
    required super.id,
    required super.customerId,
    required super.items,
    required super.total,
    required super.status,
  });

  // TODO: Implementar fromJson
  // Backend retorna:
  // {
  //   "id": 1,
  //   "customerId": 1,
  //   "status": "ACTIVE",
  //   "total": 199.99,
  //   "items": [
  //     {
  //       "id": 1,
  //       "productId": 5,
  //       "sellerId": 2,
  //       "productName": "Product Name",
  //       "quantity": 2,
  //       "unitPrice": 99.99,
  //       "subtotal": 199.98
  //     }
  //   ],
  //   "createdAt": "2025-12-21T10:00:00",
  //   "updatedAt": "2025-12-21T12:00:00"
  // }

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['id']?.toString() ?? '',
      customerId: json['customerId']?.toString() ?? '',
      items: (json['items'] as List?)
          ?.map((item) => CartItemModel.fromJson(item))
          .toList() ??
          [],
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] ?? 'ACTIVE',
    );
  }

  // TODO: Implementar toJson (para cache)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId,
      'status': status,
      'total': total,
      'items': items.map((item) => (item as CartItemModel).toJson()).toList(),
    };
  }

  factory CartModel.fromDrift(Map<String, dynamic> driftData) {
    return CartModel(
      id: driftData['id']?.toString() ?? '',
      customerId: driftData['customerId']?.toString() ?? '',
        status: driftData['status'] ?? 'ACTIVE',
        total: driftData['total']?.toDouble() ?? 0.0,
        items: (driftData['items'] as List?)
            ?.map((item) => CartItemModel.fromDrift(item))
            .toList() ??
            [],
    );
  }

  Map<String, dynamic> toDrift() {
    return {
      'id': id,
      'customerId': customerId,
      'status': status,
      'total': total,
      'items': items.map((item) => (item as CartItemModel).toDrift()).toList(),
    };
  }
}
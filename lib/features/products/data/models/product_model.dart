import '../../domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    required super.stock,
    required super.category,
    super.imageUrl,
    required super.sellerId,
    required super.active,
    required super.available,
    super.createdAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    try {
      return ProductModel(
        id: json['id'].toString(),
        name: json['name'] as String,
        description: json['description'] as String,
        price: (json['price'] as num).toDouble(),
        stock: json['stock'] as int,
        category: json['category'] as String,
        imageUrl: json['imageUrl'] as String?,
        sellerId: (json['sellerId'] as int).toString(),
        active: json['active'] as bool? ?? true,
        available: json['available'] as bool? ?? true,
        createdAt: json['createdAt'] != null
            ? DateTime.tryParse(json['createdAt'])
            : null,
      );
    } catch (e, stackTrace) {
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'stock': stock,
      'category': category,
      'imageUrl': imageUrl,
      'active': active,
      'available': available,
    };
  }

  factory ProductModel.fromDrift(Map<String, dynamic> driftData) {
    return ProductModel(
      id: driftData['id']?.toString() ?? '',
      name: driftData['name'] ?? '',
      description:  driftData['description'] ?? '',
      price: driftData['price']?.toDouble() ?? 0.0,
      stock: driftData['stock']?.toInt() ?? 0,
      category: driftData['category'] ?? '',
      imageUrl: driftData['imageUrl'] ?? '',
      sellerId: driftData['sellerId']?.toString() ?? '',
      active: driftData['active'] ?? false,
      available: driftData['available'] ?? false,
    );
  }

  Map<String, dynamic> toDrift() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'stock': stock,
      'category': category,
      'imageUrl': imageUrl,
      'sellerId': sellerId,
      'active': active,
      'available': available,
    };
  }

  ProductModel copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    int? stock,
    String? category,
    String? imageUrl,
    bool? active,
    bool? available
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      sellerId: sellerId,
      active: active ?? this.active,
      available: available ?? this.available,
    );
  }
}
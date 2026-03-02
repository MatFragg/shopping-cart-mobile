import 'package:drift/drift.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/database/app_database.dart';
import '../models/product_model.dart';

abstract class ProductLocalDataSource {
  Future<List<ProductModel>> getCachedProducts();
  Future<void> cacheProducts(List<ProductModel> products);
  Future<ProductModel?> getCachedProductById(String productId);
  Future<List<ProductModel>> getCachedMyProducts();
  Future<void> clearCache();
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final AppDatabase database;

  ProductLocalDataSourceImpl({required this.database});

  @override
  Future<List<ProductModel>> getCachedProducts() async {
    try {
      final results = await database.select(database.products).get();
      return results.map((row) => ProductModel.fromDrift(row.toJson())).toList();
    } catch (e) {
      throw CacheException();
    }
  }
  @override
  Future<void> cacheProducts(List<ProductModel> products) async {
    try {
      await database.batch((batch) {
        batch.insertAll(
          database.products,
          products.map((p) => ProductsCompanion(
            id: Value(p.id),
            name: Value(p.name),
            description: Value(p.description),
            price: Value(p.price),
            stock: Value(p.stock),
            category: Value(p.category),
            imageUrl: Value(p.imageUrl),
            sellerId: Value(p.sellerId),
            active: Value(p.active),
            available: Value(p.available),
            createdAt: Value(p.createdAt),
          )).toList(),
          mode: InsertMode.replace,
        );
      });
    } catch (e) {
      throw CacheException();
    }
  }


  // TODO: Implementar resto de métodos

  @override
  Future<ProductModel> getCachedProductById(String id) async {
    final product = await (database.select(database.products)
      ..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
    if (product == null) {
      throw CacheException();
    }
    return ProductModel.fromDrift({
      'id': product.id,
      'name': product.name,
      'description': product.description,
      'price': product.price,
      'stock': product.stock,
      'category': product.category,
      'imageUrl': product.imageUrl,
      'sellerId': product.sellerId,
      'active': product.active,
      'available': product.available,
      'createdAt': product.createdAt?.toIso8601String(),
    });
  }
  @override
  Future<List<ProductModel>> getCachedMyProducts() async {
    final currentUser = await (database.select(database.users)).getSingleOrNull();

    if (currentUser?.customerId == null) {
      throw CacheException();
    }

    final products = await (database.select(database.products)
      ..where((tbl) => tbl.active.equals(true) & tbl.sellerId.equals(currentUser!.customerId!))).get();

    if (products.isEmpty) {
      throw CacheException();
    }
    return products.map((product) => ProductModel.fromDrift({
      'id': product.id,
      'name': product.name,
      'description': product.description,
      'price': product.price,
      'stock': product.stock,
      'category': product.category,
      'imageUrl': product.imageUrl,
      'sellerId': product.sellerId,
      'active': product.active,
      'available': product.available,
      'createdAt': product.createdAt?.toIso8601String(),
    })).toList();
  }
  @override
  Future<void> clearCache() async {
    await database.delete(database.products).go();
  }
}
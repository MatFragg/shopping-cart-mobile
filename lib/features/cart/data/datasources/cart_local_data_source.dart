import 'package:drift/drift.dart';
import 'package:shopping_cart/core/database/app_database.dart';
import 'package:shopping_cart/core/error/exceptions.dart';
import 'package:shopping_cart/features/cart/data/models/cart_item_model.dart';
import 'package:shopping_cart/features/cart/data/models/cart_model.dart';

abstract class CartLocalDataSource {
  Future<CartModel?> getCachedCart();
  Future<void> cacheCart(CartModel cart);
  Future<void> clearCart();

  Future<void> addCartItem(CartItemModel item);
  Future<void> updateCartItem(CartItemModel item);
  Future<void> removeCartItem(String productId);
  Future<List<CartItemModel>> getCachedCartItems();
}

class CartLocalDataSourceImpl implements CartLocalDataSource {
  final AppDatabase database;

  CartLocalDataSourceImpl({required this.database});

  @override
  Future<void> cacheCart(CartModel cart) async {
    try {
      await database.into(database.cart).insert(
        CartCompanion(
          id: Value(cart.id),
          customerId: Value(cart.customerId),
          status: Value(cart.status),
          total: Value(cart.total),
        ),
        mode: InsertMode.replace,
      );
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> clearCart() async {
    try {
      await database.transaction(() async {
        await database.delete(database.cartItems).go();
        await database.delete(database.cart).go();
      });
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<CartModel?> getCachedCart() async {
    try {
      final result = await (database.select(database.cart)
        ..where((tbl) => tbl.status.equals('ACTIVE'))
        ..limit(1))
          .getSingleOrNull();

      if (result == null) return null;
      return CartModel.fromDrift(result.toJson());
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> addCartItem(CartItemModel item) async {
    try {
      await database.into(database.cartItems).insert(
        CartItemsCompanion(
          id: Value(item.id),
          cartId: Value(item.cartId),
          productId: Value(item.productId),
          sellerId: Value(item.sellerId),
          productName: Value(item.productName),
          quantity: Value(item.quantity),
          unitPrice: Value(item.unitPrice),
          subtotal: Value(item.subtotal),
        ),
        mode: InsertMode.replace,
      );
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> updateCartItem(CartItemModel item) async {
    try {
      await (database.update(database.cartItems)
        ..where((tbl) => tbl.id.equals(item.id)))
          .write(CartItemsCompanion(
        quantity: Value(item.quantity),
        unitPrice: Value(item.unitPrice),
        subtotal: Value(item.subtotal),
      ));
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> removeCartItem(String productId) async {
    try {
      await (database.delete(database.cartItems)
        ..where((tbl) => tbl.productId.equals(productId)))
          .go();
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<List<CartItemModel>> getCachedCartItems() async {
    try {
      final results = await database.select(database.cartItems).get();
      return results.map((row) =>
          CartItemModel.fromDrift(row.toJson())
      ).toList();
    } catch (e) {
      throw CacheException();
    }
  }
}
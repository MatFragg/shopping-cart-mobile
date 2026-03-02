import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift_sqflite/drift_sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

part 'app_database.g.dart';

class Users extends Table {
  TextColumn get id => text()();
  TextColumn get username => text()();
  TextColumn get email => text()();
  TextColumn get roles => text()(); // CSV: "ROLE_USER,ROLE_ADMIN"
  TextColumn get customerId => text().nullable()();
  TextColumn get firstName => text()();
  TextColumn get lastName => text()();
  TextColumn get phone => text()();
  TextColumn get shippingAddress => text()();
  DateTimeColumn get createdAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Products extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text()();
  RealColumn get price => real()();
  IntColumn get stock => integer()();
  TextColumn get category => text()();
  TextColumn get imageUrl => text().nullable()();
  TextColumn get sellerId => text()();
  BoolColumn get active => boolean()();
  BoolColumn get available => boolean()();
  DateTimeColumn get createdAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Cart extends Table {
  TextColumn get id => text()();
  TextColumn get customerId => text()();
  TextColumn get status => text()();
  RealColumn get total => real()();

  @override
  Set<Column> get primaryKey => {id};
}

class CartItems extends Table {
  TextColumn get id => text()();
  TextColumn get cartId => text()();
  TextColumn get productId => text()();
  TextColumn get sellerId => text()();
  TextColumn get productName => text()();
  IntColumn get quantity => integer()();
  RealColumn get unitPrice => real()();
  RealColumn get subtotal => real()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Users, Products, Cart, CartItems])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3; // Incrementado por agregar Products

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {
        // Migración para agregar Products si vienes de v1
        await m.create(products);
        await m.createTable(cart);
        await m.createTable(cartItems);
      }
    },
  );

  static QueryExecutor _openConnection() {
    return SqfliteQueryExecutor(
      path: p.join(getDatabasesPath().toString(), 'shopping_cart.db'),
      singleInstance: true,
    );
  }
}
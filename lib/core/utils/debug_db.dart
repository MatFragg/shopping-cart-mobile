import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

Future<void> debugDb([String dbName = 'app.db']) async {
  final databasesPath = await getDatabasesPath();
  final dbPath = p.join(databasesPath, dbName);
  print('DB path: $dbPath');
  print('DB file exists: ${await File(dbPath).exists()}');
  final dir = Directory(databasesPath);
  print('Databases dir exists: ${await dir.exists()}');
  try {
    final list = await dir.list().toList();
    for (final f in list) {
      final stat = await f.stat();
      print(' - ${f.path} (size: ${stat.size})');
    }
    final db = await openDatabase(dbPath);
    final tables = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table';");
    print('Tables: $tables');
    await db.close();
  } catch (e) {
    print('Error debugDb: $e');
  }
}

// Ejemplo: llamar desde lib/main.dart después de inicializar
// await debugDb('app.db');

// import 'dart:async';
// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';
//
// class DatabaseHelper {
//   Future<Database> initializeDB() async {
//     String path = join(await getDatabasesPath(), 'localDB.db');
//     return await openDatabase(
//       path,
//       version: 1,
//       onCreate: _createDb,
//     );
//   }
//
//   void _createDb(Database db, int newVersion) async {
//     await db.execute('''
//       CREATE TABLE user (
//        id INTEGER PRIMARY KEY, username TEXT, email TEXT, phone TEXT, password TEXT
//       )
//     ''');
//   }
//
// //   Future<int> insertProduct(List<SaleProduct> products) async {
// //     int result = 0;
// //     Database db = await initializeDB();
// //     for (var product in products) {
// //       result = await db.insert('products', product.toMap(),
// //           conflictAlgorithm: ConflictAlgorithm.replace);
// //     }
// //
// //     return result;
// //     // return await db.insert('products', product.toMap());
// //   }
// //
// //   Future<List<SaleProduct>> getProducts() async {
// //     Database db = await initializeDB();
// //     List<Map<String, dynamic>> maps = await db.query('products');
// //     return List.generate(maps.length, (index) {
// //       return SaleProduct.fromMap(maps[index]);
// //     });
// //   }
// //
// //   Future<int> deleteAllProducts() async {
// //     Database db = await initializeDB();
// //     return await db.delete('products');
// //   }
// // }

// import 'dart:async';
// import 'package:path/path.dart';
// import 'package:pfa_app/models/user_model.dart';
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
//       CREATE TABLE users (
//        id INTEGER PRIMARY KEY, username TEXT, email TEXT, phone TEXT, password TEXT
//       )
//     ''');
//   }
//
//   // Future<int> registerUser(User user) async {
//   //   int result = 0;
//   //   Database db = await initializeDB();
//   //
//   //     result = await db.insert('users', user.toMap(),
//   //         conflictAlgorithm: ConflictAlgorithm.replace);
//   //   }
//   //
//   //   return result;
//   //   // return await db.insert('products', product.toMap());
//   // }
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

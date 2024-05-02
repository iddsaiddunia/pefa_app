// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';
//
// class User {
//   final int id;
//   final String username;
//   final String email;
//   final String phone;
//   final String password;
//
//   User({ required this.id, required this.username, required this.email, required this.phone, required this.password});
//
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'username': username,
//       'email': email,
//       'phone': phone,
//       'password': password,
//     };
//   }
// }
//
// // Database Helper Class
// class DatabaseHelper {
//   final String tableName = 'users';
//
//   Future<Database> database() async {
//     return openDatabase(
//       join(await getDatabasesPath(), 'user_database.db'),
//       onCreate: (db, version) {
//         return db.execute(
//           "CREATE TABLE $tableName(id INTEGER PRIMARY KEY, username TEXT, email TEXT, phone TEXT, password TEXT)",
//         );
//       },
//       version: 1,
//     );
//   }
// }
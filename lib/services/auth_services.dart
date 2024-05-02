// import 'package:sqflite/sqflite.dart';
//
// import '../models/user_model.dart';
//
// class AuthService{
//   Future<void> insertUser(User user) async {
//     final Database db = await database();
//     await db.insert(
//       'users',
//       user.toMap(),
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//   }
// }
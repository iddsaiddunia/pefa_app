import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class User {
  final int id;
  final String username;
  final String email;
  final String phone;
  final String password;

  User({ required this.id, required this.username, required this.email, required this.phone, required this.password});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'phone': phone,
      'password': password,
    };
  }
}

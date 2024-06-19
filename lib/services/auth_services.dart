import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decode/jwt_decode.dart';
import 'package:pfa_app/services/providers/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

UserProvider userProvider = UserProvider();

class AuthService {
  var _baseUrl = "https://pefa-432220d0c209.herokuapp.com";

  Future<String?> login(String email, String password) async {
    final String loginUrl =
        'https://pefa-432220d0c209.herokuapp.com/auth/jwt/create';
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/jwt/create'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final String token = jsonDecode(response.body)['access'];
        await _saveToken(token);
        await fetchUserDetails(token);
        return token;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, dynamic>?> signup(String username, String email,
      String phoneNumber, String password) async {
    final String signupUrl =
        'https://pefa-432220d0c209.herokuapp.com/auth/signup/';
    try {
      final response = await http.post(
        Uri.parse(signupUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': username,
          'email': email,
          'phone_number': phoneNumber,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        var data = jsonDecode(response.body);
        return {'success': true, 'data': data};
      } else {
        var errorData = jsonDecode(response.body);
        return {'success': false, 'error': errorData};
      }
    } catch (e) {
      // print('Error during signup: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> fetchUserDetails(String token) async {
    // Decode the JWT token to extract the user ID
    final userId = _extractUserIdFromToken(token);

    if (userId != null) {
      final response = await http.get(
        Uri.parse('$_baseUrl/auth/users/$userId/'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final userDetails = jsonDecode(response.body);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('userId', userDetails['id'] as int);
        userProvider.setUserId(userDetails['id'] as int);
        return userDetails;
      } else {
        print(
          'Failed to fetch user details with status code: ${response.statusCode}',
        );
        return null;
      }
    } else {
      print('Failed to extract user ID from token');
      return null;
    }
  }

  int? _extractUserIdFromToken(String token) {
    try {
      print(token);
      final Map<String, dynamic> decodedToken = Jwt.parseJwt(token);
      return decodedToken['user_id'];
    } catch (e) {
      print('Failed to decode token: $e');
      return null;
    }
  }

  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }
}

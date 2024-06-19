// lib/services/budget_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pfa_app/models/budget_model.dart';
import 'package:pfa_app/services/auth_services.dart';

AuthService _authService = AuthService();

class BudgetService {
  static const String baseUrl =
      'https://pefa-432220d0c209.herokuapp.com/budgets/';

  static Future<List<Budget>> fetchBudgets() async {
    String? token = await _authService.getToken();
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((budget) => Budget.fromJson(budget)).toList();
    } else {
      throw Exception('Failed to load budgets');
    }
  }

  static Future<Budget> getBudgetById(int id) async {
    String? token = await _authService.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl$id/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return Budget.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load budget');
    }
  }

  static Future<Budget> createBudget(Budget budget) async {
    String? token = await _authService.getToken();
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(budget.toJson()),
    );

    if (response.statusCode == 201) {
      return Budget.fromJson(json.decode(response.body));
    } else if (response.statusCode == 400) {
      // Handle validation errors, such as duplicate categories
      Map<String, dynamic> errorResponse = json.decode(response.body);
      if (errorResponse.containsKey('non_field_errors')) {
        throw Exception(errorResponse['non_field_errors'][0]);
      } else {
        throw Exception('Failed to create budget');
      }
    } else {
      throw Exception('Failed to create budget');
    }
  }

  static Future<Budget> updateBudget(int id, Budget budget) async {
    String? token = await _authService.getToken();
    final response = await http.put(
      Uri.parse('$baseUrl$id/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(budget.toJson()),
    );

    if (response.statusCode == 200) {
      return Budget.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update budget');
    }
  }

  static Future<void> deleteBudget(int id) async {
    String? token = await _authService.getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl$id/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete budget');
    }
  }
}

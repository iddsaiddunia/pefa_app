// saving_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pfa_app/models/saving_model.dart';
import 'package:pfa_app/services/auth_services.dart';
// Import your AuthService

AuthService _authService = AuthService();

class SavingService {
  static const String baseUrl =
      'https://pefa-432220d0c209.herokuapp.com/savings/';

  static Future<List<Saving>> getSavings() async {
    String? token = await _authService.getToken();
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {"Authorization": "Bearer $token"},
    );
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => Saving.fromJson(model)).toList();
    } else {
      throw Exception('Failed to load savings');
    }
  }

  static Future<Saving> createSaving(Saving saving) async {
    String? token = await _authService.getToken();
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: json.encode(saving.toJson()),
    );
    if (response.statusCode == 201) {
      return Saving.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create saving');
    }
  }

  static Future<Saving> updateSaving(Saving saving) async {
    String? token = await _authService.getToken();
    final response = await http.put(
      Uri.parse('${baseUrl}${saving.id}/'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: json.encode(saving.toJson()),
    );
    if (response.statusCode == 200) {
      return Saving.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update saving');
    }
  }

  static Future<void> deleteSaving(int id) async {
    String? token = await _authService.getToken();
    final response = await http.delete(
      Uri.parse('${baseUrl}${id}/'),
      headers: {"Authorization": "Bearer $token"},
    );
    if (response.statusCode != 204) {
      throw Exception('Failed to delete saving');
    }
  }

  static Future<double> getTotalAmountForUser(int userId) async {
    // print("USerId ---------->$userId");
    String? token = await _authService.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl?user=$userId'),
      headers: {"Authorization": "Bearer $token"},
    );
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      List<Saving> savings =
          list.map((model) => Saving.fromJson(model)).toList();
      double totalAmount = savings.fold(0.0, (sum, item) => sum + item.amount);
      // print("total amount------------>$totalAmount");
      return totalAmount;
    } else {
      throw Exception('Failed to load savings');
    }
  }
}

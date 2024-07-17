import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:pfa_app/models/loan_model.dart';
import 'package:pfa_app/services/auth_services.dart';

AuthService _authService = AuthService();

class LoanService {
  static const String baseUrl = 'https://pefa-432220d0c209.herokuapp.com';

  static Future<List<Loan>> getLoans() async {
    String? token = await _authService.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/loans/'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      List<Loan> loans = data.map((item) => Loan.fromJson(item)).toList();

      return loans;
    } else {
      throw Exception('Failed to load loans');
    }
  }

  Future<Map<String, dynamic>?> createLoan(
      String token, Map<String, dynamic> loanData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/loans/'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(loanData),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      var errorData = jsonDecode(response.body);
      return {'error': errorData};
    }
  }

  Future<void> updateLoan(
      String token, int loanId, Map<String, dynamic> updatedData) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$loanId/'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(updatedData),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update loan');
    }
  }

  Future<void> deleteLoan(int loanId) async {
    String? token = await _authService.getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/loans/$loanId/'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete loan');
    }
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pfa_app/models/transaction_model.dart';
import 'package:pfa_app/services/auth_services.dart';


AuthService _authService = AuthService();
class TransactionService {
  final String baseUrl = 'https://pefa-432220d0c209.herokuapp.com';


  Future<List<Transaction>> getTransactions() async {
    String? token = await _authService.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/transactions/'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((transaction) => Transaction.fromJson(transaction)).toList();
    } else {
      throw Exception('Failed to load transactions');
    }
  }

  Future<Map<String, dynamic>?> createTransaction(Map<String, dynamic> transaction) async {
    String? token = await _authService.getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/transactions/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(transaction),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      var errorData = jsonDecode(response.body);
      return {'error': errorData};
    }
  }

  Future<Transaction> updateTransaction(Transaction transaction) async {
    String? token = await _authService.getToken();
    final response = await http.put(
      Uri.parse('$baseUrl/transactions/${transaction.id}/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(transaction.toJson()),
    );

    if (response.statusCode == 200) {
      return Transaction.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update transaction');
    }
  }

  Future<void> deleteTransaction(int id) async {
    String? token = await _authService.getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/transactions/$id/'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete transaction');
    }
  }
}

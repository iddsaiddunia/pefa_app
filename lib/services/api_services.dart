import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pfa_app/models/target_model.dart';
import 'package:pfa_app/services/auth_services.dart';
import 'package:pfa_app/services/providers/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

AuthService _authService = AuthService();

class ApiService {
  static const String baseUrl =
      'https://pefa-432220d0c209.herokuapp.com'; // Replace with your API URL

  static Future<List<Target>> getTargets() async {

    String? token = await _authService.getToken();

    final response = await http.get(
      Uri.parse('https://pefa-432220d0c209.herokuapp.com/targets/'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => Target.fromJson(model)).toList();
    } else {
      throw Exception('Failed to load targets');
    }
  }

  static Future<Target> getTargetById(int id) async {
    String? token = await _authService.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/targets/$id/'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return Target.fromJson(json.decode(response.body));
    } else {
      print('Failed to load target: ${response.statusCode} ${response.body}');
      throw Exception('Failed to load target');
    }
  }

  Future<Map<String, dynamic>?> createTarget(
      Map<String, dynamic> targetData) async {
    String? token = await _authService.getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/targets/'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(targetData),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      var errorData = jsonDecode(response.body);
      return {'error': errorData};
    }
  }

  static Future<Target> updateTarget(int id, Target target) async {
    String? token = await _authService.getToken();
    final response = await http.put(
      Uri.parse('$baseUrl/targets/$id/'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(target.toJson()),
    );

    if (response.statusCode == 200) {
      return Target.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update target');
    }
  }

  Future<void> deleteTarget(int id) async {
    String? token = await _authService.getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/targets/$id/'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete target');
    }
  }

  Future<void> updateTargetStatus(int id, String status) async {
    String? token = await _authService.getToken();
    final response = await http.patch(
      Uri.parse('$baseUrl/targets/$id/'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({'target_status': status}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update target status');
    }
  }

  Future<void> checkAndUpdateTargetsStatus() async {
    try {
      List<Target> targets = await getTargets();

      for (var target in targets) {
        String status = 'onprogress';
        DateTime now = DateTime.now();

        if (target.amountSaved >= target.targetedAmount && now.isBefore(target.targetDate)) {
          status = 'completed';
        } else if (now.isAfter(target.targetDate) && target.amountSaved < target.targetedAmount) {
          status = 'failed';
        }

        if (target.targetStatus != status) {
          await updateTargetStatus(target.id, status);
        }
      }
    } catch (e) {
      print('Error updating targets status: $e');
    }
  }
}

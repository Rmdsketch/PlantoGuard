import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class ApiService {
  static const String baseUrl = "http://127.0.0.1:5000";
  static const Map<String, String> jsonHeader = {
    "Content-Type": "application/json"
  };

  // ========================
  // HTTP METHOD HELPERS
  // ========================

  static Future<Map<String, dynamic>> _post(String path, Map data) async {
    final url = Uri.parse("$baseUrl$path");
    try {
      final response = await http
          .post(url, headers: jsonHeader, body: jsonEncode(data))
          .timeout(const Duration(seconds: 10));
      return _handleResponse(response, path);
    } catch (e) {
      print("POST $path error: $e");
      return {"success": false, "message": "Unexpected error"};
    }
  }

  static Future<Map<String, dynamic>> _get(String path, String token) async {
    final url = Uri.parse("$baseUrl$path");
    try {
      final response = await http.get(url, headers: {
        ...jsonHeader,
        "Authorization": "Bearer $token"
      }).timeout(const Duration(seconds: 10));
      return _handleResponse(response, path);
    } catch (e) {
      print("GET $path error: $e");
      return {"success": false, "message": "Unexpected error"};
    }
  }

  static Future<Map<String, dynamic>> _put(
      String path, Map data, String token) async {
    final url = Uri.parse("$baseUrl$path");
    try {
      final response = await http
          .put(
            url,
            headers: {
              ...jsonHeader,
              "Authorization": "Bearer $token",
            },
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 10));
      return _handleResponse(response, path);
    } catch (e) {
      print("PUT $path error: $e");
      return {"success": false, "message": "Unexpected error"};
    }
  }

  static Future<Map<String, dynamic>> _delete(String path, String token) async {
    final url = Uri.parse("$baseUrl$path");
    try {
      final response = await http.delete(url, headers: {
        ...jsonHeader,
        "Authorization": "Bearer $token",
      }).timeout(const Duration(seconds: 10));
      return _handleResponse(response, path);
    } catch (e) {
      print("DELETE $path error: $e");
      return {"success": false, "message": "Unexpected error"};
    }
  }

  static Map<String, dynamic> _handleResponse(
      http.Response response, String path) {
    try {
      if (response.statusCode == 204) {
        return {"success": true, "message": "No Content"};
      }

      final decoded = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {"success": true, ...decoded};
      } else {
        print(
            "Request to $path failed (${response.statusCode}): ${response.body}");
        return {"success": false, ...decoded};
      }
    } catch (_) {
      print("Invalid response from $path: ${response.body}");
      return {"success": false, "message": "Invalid server response"};
    }
  }

  // ========================
  // AUTH & USER FUNCTIONS
  // ========================

  static Future<Map<String, dynamic>> registerUser({
    required String email,
    required String fullName,
    required String password,
  }) async {
    return await _post("/users", {
      "email": email,
      "full_name": fullName,
      "password": password,
    });
  }

  static Future<Map<String, dynamic>?> loginUser({
    required String email,
    required String password,
  }) async {
    final response = await _post("/auth/login", {
      "email": email,
      "password": password,
    });

    if (response.containsKey('message') &&
        response['message'] == 'Login successful') {
      return response;
    }

    return null;
  }

  static Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    return await _post("/reset-password", {
      "email": email,
      "new_password": newPassword,
    });
  }

  static Future<Map<String, dynamic>> getUserById(
      int userId, String token) async {
    return await _get("/users/$userId", token);
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  // ========================
  // DISEASE FUNCTIONS
  // ========================

  static Future<List<Map<String, dynamic>>> getDiseases(String token) async {
    final response = await _get("/disease", token);

    if (response["success"] == true && response["data"] is List) {
      return List<Map<String, dynamic>>.from(response["data"]);
    }

    return [];
  }

  static Future<Map<String, dynamic>> createDisease({
    required Map<String, dynamic> data,
    required String token,
  }) async {
    return await _post("/disease", data);
  }

  static Future<Map<String, dynamic>> updateDisease({
    required int id,
    required Map<String, dynamic> updatedData,
    required String token,
  }) async {
    return await _put("/disease/id/$id", updatedData, token);
  }

  static Future<Map<String, dynamic>> deleteDisease(
      int id, String token) async {
    return await _delete("/disease/id/$id", token);
  }
}
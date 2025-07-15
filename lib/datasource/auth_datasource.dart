import 'dart:convert';

import 'package:manajemen_keuangan/constants/api_constants.dart';
import 'package:http/http.dart' as http;
import 'package:manajemen_keuangan/models/response_model_auth.dart';

class AuthDatasource {
  Future<ResponseModelAuth?> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('${ApiConstants.baseUrl}/register');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({"name": name, "email": email, "password": password}),
      );
      if (response.statusCode == 201) {
        return ResponseModelAuth.fromRawJson(response.body);
      } else {
        // Return empty object, can be checked by accessToken == null
        return ResponseModelAuth(
          accessToken: null,
          tokenType: null,
          user: null,
        );
      }
    } catch (e) {
      // Return empty object, can be checked by accessToken == null
      return ResponseModelAuth(accessToken: null, tokenType: null, user: null);
    }
  }

  Future<ResponseModelAuth?> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('${ApiConstants.baseUrl}/login');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({"email": email, "password": password}),
      );
      if (response.statusCode == 200) {
        return ResponseModelAuth.fromRawJson(response.body);
      } else {
        // Return empty object, can be checked by accessToken == null
        return ResponseModelAuth(
          accessToken: null,
          tokenType: null,
          user: null,
        );
      }
    } catch (e) {
      // Return empty object, can be checked by accessToken == null
      return ResponseModelAuth(accessToken: null, tokenType: null, user: null);
    }
  }
}

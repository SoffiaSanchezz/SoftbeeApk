import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sotfbee/core/config/api_config.dart';
import 'package:sotfbee/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:sotfbee/features/auth/data/models/user_model.dart';

class AuthService {
  static final String _baseUrl = ApiConfig.baseUrl;
  static final Duration _timeout = ApiConfig.timeout;

  static Future<Map<String, dynamic>> login(
    String identifier,
    String password,
  ) async {
    final response = await http
        .post(
          Uri.parse('$_baseUrl/login'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'email': identifier,
            'password': password,
          }),
        )
        .timeout(_timeout);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return {'success': true, 'token': data['token']};
    } else {
      final error = json.decode(response.body);
      return {'success': false, 'message': error['message']};
    }
  }

  static Future<Map<String, dynamic>> requestPasswordReset(String email) async {
    final response = await http
        .post(
          Uri.parse('$_baseUrl/reset-password'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'email': email}),
        )
        .timeout(_timeout);
    if (response.statusCode == 200) {
      return {'success': true, 'message': 'Password reset link sent'};
    } else {
      final error = json.decode(response.body);
      return {'success': false, 'message': error['message']};
    }
  }

  static Future<Map<String, dynamic>> resetPassword(
    String token,
    String newPassword,
  ) async {
    final response = await http
        .post(
          Uri.parse('$_baseUrl/reset-password/$token'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'password': newPassword}),
        )
        .timeout(_timeout);
    if (response.statusCode == 200) {
      return {'success': true, 'message': 'Password reset successful'};
    } else {
      final error = json.decode(response.body);
      return {'success': false, 'message': error['message']};
    }
  }

    static String generateUsername(String email) {
    if (email.isEmpty || !email.contains('@')) {
      return '';
    }
    final username = email.split('@').first;
    return username.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
  }

  static Future<UserProfile?> getUserProfile(String token) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/users/me'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).timeout(_timeout);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return UserProfile.fromJson(data);
    } else {
      return null;
    }
  }
}

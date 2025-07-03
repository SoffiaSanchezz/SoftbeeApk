import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sotfbee/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:sotfbee/features/admin/reports/model/api_models.dart';

class ReportsService {
  static const String _baseUrl = 'https://softbee-back-end.onrender.com/api';

  static Future<Map<String, String>> get _headers async {
    final token = await AuthStorage.getToken();
    if (token == null || token.isEmpty) {
      throw Exception('Token no encontrado');
    }
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  static Future<List<Monitoreo>> getMonitoringReports() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/reports/monitoring'),
        headers: await _headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Monitoreo.fromJson(json)).toList();
      } else {
        throw Exception('Error al obtener reportes: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}

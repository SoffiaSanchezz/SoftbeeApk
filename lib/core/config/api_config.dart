import 'package:flutter/foundation.dart';

class ApiConfig {
  // ------------------- PARA DESARROLLO LOCAL -------------------
  // 1. Reemplaza esta IP con la dirección IP de tu computadora.
  //    - En Windows, abre CMD y escribe "ipconfig". Busca la "Dirección IPv4".
  //    - En macOS/Linux, abre la terminal y escribe "ifconfig" o "ip addr".
  static const String _localIp = '127.0.0.1'; 

  // 2. URL para desarrollo local (usa la IP de arriba).
  static const String _localBaseUrl = 'http://$_localIp:5000/api';

  // ------------------- PARA PRODUCCIÓN -------------------
  // URL del backend cuando la app está en producción.
  static const String _productionBaseUrl = 'https://softbee-back-end.onrender.com/api';

  // ------------------- URL SELECCIONADA -------------------
  // Esto selecciona automáticamente la URL correcta.
  static final String baseUrl = kDebugMode ? _localBaseUrl : _productionBaseUrl;

  // ------------------- TIMEOUT -------------------
  static const Duration timeout = Duration(seconds: 30);
}

import 'dart:convert';

// Modelo para Apiario
class Apiario {
  final int id;
  final int userId;
  final String name;
  final String? location;
  final DateTime createdAt;
  final DateTime updatedAt;
  List<Colmena>? colmenas;
  List<Monitoreo>? monitoreos;

  Apiario({
    required this.id,
    required this.userId,
    required this.name,
    this.location,
    required this.createdAt,
    required this.updatedAt,
    this.colmenas,
    this.monitoreos,
  });

  factory Apiario.fromJson(Map<String, dynamic> json) {
    return Apiario(
      id: json['id'] as int? ?? 0,
      userId: json['user_id'] as int? ?? 0,
      name: json['name']?.toString() ?? '',
      location: json['location']?.toString(),
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'location': location,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

// Modelo para Colmena
class Colmena {
  final int id;
  final int apiarioId;
  final String numeroColmena;
  final String? estado;
  final DateTime? ultimaInspeccion;
  final double? productividad;
  final String? notas;

  Colmena({
    required this.id,
    required this.apiarioId,
    required this.numeroColmena,
    this.estado,
    this.ultimaInspeccion,
    this.productividad,
    this.notas,
  });

  factory Colmena.fromJson(Map<String, dynamic> json) {
    return Colmena(
      id: json['id'] as int? ?? 0,
      apiarioId: json['apiario_id'] as int? ?? 0,
      numeroColmena: json['numero_colmena']?.toString() ?? '',
      estado: json['estado']?.toString(),
      ultimaInspeccion: json['ultima_inspeccion'] != null
          ? DateTime.tryParse(json['ultima_inspeccion'].toString())
          : null,
      productividad: (json['productividad'] as num?)?.toDouble(),
      notas: json['notas']?.toString(),
    );
  }
}

// Modelo para Monitoreo
class Monitoreo {
  final int monitoreoId;
  final int colmenaId;
  final int apiarioId;
  final DateTime fecha;
  final List<RespuestaMonitoreo> respuestas;
  final String? apiarioNombre;
  final String? hiveNumber;
  final bool sincronizado;

  Monitoreo({
    required this.monitoreoId,
    required this.colmenaId,
    required this.apiarioId,
    required this.fecha,
    required this.respuestas,
    this.apiarioNombre,
    this.hiveNumber,
    required this.sincronizado,
  });

  factory Monitoreo.fromJson(Map<String, dynamic> json) {
    List<RespuestaMonitoreo> respuestas = [];
    if (json['respuestas'] is List) {
      respuestas = (json['respuestas'] as List)
          .map((r) => RespuestaMonitoreo.fromJson(r as Map<String, dynamic>))
          .toList();
    }

    return Monitoreo(
      monitoreoId: json['monitoreo_id'] as int? ?? 0,
      colmenaId: json['colmena_id'] as int? ?? 0,
      apiarioId: json['apiario_id'] as int? ?? 0,
      fecha: DateTime.tryParse(json['fecha']?.toString() ?? '') ?? DateTime.now(),
      respuestas: respuestas,
      apiarioNombre: json['apiario_nombre']?.toString(),
      hiveNumber: json['hive_number']?.toString(),
      sincronizado: json['sincronizado'] as bool? ?? false,
    );
  }
}

// Modelo para Respuesta de Monitoreo
class RespuestaMonitoreo {
  final String preguntaTexto;
  final String? respuesta;
  final String tipoRespuesta;

  RespuestaMonitoreo({
    required this.preguntaTexto,
    this.respuesta,
    required this.tipoRespuesta,
  });

  factory RespuestaMonitoreo.fromJson(Map<String, dynamic> json) {
    return RespuestaMonitoreo(
      preguntaTexto: json['pregunta_texto']?.toString() ?? '',
      respuesta: json['respuesta']?.toString(),
      tipoRespuesta: json['tipo_respuesta']?.toString() ?? '',
    );
  }
}

// Modelo para Usuario
class Usuario {
  final int id;
  final String nombre;
  final String username;
  final String email;
  final String phone;
  final String? profilePicture;
  final List<Apiario>? apiarios;

  Usuario({
    required this.id,
    required this.nombre,
    required this.username,
    required this.email,
    required this.phone,
    this.profilePicture,
    this.apiarios,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    List<Apiario>? apiarios;
    if (json['apiaries'] is List) {
      apiarios = (json['apiaries'] as List)
          .map((a) => Apiario.fromJson(a as Map<String, dynamic>))
          .toList();
    }

    return Usuario(
      id: json['id'] as int? ?? 0,
      nombre: json['nombre']?.toString() ?? '',
      username: json['username']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      profilePicture: json['profile_picture']?.toString(),
      apiarios: apiarios,
    );
  }
}

// Modelo para Estadísticas del Sistema
class SystemStats {
  final int totalApiarios;
  final int totalColmenas;
  final int totalMonitoreos;
  final int monitoreosUltimoMes;
  final List<MonitoreosPorApiario> monitoreosPorApiario;
  final DateTime timestamp;

  SystemStats({
    required this.totalApiarios,
    required this.totalColmenas,
    required this.totalMonitoreos,
    required this.monitoreosUltimoMes,
    required this.monitoreosPorApiario,
    required this.timestamp,
  });

  factory SystemStats.fromJson(Map<String, dynamic> json) {
    return SystemStats(
      totalApiarios: json['total_apiarios'] as int? ?? 0,
      totalColmenas: json['total_colmenas'] as int? ?? 0,
      totalMonitoreos: json['total_monitoreos'] as int? ?? 0,
      monitoreosUltimoMes: json['monitoreos_ultimo_mes'] as int? ?? 0,
      monitoreosPorApiario: (json['monitoreos_por_apiario'] as List? ?? [])
          .map((m) => MonitoreosPorApiario.fromJson(m as Map<String, dynamic>))
          .toList(),
      timestamp: DateTime.tryParse(json['timestamp']?.toString() ?? '') ?? DateTime.now(),
    );
  }
}

class MonitoreosPorApiario {
  final String apiario;
  final int total;

  MonitoreosPorApiario({required this.apiario, required this.total});

  factory MonitoreosPorApiario.fromJson(Map<String, dynamic> json) {
    return MonitoreosPorApiario(
      apiario: json['apiario']?.toString() ?? '',
      total: json['total'] as int? ?? 0,
    );
  }
}

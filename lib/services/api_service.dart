import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/usuario.dart';
import '../models/teacher.dart';

class ApiService {
  static const String baseUrl = 'https://backend-noesis-1.onrender.com';

  Future<List<Usuario>> fetchUsuarios() async {
    final response = await http.get(Uri.parse('$baseUrl/usuarios'));
    if (response.statusCode == 200) {
      List jsonData = json.decode(response.body);
      return jsonData.map((e) => Usuario.fromJson(e)).toList();
    } else {
      throw Exception('Error al cargar usuarios');
    }
  }

  // Registrar un nuevo usuario en el sistema
  Future<bool> registrarUsuario(String username, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/usuarios/registro'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'username': username,  // NUEVO CAMPO
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 400) {
      // Email ya existe
      throw Exception('El email ya está registrado');
    } else {
      throw Exception('Error al registrar usuario');
    }
  }

  // Obtener el mejor puntaje de un usuario específico
  static Future<Map<String, dynamic>> getBestScore(String email) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/usuarios/$email/puntajes'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'success': true,
          'data': data
        };
      } else {
        return {
          'success': false,
          'message': 'Error al obtener puntajes'
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error de conexión: $e'
      };
    }
  }

// Actualizar el mejor puntaje del usuario
  static Future<Map<String, dynamic>> updateBestScore(
      String email,
      int puntajeObtenido,
      int puntajeTotal,
      String nivel
      ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/usuarios/$email/puntajes'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'puntaje_obtenido': puntajeObtenido,
          'puntaje_total': puntajeTotal,
          'nivel': nivel,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        final responseData = data is Map<String, dynamic> ? data : <String, dynamic>{};
        final innerData = responseData['data'] as Map<String, dynamic>? ?? <String, dynamic>{};

        return {
          'success': true,
          'data': {
            'message': responseData['message'] ?? 'Puntaje actualizado',
            'is_new_best': innerData['is_new_best'] ?? false,  // ← LEER DEL LUGAR CORRECTO
            'puntaje_obtenido': innerData['puntaje_obtenido'] ?? puntajeObtenido,
            'puntaje_total': innerData['puntaje_total'] ?? puntajeTotal,
            'nivel': innerData['nivel'] ?? nivel,
            'nivel_original': innerData['nivel_original'] ?? nivel,
            'ml_enhanced': innerData['ml_enhanced'] ?? false,
          }
        };
      } else {
        return {
          'success': false,
          'message': 'Error al actualizar puntaje'
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error de conexión: $e'
      };
    }
  }
  // Predecir nivel de inglés usando ML
  static Future<Map<String, dynamic>> predictEnglishLevel(
      int puntajeObtenido,
      int puntajeTotal
      ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/modelo/predict'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'puntaje_obtenido': puntajeObtenido,
          'puntaje_total': puntajeTotal,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'success': true,
          'data': data
        };
      } else {
        return {
          'success': false,
          'message': 'Error en la predicción del modelo'
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error de conexión: $e'
      };
    }
  }

  static Future<Map<String, dynamic>> predictUserEnglishLevel(String email) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/usuarios/$email/puntajes/modelo/predict'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'success': true,
          'data': data
        };
      } else {
        return {
          'success': false,
          'message': 'Error en la predicción del modelo para el usuario'
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error de conexión: $e'
      };
    }
  }

// Obtener estadísticas del modelo para el usuario
  static Future<Map<String, dynamic>> getUserModelStats(String email) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/usuarios/$email/puntajes/modelo/stats'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'success': true,
          'data': data
        };
      } else {
        return {
          'success': false,
          'message': 'Error obteniendo estadísticas del usuario'
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error de conexión: $e'
      };
    }
  }
  // Actualizar perfil del usuario
  static Future<Map<String, dynamic>> updateUserProfile(
      String currentEmail,
      String newUsername
      ) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/usuarios/$currentEmail/perfil'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': newUsername,
          'email': currentEmail,  // Mantener el email igual
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'success': true,
          'data': data
        };
      } else if (response.statusCode == 400) {
        final data = json.decode(response.body);
        return {
          'success': false,
          'message': data['detail'] ?? 'Error al actualizar perfil'
        };
      } else if (response.statusCode == 422) {
        return {
          'success': false,
          'message': 'Datos inválidos. Verifica username y email.'
        };
      } else {
        return {
          'success': false,
          'message': 'Error al actualizar perfil'
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error de conexión: $e'
      };
    }
  }

// Cambiar contraseña del usuario
  static Future<Map<String, dynamic>> changeUserPassword(
      String email,
      String newPassword
      ) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/usuarios/$email/password'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'new_password': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Contraseña actualizada correctamente'
        };
      } else if (response.statusCode == 400) {
        final data = json.decode(response.body);
        return {
          'success': false,
          'message': data['message'] ?? 'Error al cambiar contraseña'
        };
      } else {
        return {
          'success': false,
          'message': 'Error al cambiar contraseña'
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error de conexión: $e'
      };
    }
  }

// Eliminar cuenta del usuario
  static Future<Map<String, dynamic>> deleteUserAccount(String email) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/usuarios/$email'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Cuenta eliminada correctamente'
        };
      } else if (response.statusCode == 404) {
        return {
          'success': false,
          'message': 'Usuario no encontrado'
        };
      } else {
        return {
          'success': false,
          'message': 'Error al eliminar cuenta'
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error de conexión: $e'
      };
    }
  }

  // Obtener lista de docentes
  Future<List<Teacher>> fetchTeachers() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/docentes'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        List jsonData = json.decode(response.body);
        return jsonData.map((e) => Teacher.fromJson(e)).toList();
      } else {
        throw Exception('Error al cargar docentes: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

// Registrar un nuevo docente
  Future<Map<String, dynamic>> registrarDocente(String username, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/docentes/registro'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': username,
          'email': email,
          'password': password,
          'institucion': 'CCJCALLAO',
        }),
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Docente registrado exitosamente'
        };
      } else if (response.statusCode == 400) {
        final errorData = json.decode(response.body);
        return {
          'success': false,
          'message': errorData['detail'] ?? 'Error al registrar docente'
        };
      } else {
        return {
          'success': false,
          'message': 'Error del servidor: ${response.statusCode}'
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error de conexión: $e'
      };
    }
  }

// Login de docente
  Future<Map<String, dynamic>> loginDocente(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/docentes/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Login exitoso'
        };
      } else if (response.statusCode == 404) {
        return {
          'success': false,
          'message': 'Docente no encontrado'
        };
      } else if (response.statusCode == 401) {
        return {
          'success': false,
          'message': 'Contraseña incorrecta'
        };
      } else {
        return {
          'success': false,
          'message': 'Error del servidor: ${response.statusCode}'
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error de conexión: $e'
      };
    }
  }

// Obtener información de docente
  Future<Teacher?> getTeacherInfo(String email) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/docentes/$email'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Teacher.fromJson({
          'username': data['username'],
          'email': data['email'],
          'password': '', // No se devuelve la contraseña
          'institucion': data['institucion'],
        });
      } else {
        return null;
      }
    } catch (e) {
      print('Error obteniendo info de docente: $e');
      return null;
    }
  }

  // Obtener estadísticas generales de estudiantes
  static Future<Map<String, dynamic>> getStudentsStats() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/docentes/estadisticas/estudiantes'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'success': true,
          'data': data
        };
      } else {
        return {
          'success': false,
          'message': 'Error al obtener estadísticas'
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error de conexión: $e'
      };
    }
  }

// Obtener progreso detallado de estudiantes
  static Future<Map<String, dynamic>> getStudentsProgress() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/docentes/progreso/estudiantes'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'success': true,
          'data': data
        };
      } else {
        return {
          'success': false,
          'message': 'Error al obtener progreso'
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error de conexión: $e'
      };
    }
  }
}
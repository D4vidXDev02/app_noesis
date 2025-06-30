import 'package:flutter/material.dart';
import '../models/teacher.dart';
import '../services/api_service.dart';
import '../services/user_session_service.dart';

class TeacherLoginViewModel with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final UserSessionService _sessionService = UserSessionService();

  bool _isLoading = false;
  String email = '';
  String password = '';

  bool get isLoading => _isLoading;

  Future<Map<String, dynamic>> validateLogin() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Llamar al endpoint de login de docentes
      final result = await _apiService.loginDocente(email, password);

      if (result['success']) {
        // Obtener información adicional del docente
        final teacherInfo = await _apiService.getTeacherInfo(email);

        if (teacherInfo != null) {
          _sessionService.setCurrentTeacher(
              teacherInfo.email,
              teacherInfo.username,
              teacherInfo.institucion
          );
        } else {
          _sessionService.setCurrentUser(email, '', userType: 'teacher');
        }

        debugPrint("Login correcto para docente: $email");
      }

      _isLoading = false;
      notifyListeners();

      return result;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint("Error en login: $e");
      return {
        'success': false,
        'message': 'Error de conexión'
      };
    }
  }

  void logout() {
    _sessionService.logout();
    email = '';
    password = '';
    notifyListeners();
  }
}
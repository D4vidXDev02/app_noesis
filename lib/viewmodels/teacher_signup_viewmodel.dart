import 'package:flutter/material.dart';
import '../services/api_service.dart';

class TeacherSignupViewModel with ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool _isLoading = false;
  String username = '';
  String email = '';
  String password = '';

  bool get isLoading => _isLoading;

  Future<Map<String, dynamic>> registrarDocente() async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _apiService.registrarDocente(username, email, password);

      _isLoading = false;
      notifyListeners();

      if (result['success']) {
        debugPrint("Docente registrado exitosamente");
      } else {
        debugPrint("Error al registrar: ${result['message']}");
      }

      return result;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint("Error al registrar: $e");
      return {
        'success': false,
        'message': 'Error de conexión'
      };
    }
  }
}
import 'package:flutter/material.dart';
import '../services/user_session_service.dart';
import '../services/visits_service.dart';
import '../services/api_service.dart';

class ProfileViewModel with ChangeNotifier {
  final UserSessionService _sessionService = UserSessionService();

  // Datos del perfil (estos vendrán eventualmente de la API)
  String _nivel = "Intermedio";
  int _puntajeObtenido = 0;
  int _puntajeTotal = 20;
  String _claseMasRecurrida = "Ninguna clase visitada aún";
  bool _isLoadingMostVisited = false;
  bool _isLoadingScore = false;

  // Getters
  String? get username => _sessionService.currentUsername;
  String? get userEmail => _sessionService.currentUserEmail;
  String get nivel => _nivel;
  int get puntajeObtenido => _puntajeObtenido;
  int get puntajeTotal => _puntajeTotal;
  String get claseMasRecurrida => _claseMasRecurrida;
  bool get isLoggedIn => _sessionService.isLoggedIn;
  bool get isLoadingMostVisited => _isLoadingMostVisited;
  bool get isLoadingScore => _isLoadingScore;

  // Metodo para cargar datos del perfil
  Future<void> loadProfileData() async {
    if (!isLoggedIn) return;

    // Cargar la clase más visitada
    await _loadMostVisitedClass();

    // Cargar el mejor puntaje
    await loadBestScore();

    notifyListeners();
  }

  // Metodo privado para cargar la clase más visitada
  Future<void> _loadMostVisitedClass() async {
    if (!isLoggedIn || userEmail == null) return;

    _isLoadingMostVisited = true;
    notifyListeners();

    try {
      final mostVisitedId = await VisitsService.getMostVisitedClass(userEmail!);

      if (mostVisitedId != null) {
        // Mapear el ID a nombre legible
        _claseMasRecurrida = _getClassNameFromId(mostVisitedId);
      } else {
        _claseMasRecurrida = "Ninguna clase visitada aún";
      }
    } catch (e) {
      print('Error loading most visited class: $e');
      _claseMasRecurrida = "Error al cargar datos";
    } finally {
      _isLoadingMostVisited = false;
      notifyListeners();
    }
  }

  // Cargar el mejor puntaje del usuario
  Future<void> loadBestScore() async {
    if (!isLoggedIn || userEmail == null) return;

    _isLoadingScore = true;
    notifyListeners();

    try {
      final response = await ApiService.getBestScore(userEmail!);

      if (response['success']) {
        _puntajeObtenido = response['data']['puntaje_obtenido'] ?? 0;
        _puntajeTotal = response['data']['puntaje_total'] ?? 20;
        _nivel = response['data']['nivel'] ?? "Básico";
      }
    } catch (e) {
      print('Error loading best score: $e');
    } finally {
      _isLoadingScore = false;
      notifyListeners();
    }
  }

  // Actualizar el mejor puntaje
  Future<bool> updateBestScore(int correctAnswers, int totalQuestions) async {
    if (!isLoggedIn || userEmail == null) return false;

    try {
      final percentage = (correctAnswers / totalQuestions * 100).round();
      String newLevel = _calculateLevel(percentage);

      final response = await ApiService.updateBestScore(
          userEmail!,
          correctAnswers,
          totalQuestions,
          newLevel
      );

      if (response['success']) {
        final isNewBest = response['data']?['is_new_best'] ?? false;

        if (isNewBest || response['data']?['is_new_best'] == null) {
          _puntajeObtenido = correctAnswers;
          _puntajeTotal = totalQuestions;
          _nivel = newLevel;
          notifyListeners();
          return true;
        }
      }
    } catch (e) {
      print('Error updating best score: $e');
    }

    return false;
  }

  // Metodo privado para calcular el nivel basado en porcentaje
  String _calculateLevel(int percentage) {
    if (percentage >= 90) return "Avanzado";
    if (percentage >= 70) return "Intermedio";
    return "Básico";
  }

  // Metodo auxiliar para mapear IDs a nombres legibles
  String _getClassNameFromId(String classId) {
    switch (classId) {
      case 'verb_to_be':
        return 'Verb to be';
      case 'future_perfect':
        return 'Future Perfect';
      case 'present_simple':
        return 'Present Simple';
      case 'verb_can':
        return 'The Verb Can';
      default:
        return 'Clase desconocida';
    }
  }

  // Metodo para actualizar datos del perfil
  void updateProfileData({
    String? nivel,
    int? puntajeObtenido,
    int? puntajeTotal,
    String? claseMasRecurrida,
  }) {
    if (nivel != null) _nivel = nivel;
    if (puntajeObtenido != null) _puntajeObtenido = puntajeObtenido;
    if (puntajeTotal != null) _puntajeTotal = puntajeTotal;
    if (claseMasRecurrida != null) _claseMasRecurrida = claseMasRecurrida;

    notifyListeners();
  }

  // Metodo para cerrar sesión
  void logout() {
    _sessionService.logout();
    notifyListeners();
  }
}
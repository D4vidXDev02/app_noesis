import 'package:flutter/material.dart';
import '../services/user_session_service.dart';

class ProfileViewModel with ChangeNotifier {
  final UserSessionService _sessionService = UserSessionService();

  // Datos del perfil (estos vendrán eventualmente de la API)
  String _nivel = "Intermedio";
  int _puntajeObtenido = 12;
  int _puntajeTotal = 20;
  String _claseMasRecurrida = "Phrasal Verbs Avanzados";

  // Getters
  String? get username => _sessionService.currentUsername;
  String? get userEmail => _sessionService.currentUserEmail;
  String get nivel => _nivel;
  int get puntajeObtenido => _puntajeObtenido;
  int get puntajeTotal => _puntajeTotal;
  String get claseMasRecurrida => _claseMasRecurrida;
  bool get isLoggedIn => _sessionService.isLoggedIn;

  // Metodo para cargar datos del perfil (en proceso)
  Future<void> loadProfileData() async {
    if (!isLoggedIn) return;

    notifyListeners();
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
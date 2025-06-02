class UserSessionService {
  static final UserSessionService _instance = UserSessionService._internal();
  factory UserSessionService() => _instance;
  UserSessionService._internal();

  String? _currentUserEmail;
  String? _currentUsername;

  // Getters
  String? get currentUserEmail => _currentUserEmail;
  String? get currentUsername => _currentUsername;
  bool get isLoggedIn => _currentUserEmail != null;

  // Metodo estático para obtener el email del usuario actual
  static Future<String?> getCurrentUserEmail() async {
    return _instance._currentUserEmail;
  }

  // Metodo estático para obtener el username del usuario actual
  static Future<String?> getCurrentUsername() async {
    return _instance._currentUsername;
  }

  // Metodo estático para verificar si hay un usuario logueado
  static Future<bool> isUserLoggedIn() async {
    return _instance._currentUserEmail != null;
  }

  // Metodo para establecer el usuario logueado
  void setCurrentUser(String email) {
    _currentUserEmail = email;
    _currentUsername = _extractUsernameFromEmail(email);
  }

  // Metodo para cerrar sesión
  void logout() {
    _currentUserEmail = null;
    _currentUsername = null;
  }

  // Metodo estático para cerrar sesión
  static Future<void> logoutUser() async {
    _instance.logout();
  }

  // Extrae el username del email (parte antes del @)
  String _extractUsernameFromEmail(String email) {
    return email.split('@')[0];
  }
}
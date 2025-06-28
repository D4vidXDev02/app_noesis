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

  // Establecer el usuario logueado
  void setCurrentUser(String email, String username) {
    _currentUserEmail = email;
    _currentUsername = username;  // Ya no se extrae del email
  }

  // Metodo para cerrar sesión
  void logout() {
    _currentUserEmail = null;
    _currentUsername = null;
  }

  // Obtener el email del usuario actual
  static Future<String?> getCurrentUserEmail() async {
    return _instance._currentUserEmail;
  }

  // Obtener el username del usuario actual
  static Future<String?> getCurrentUsername() async {
    return _instance._currentUsername;
  }

  // Verificar si hay un usuario logueado
  static Future<bool> isUserLoggedIn() async {
    return _instance._currentUserEmail != null;
  }

  // Metodo estático para cerrar sesión
  static Future<void> logoutUser() async {
    _instance.logout();
  }
}
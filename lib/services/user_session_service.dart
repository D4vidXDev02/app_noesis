class UserSessionService {
  static final UserSessionService _instance = UserSessionService._internal();
  factory UserSessionService() => _instance;
  UserSessionService._internal();

  String? _currentUserEmail;
  String? _currentUsername;

  // Agregar estas propiedades a la clase:
  String? _currentUserType; // 'student' o 'teacher'
  String? _currentInstitution; // Para docentes


  // Getters
  String? get currentUserEmail => _currentUserEmail;
  String? get currentUsername => _currentUsername;
  String? get currentUserType => _currentUserType;
  String? get currentInstitution => _currentInstitution;

  bool get isLoggedIn => _currentUserEmail != null;
  bool get isStudent => _currentUserType == 'student';
  bool get isTeacher => _currentUserType == 'teacher';

  // Setter para estudiantes
  void setCurrentUser(String email, String username, {String userType = 'student'}) {
    _currentUserEmail = email;
    _currentUsername = username;
    _currentUserType = userType;
    _currentInstitution = null; // Solo para docentes
  }

  // Setter para docentes
  void setCurrentTeacher(String email, String username, String institution) {
    _currentUserEmail = email;
    _currentUsername = username;
    _currentUserType = 'teacher';
    _currentInstitution = institution;
  }

  // Metodo para cerrar sesión
  void logout() {
    _currentUserEmail = null;
    _currentUsername = null;
    _currentUserType = null;
    _currentInstitution = null;
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
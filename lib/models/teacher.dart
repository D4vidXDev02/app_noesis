class Teacher {
  final String username;
  final String email;
  final String password;
  final String institucion;

  // Constructor para inicializar un profesor
  Teacher({
    required this.username,
    required this.email,
    required this.password,
    required this.institucion,
  });

  // Metodo factory para crear un profesor a partir de un JSON
  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      institucion: json['institucion'] ?? 'CCJCALLAO',
    );
  }

  // Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'password': password,
      'institucion': institucion,
    };
  }
}
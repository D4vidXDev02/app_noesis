class Usuario {
  final String username;  // NUEVO CAMPO
  final String email;
  final String password;

  // Constructor actualizado
  Usuario({
    required this.username,  // NUEVO PARÁMETRO REQUERIDO
    required this.email,
    required this.password
  });

  // Factory method actualizado
  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      username: json['username'],  // NUEVO CAMPO DEL JSON
      email: json['email'],
      password: json['password'],
    );
  }
}
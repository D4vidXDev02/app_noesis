class Usuario {
  final String username;
  final String email;
  final String password;

  // Constructor actualizado
  Usuario({
    required this.username,
    required this.email,
    required this.password
  });

  // Factory method actualizado
  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      username: json['username'],
      email: json['email'],
      password: json['password'],
    );
  }
}
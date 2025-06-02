import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/usuario.dart';

class ApiService {
  Future<List<Usuario>> fetchUsuarios() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/usuarios'));
    if (response.statusCode == 200) {
      List jsonData = json.decode(response.body);
      return jsonData.map((e) => Usuario.fromJson(e)).toList();
    } else {
      throw Exception('Error al cargar usuarios');
    }
  }

  Future<bool> registrarUsuario(String email, String password) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/usuarios/registro'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 400) {
      // Email ya existe
      throw Exception('El email ya está registrado');
    } else {
      throw Exception('Error al registrar usuario');
    }
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/login_viewmodel.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controladores para los TextFields
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  // Variables para el mensaje de error
  String _emailErrorMessage = '';
  String _passwordErrorMessage = '';

  // Variable para la visibilidad de la contraseña
  bool _isPasswordVisible = false;

  // Instancia del ViewModel
  late LoginViewModel _loginViewModel;

  @override
  void initState() {
    super.initState();
    _loginViewModel = LoginViewModel();
  }

  // Función para validar el correo
  void _validateEmail() {
    String email = _emailController.text.trim();
    if (email.isNotEmpty && !email.endsWith('@gmail.com')) {
      setState(() {
        _emailErrorMessage = 'Ingrese un correo Gmail';
      });
    } else if (email.isEmpty) {
      setState(() {
        _emailErrorMessage = 'Ingrese su correo electrónico';
      });
    } else {
      setState(() {
        _emailErrorMessage = '';
      });
    }
  }

  // Función para validar la contraseña
  void _validatePassword() {
    String password = _passwordController.text.trim();
    if (password.isEmpty) {
      setState(() {
        _passwordErrorMessage = 'Ingrese una contraseña';
      });
    } else if (password.length < 4) {
      setState(() {
        _passwordErrorMessage = 'La contraseña debe tener al menos 4 caracteres';
      });
    } else {
      setState(() {
        _passwordErrorMessage = '';
      });
    }
  }

  // Función para manejar el login
  Future<void> _handleLogin() async {
    // Validar campos antes de proceder
    _validateEmail();
    _validatePassword();

    // Si hay errores, no proceder
    if (_emailErrorMessage.isNotEmpty || _passwordErrorMessage.isNotEmpty) {
      return;
    }

    // Actualizar los valores en el ViewModel
    _loginViewModel.email = _emailController.text.trim();
    _loginViewModel.password = _passwordController.text.trim();

    try {
      // Intentar validar el login
      bool loginSuccess = await _loginViewModel.validateLogin();

      if (loginSuccess) {
        // Login exitoso - el UserSessionService ya estableció la sesión
        debugPrint("Login exitoso para usuario: ${_loginViewModel.getCurrentUsername()}");

        // Navegar al menú principal
        Navigator.pushReplacementNamed(context, '/menu');

        // Mostrar mensaje de bienvenida
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('¡Bienvenido ${_loginViewModel.getCurrentUsername()}!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        // Login fallido - mostrar mensaje de error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Credenciales incorrectas. Verifique su email y contraseña.'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      // Error de conexión
      debugPrint("Error en login: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error de conexión. Verifique su conexión a internet.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _loginViewModel,
      child: Consumer<LoginViewModel>(
        builder: (context, viewModel, _) => Scaffold(
          body: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  'assets/Log in.png',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
                Positioned(
                  top: 350,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Log in
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          child: Text(
                            "Log in",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),

                        // Sign Up
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/logup');
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Campo de texto, correo electrónico
                Positioned(
                  bottom: 310,
                  child: SizedBox(
                    width: 300,
                    child: TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Correo electrónico',
                        labelStyle: TextStyle(color: Colors.black),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        contentPadding: EdgeInsets.only(bottom: 10),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) {
                        _validateEmail();
                      },
                    ),
                  ),
                ),
                // Mostrar el mensaje de error del correo
                Positioned(
                  bottom: 280,
                  child: _emailErrorMessage.isNotEmpty
                      ? Container(
                    width: 300,
                    child: Text(
                      _emailErrorMessage,
                      style: TextStyle(color: Colors.red, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  )
                      : Container(),
                ),
                // Campo de texto para la contraseña
                Positioned(
                  bottom: 230,
                  child: SizedBox(
                    width: 300,
                    child: TextField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        labelStyle: TextStyle(color: Colors.black),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        contentPadding: EdgeInsets.only(bottom: 10),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      onChanged: (value) {
                        _validatePassword();
                      },
                    ),
                  ),
                ),

                // Mostrar el mensaje de error de la contraseña
                Positioned(
                  bottom: 200,
                  child: _passwordErrorMessage.isNotEmpty
                      ? Container(
                    width: 300,
                    child: Text(
                      _passwordErrorMessage,
                      style: TextStyle(color: Colors.red, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  )
                      : Container(),
                ),

                // Botón para iniciar sesión con validación
                Positioned(
                  bottom: 100,
                  child: SizedBox(
                    width: 324,
                    height: 65,
                    child: ElevatedButton(
                      onPressed: viewModel.isLoading ? null : _handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFC96B0D),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: viewModel.isLoading
                          ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                          : Text(
                        'Log in',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
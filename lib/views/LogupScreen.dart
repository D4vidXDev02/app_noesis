import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/signup_viewmodel.dart';

class LogupScreen extends StatefulWidget {
  @override
  _LogupScreenState createState() => _LogupScreenState();
}

class _LogupScreenState extends State<LogupScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  String _emailErrorMessage = '';
  String _passwordErrorMessage = '';

  bool _isPasswordVisible = false;

  late SignupViewModel _signupViewModel;

  @override
  void initState() {
    super.initState();
    _signupViewModel = SignupViewModel();
  }

  void _validateEmail() {
    String email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() {
        _emailErrorMessage = 'Ingrese su correo electrónico';
      });
    } else if (!email.endsWith('@gmail.com')) {
      setState(() {
        _emailErrorMessage = 'Ingrese un correo Gmail válido';
      });
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      setState(() {
        _emailErrorMessage = 'Ingrese un correo electrónico válido';
      });
    } else {
      setState(() {
        _emailErrorMessage = '';
      });
    }
  }

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

  // Función para manejar el registro
  Future<void> _handleSignup() async {
    // Validar campos antes de proceder
    _validateEmail();
    _validatePassword();

    // Si hay errores, no proceder
    if (_emailErrorMessage.isNotEmpty || _passwordErrorMessage.isNotEmpty) {
      return;
    }

    // Actualizar los valores en la capa de ViewModel
    _signupViewModel.email = _emailController.text.trim();
    _signupViewModel.password = _passwordController.text.trim();

    // Intentar registrar el usuario
    Map<String, dynamic> result = await _signupViewModel.registrarUsuario();

    if (result['success']) {
      // Registro exitoso
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message']),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );

      // Navegar al login después de un breve delay
      Future.delayed(Duration(seconds: 2), () {
        Navigator.pushReplacementNamed(context, '/login');
      });
    } else {
      // Error en el registro
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message']),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _signupViewModel,
      child: Consumer<SignupViewModel>(
        builder: (context, viewModel, _) => Scaffold(
          body: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  'assets/Log up.png',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),

                // Textos "Log in" y "Sign Up" en el centro
                Positioned(
                  top: 350,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Log in
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/login');
                          },
                          child: Container(
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
                        ),

                        // Sign Up (activo)
                        Container(
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
                      ],
                    ),
                  ),
                ),

                // Campo de texto para el correo electrónico
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

                // Mostrar mensaje de error email
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

                // Mostrar mensaje de error contraseña
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

                // Botón Sign Up con validación
                Positioned(
                  bottom: 100,
                  child: SizedBox(
                    width: 324,
                    height: 65,
                    child: ElevatedButton(
                      onPressed: viewModel.isLoading ? null : _handleSignup,
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
                        'Sign Up',
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
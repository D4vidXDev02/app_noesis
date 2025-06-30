import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/teacher_signup_viewmodel.dart';

class TeacherSignupScreen extends StatefulWidget {
  @override
  _TeacherSignupScreenState createState() => _TeacherSignupScreenState();
}

class _TeacherSignupScreenState extends State<TeacherSignupScreen> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  String _usernameErrorMessage = '';
  String _emailErrorMessage = '';
  String _passwordErrorMessage = '';
  bool _isPasswordVisible = false;

  late TeacherSignupViewModel _signupViewModel;

  @override
  void initState() {
    super.initState();
    _signupViewModel = TeacherSignupViewModel();
  }

  void _validateUsername() {
    String username = _usernameController.text.trim();
    if (username.isEmpty) {
      setState(() {
        _usernameErrorMessage = 'Ingrese su nombre de usuario';
      });
    } else if (username.length < 3) {
      setState(() {
        _usernameErrorMessage = 'El usuario debe tener al menos 3 caracteres';
      });
    } else {
      setState(() {
        _usernameErrorMessage = '';
      });
    }
  }

  void _validateEmail() {
    String email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() {
        _emailErrorMessage = 'Ingrese su correo electrónico';
      });
    } else if (!email.endsWith('@ccjcallao.edu.pe')) {
      setState(() {
        _emailErrorMessage = 'Debe usar un correo institucional @ccjcallao.edu.pe';
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
        _passwordErrorMessage = 'Ingrese su contraseña';
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

  Future<void> _handleSignup() async {
    _validateUsername();
    _validateEmail();
    _validatePassword();

    if (_usernameErrorMessage.isNotEmpty ||
        _emailErrorMessage.isNotEmpty ||
        _passwordErrorMessage.isNotEmpty) {
      return;
    }

    _signupViewModel.username = _usernameController.text.trim();
    _signupViewModel.email = _emailController.text.trim();
    _signupViewModel.password = _passwordController.text.trim();

    final result = await _signupViewModel.registrarDocente();

    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message']),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );

      // Navegar al login después de un breve delay
      Future.delayed(Duration(seconds: 2), () {
        Navigator.pushReplacementNamed(context, '/teacher-login');
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message']),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  Widget _buildResponsiveContent(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    final isTablet = screenWidth > 600;
    final isLargeScreen = screenWidth > 900;

    // Calcular dimensiones responsivas
    double contentWidth = isLargeScreen
        ? screenWidth * 0.35
        : isTablet
        ? screenWidth * 0.6
        : screenWidth * 0.85;

    double maxContentWidth = isLargeScreen ? 400 : 350;
    contentWidth = contentWidth > maxContentWidth ? maxContentWidth : contentWidth;

    double fieldWidth = contentWidth * 0.85;
    double buttonWidth = contentWidth * 0.9;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: IntrinsicHeight(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05,
                  vertical: screenHeight * 0.02,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Espaciador superior flexible
                    Flexible(
                      flex: isTablet ? 2 : 1,
                      child: SizedBox(height: screenHeight * 0.05),
                    ),

                    // Logo Noesis Docentes
                    Container(
                      margin: EdgeInsets.only(bottom: screenHeight * 0.04),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: isTablet ? 100 : 80,
                            height: isTablet ? 100 : 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                'assets/logo_log.png',
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  // Fallback en caso de error cargando la imagen
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: Color(0xFF4CAF50),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.image_not_supported,
                                        color: Colors.white,
                                        size: isTablet ? 40 : 32,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Noesis Docentes',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isTablet ? 32 : 24,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    // Contenido principal en tarjeta
                    Container(
                      width: contentWidth,
                      constraints: BoxConstraints(
                        maxWidth: maxContentWidth,
                      ),
                      padding: EdgeInsets.all(isTablet ? 32 : 24),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Pestañas Iniciar Sesión / Registrarse
                          Container(
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pushReplacementNamed(context, '/teacher-login');
                                    },
                                    child: Container(
                                      height: 50,
                                      child: Center(
                                        child: Text(
                                          "Iniciar Sesión",
                                          style: TextStyle(
                                            fontSize: isTablet ? 18 : 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Color(0xFF4CAF50),
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Registrarse",
                                        style: TextStyle(
                                          fontSize: isTablet ? 18 : 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: screenHeight * 0.03),

                          // Mensaje de bienvenida
                          Text(
                            "Registro Docentes",
                            style: TextStyle(
                              fontSize: isTablet ? 24 : 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          SizedBox(height: screenHeight * 0.03),

                          // Campo Username
                          Container(
                            width: fieldWidth,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextField(
                                  controller: _usernameController,
                                  decoration: InputDecoration(
                                    labelText: 'Nombre de Usuario',
                                    labelStyle: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: isTablet ? 16 : 14,
                                    ),
                                    border: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey[300]!),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFF4CAF50)),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                                  ),
                                  style: TextStyle(fontSize: isTablet ? 16 : 14),
                                  onChanged: (value) {
                                    _validateUsername();
                                  },
                                ),
                                if (_usernameErrorMessage.isNotEmpty)
                                  Padding(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Text(
                                      _usernameErrorMessage,
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: isTablet ? 14 : 12,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),

                          SizedBox(height: screenHeight * 0.025),

                          // Campo de correo institucional
                          Container(
                            width: fieldWidth,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextField(
                                  controller: _emailController,
                                  decoration: InputDecoration(
                                    labelText: 'Correo Institucional',
                                    hintText: 'usuario@ccjcallao.edu.pe',
                                    labelStyle: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: isTablet ? 16 : 14,
                                    ),
                                    border: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey[300]!),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFF4CAF50)),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  style: TextStyle(fontSize: isTablet ? 16 : 14),
                                  onChanged: (value) {
                                    _validateEmail();
                                  },
                                ),
                                if (_emailErrorMessage.isNotEmpty)
                                  Padding(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Text(
                                      _emailErrorMessage,
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: isTablet ? 14 : 12,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),

                          SizedBox(height: screenHeight * 0.025),

                          // Campo de contraseña
                          Container(
                            width: fieldWidth,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextField(
                                  controller: _passwordController,
                                  obscureText: !_isPasswordVisible,
                                  decoration: InputDecoration(
                                    labelText: 'Contraseña',
                                    labelStyle: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: isTablet ? 16 : 14,
                                    ),
                                    border: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey[300]!),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFF4CAF50)),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _isPasswordVisible
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: Colors.grey[600],
                                        size: isTablet ? 24 : 20,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _isPasswordVisible = !_isPasswordVisible;
                                        });
                                      },
                                    ),
                                  ),
                                  style: TextStyle(fontSize: isTablet ? 16 : 14),
                                  onChanged: (value) {
                                    _validatePassword();
                                  },
                                ),
                                if (_passwordErrorMessage.isNotEmpty)
                                  Padding(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Text(
                                      _passwordErrorMessage,
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: isTablet ? 14 : 12,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),

                          SizedBox(height: screenHeight * 0.04),

                          // Botón Registrarse
                          SizedBox(
                            width: buttonWidth,
                            height: isTablet ? 65 : 55,
                            child: Consumer<TeacherSignupViewModel>(
                              builder: (context, viewModel, _) => ElevatedButton(
                                onPressed: viewModel.isLoading ? null : _handleSignup,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF4CAF50),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(27),
                                  ),
                                  elevation: 3,
                                ),
                                child: viewModel.isLoading
                                    ? SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    strokeWidth: 2,
                                  ),
                                )
                                    : Text(
                                  'Registrarse',
                                  style: TextStyle(
                                    fontSize: isTablet ? 18 : 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 20),

                          // Volver al acceso de estudiantes
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                            },
                            child: Text(
                              "Volver al acceso de estudiantes",
                              style: TextStyle(
                                fontSize: isTablet ? 16 : 14,
                                color: Color(0xFF4CAF50),
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Espaciador inferior flexible
                    Flexible(
                      flex: 1,
                      child: SizedBox(height: screenHeight * 0.05),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _signupViewModel,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF2E7D32).withOpacity(0.8), // Verde para docentes
                Color(0xFF388E3C).withOpacity(0.9),
                Color(0xFF4CAF50),
              ],
              stops: [0.0, 0.5, 1.0],
            ),
          ),
          child: SafeArea(
            child: _buildResponsiveContent(context),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
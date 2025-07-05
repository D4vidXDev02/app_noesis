import 'package:flutter/material.dart';
import '../services/user_session_service.dart';
import '../services/api_service.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();

  // Controladores para cambiar contraseña
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoadingProfile = false;
  bool _isLoadingPassword = false;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _loadUserData() {
    final username = UserSessionService().currentUsername;

    if (username != null) {
      _usernameController.text = username;
    }
  }

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'El nombre de usuario es requerido';
    }

    if (value.length < 3) {
      return 'El username debe tener al menos 3 caracteres';
    }

    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
      return 'Solo se permiten letras, números y guiones bajos';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'La contraseña es requerida';
    }
    if (value.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirma tu contraseña';
    }
    if (value != _newPasswordController.text) {
      return 'Las contraseñas no coinciden';
    }
    return null;
  }

  Future<void> _saveProfileChanges() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoadingProfile = true;
    });

    try {
      final currentEmail = UserSessionService().currentUserEmail;
      if (currentEmail == null) {
        throw Exception('No hay usuario logueado');
      }

      final result = await ApiService.updateUserProfile(
        currentEmail,              // Email actual
        _usernameController.text,  // Nuevo username
      );

      if (result['success']) {
        UserSessionService().setCurrentUser(currentEmail, _usernameController.text);
        _showSuccessSnackBar('Perfil actualizado correctamente');
      } else {
        _showErrorSnackBar(result['message'] ?? 'Error al actualizar el perfil');
      }
    } catch (e) {
      _showErrorSnackBar('Error al actualizar el perfil: $e');
    } finally {
      setState(() {
        _isLoadingProfile = false;
      });
    }
  }

  Future<void> _changePassword() async {
    if (!_passwordFormKey.currentState!.validate()) return;

    setState(() {
      _isLoadingPassword = true;
    });

    try {
      final currentEmail = UserSessionService().currentUserEmail;
      if (currentEmail == null) {
        throw Exception('No hay usuario logueado');
      }

      final result = await ApiService.changeUserPassword(
        currentEmail,
        _newPasswordController.text,
      );

      if (result['success']) {
        _newPasswordController.clear();
        _confirmPasswordController.clear();
        _showSuccessSnackBar('Contraseña cambiada correctamente');
      } else {
        _showErrorSnackBar(result['message'] ?? 'Error al cambiar la contraseña');
      }
    } catch (e) {
      _showErrorSnackBar('Error al cambiar la contraseña: $e');
    } finally {
      setState(() {
        _isLoadingPassword = false;
      });
    }
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.warning,
                color: Colors.red,
                size: 24,
              ),
              SizedBox(width: 8),
              Text('Eliminar Cuenta'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '¿Estás seguro de que deseas eliminar tu cuenta?',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'Esta acción no se puede deshacer. Perderás todos tus datos, progreso y configuraciones.',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancelar',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteAccount();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteAccount() async {
    try {
      // Mostrar indicador de carga
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: CircularProgressIndicator(),
        ),
      );

      final currentEmail = UserSessionService().currentUserEmail;
      if (currentEmail == null) {
        throw Exception('No hay usuario logueado');
      }

      final result = await ApiService.deleteUserAccount(currentEmail);

      // Cerrar el diálogo de carga
      Navigator.of(context).pop();

      if (result['success']) {
        // Cerrar sesión
        UserSessionService().logout();

        // Navegar al login y limpiar el stack
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/login',
              (route) => false,
        );

        _showSuccessSnackBar('Cuenta eliminada correctamente');
      } else {
        _showErrorSnackBar(result['message'] ?? 'Error al eliminar la cuenta');
      }
    } catch (e) {
      // Cerrar el diálogo de carga si está abierto
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      _showErrorSnackBar('Error al eliminar la cuenta: $e');
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error, color: Colors.white),
            SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Color(0xFFC96B0D),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Ajustes',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.bold,
                color: Color(0xFFC96B0D),
              ),
            ),
            Image.asset(
              'assets/logo_noesis.png',
              height: 40,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sección de Cuenta
            _buildSectionHeader('Cuenta'),
            SizedBox(height: 16),

            // Editar Perfil
            _buildSettingsCard(
              title: 'Editar Perfil',
              icon: Icons.person_outline,
              child: _buildEditProfileSection(),
            ),

            SizedBox(height: 16),

            // Cambiar Contraseña
            _buildSettingsCard(
              title: 'Cambiar Contraseña',
              icon: Icons.lock_outline,
              child: _buildChangePasswordSection(),
            ),

            SizedBox(height: 16),

            // Eliminar Cuenta
            _buildSettingsCard(
              title: 'Eliminar Cuenta',
              icon: Icons.delete_outline,
              isDestructive: true,
              child: _buildDeleteAccountSection(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        fontFamily: 'Nunito',
        color: Color(0xFFC96B0D),
      ),
    );
  }

  Widget _buildSettingsCard({
    required String title,
    required IconData icon,
    required Widget child,
    bool isDestructive = false,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        leading: Icon(
          icon,
          color: isDestructive ? Colors.red : Color(0xFFC96B0D),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w600,
            color: isDestructive ? Colors.red : null,
          ),
        ),
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildEditProfileSection() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _usernameController,
            decoration: InputDecoration(
              labelText: 'Nombre de usuario',
              prefixIcon: Icon(Icons.person),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            keyboardType: TextInputType.text,
            validator: _validateUsername,
          ),
          SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoadingProfile ? null : _saveProfileChanges,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFC96B0D),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: _isLoadingProfile
                  ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
                  : Text(
                'Guardar cambios',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChangePasswordSection() {
    return Form(
      key: _passwordFormKey,
      child: Column(
        children: [
          TextFormField(
            controller: _newPasswordController,
            obscureText: _obscureNewPassword,
            decoration: InputDecoration(
              labelText: 'Nueva contraseña',
              prefixIcon: Icon(Icons.lock),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureNewPassword ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _obscureNewPassword = !_obscureNewPassword;
                  });
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            validator: _validatePassword,
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: _confirmPasswordController,
            obscureText: _obscureConfirmPassword,
            decoration: InputDecoration(
              labelText: 'Confirmar contraseña',
              prefixIcon: Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            validator: _validateConfirmPassword,
          ),
          SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoadingPassword ? null : _changePassword,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFC96B0D),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: _isLoadingPassword
                  ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
                  : Text(
                'Cambiar contraseña',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteAccountSection() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.red.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Icon(Icons.warning, color: Colors.red, size: 20),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Esta acción eliminará permanentemente tu cuenta y todos tus datos.',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                    fontFamily: 'Nunito',
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _showDeleteAccountDialog,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Eliminar cuenta',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
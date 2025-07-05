import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/teacher_dashboard_viewmodel.dart';
import '../services/user_session_service.dart';

class TeacherDashboardScreen extends StatefulWidget {
  @override
  _TeacherDashboardScreenState createState() => _TeacherDashboardScreenState();
}

class _TeacherDashboardScreenState extends State<TeacherDashboardScreen> {
  late TeacherDashboardViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = TeacherDashboardViewModel();
    _loadData();
  }

  void _loadData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel.loadDashboardData();
    });
  }

  // Función para obtener configuración responsiva
  Map<String, dynamic> _getResponsiveConfig(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    if (screenWidth >= 1200) {
      // Desktop grande
      return {
        'isDesktop': true,
        'padding': 32.0,
        'cardSpacing': 20.0,
        'statsColumns': 4,
        'welcomeFontSize': 28.0,
        'titleFontSize': 22.0,
        'bodyFontSize': 16.0,
        'smallFontSize': 14.0,
        'iconSize': 40.0,
        'cardPadding': 24.0,
        'headerHeight': 160.0, // Reducido para quitar el mensaje
        'maxContentWidth': 1400.0,
      };
    } else if (screenWidth >= 800) {
      // Tablet
      return {
        'isDesktop': false,
        'padding': 24.0,
        'cardSpacing': 16.0,
        'statsColumns': 3,
        'welcomeFontSize': 24.0,
        'titleFontSize': 20.0,
        'bodyFontSize': 15.0,
        'smallFontSize': 13.0,
        'iconSize': 35.0,
        'cardPadding': 20.0,
        'headerHeight': 140.0, // Reducido para quitar el mensaje
        'maxContentWidth': double.infinity,
      };
    } else {
      // Móvil - Cambio importante: siempre 2 columnas en móvil
      return {
        'isDesktop': false,
        'padding': 16.0,
        'cardSpacing': 12.0,
        'statsColumns': 2, // Siempre 2 columnas en móvil
        'welcomeFontSize': 20.0,
        'titleFontSize': 18.0,
        'bodyFontSize': 14.0,
        'smallFontSize': 12.0,
        'iconSize': 30.0,
        'cardPadding': 16.0,
        'headerHeight': 120.0, // Reducido para quitar el mensaje
        'maxContentWidth': double.infinity,
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = _getResponsiveConfig(context);

    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'Panel Docente',
            style: TextStyle(
              fontFamily: 'Nunito',
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Color(0xFF4CAF50),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              iconSize: config['iconSize'] * 0.7,
              onPressed: () => _viewModel.loadDashboardData(),
            ),
            IconButton(
              icon: Icon(Icons.logout),
              iconSize: config['iconSize'] * 0.7,
              onPressed: () => _showLogoutDialog(),
            ),
          ],
        ),
        body: Consumer<TeacherDashboardViewModel>(
          builder: (context, viewModel, _) {
            if (viewModel.isLoading) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Cargando datos...',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: config['bodyFontSize'],
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              );
            }

            if (viewModel.errorMessage.isNotEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(config['padding']),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: config['iconSize'] * 2,
                        color: Colors.red[300],
                      ),
                      SizedBox(height: 16),
                      Text(
                        viewModel.errorMessage,
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: config['bodyFontSize'],
                          color: Colors.grey[700],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () => viewModel.loadDashboardData(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF4CAF50),
                          padding: EdgeInsets.symmetric(
                            horizontal: config['cardPadding'],
                            vertical: 12,
                          ),
                        ),
                        child: Text(
                          'Reintentar',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: config['bodyFontSize'],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return _buildDashboardContent(viewModel, config);
          },
        ),
      ),
    );
  }

  Widget _buildDashboardContent(TeacherDashboardViewModel viewModel, Map<String, dynamic> config) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: Center(
            child: Container(
              width: config['maxContentWidth'] == double.infinity
                  ? double.infinity
                  : config['maxContentWidth'].clamp(0.0, constraints.maxWidth),
              padding: EdgeInsets.all(config['padding']),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Encabezado adaptativo
                  _buildWelcomeHeader(config),
                  SizedBox(height: config['cardSpacing']),

                  // Estadísticas en grid responsivo
                  _buildResponsiveStatsGrid(viewModel, config),
                  SizedBox(height: config['cardSpacing']),

                  // Layout responsivo para secciones principales
                  if (config['isDesktop'])
                    _buildDesktopLayout(viewModel, config)
                  else
                    _buildMobileTabletLayout(viewModel, config),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildWelcomeHeader(Map<String, dynamic> config) {
    return Container(
      height: config['headerHeight'],
      padding: EdgeInsets.all(config['cardPadding']),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF4CAF50).withOpacity(0.3),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Bienvenido Docente',
            style: TextStyle(
              fontFamily: 'Nunito',
              color: Colors.white,
              fontSize: config['welcomeFontSize'],
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            UserSessionService().currentUsername ?? 'Docente',
            style: TextStyle(
              fontFamily: 'Nunito',
              color: Colors.white70,
              fontSize: config['bodyFontSize'],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResponsiveStatsGrid(TeacherDashboardViewModel viewModel, Map<String, dynamic> config) {
    final stats = [
      {
        'title': 'Total\nEstudiantes',
        'value': viewModel.totalEstudiantes.toString(),
        'icon': Icons.people,
        'color': Colors.blue,
      },
      {
        'title': 'Promedio\nGeneral',
        'value': '${viewModel.promedioGeneral.toStringAsFixed(1)}%',
        'icon': Icons.analytics,
        'color': Colors.green,
      },
      {
        'title': 'Estudiantes\nActivos',
        'value': viewModel.estudiantesActivos.toString(),
        'icon': Icons.trending_up,
        'color': Colors.orange,
      },
      {
        'title': 'Nivel\nPromedio',
        'value': _getMostCommonLevel(viewModel),
        'icon': Icons.school,
        'color': Colors.purple,
      },
    ];

    // Para móvil, mostrar las 4 tarjetas en formato 2x2
    if (config['statsColumns'] == 2) {
      return Column(
        children: [
          // Primera fila: Total Estudiantes y Promedio General
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  stats[0]['title'] as String,
                  stats[0]['value'] as String,
                  stats[0]['icon'] as IconData,
                  stats[0]['color'] as Color,
                  config,
                ),
              ),
              SizedBox(width: config['cardSpacing']),
              Expanded(
                child: _buildStatCard(
                  stats[1]['title'] as String,
                  stats[1]['value'] as String,
                  stats[1]['icon'] as IconData,
                  stats[1]['color'] as Color,
                  config,
                ),
              ),
            ],
          ),
          SizedBox(height: config['cardSpacing']),
          // Segunda fila: Estudiantes Activos y Nivel Promedio
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  stats[2]['title'] as String,
                  stats[2]['value'] as String,
                  stats[2]['icon'] as IconData,
                  stats[2]['color'] as Color,
                  config,
                ),
              ),
              SizedBox(width: config['cardSpacing']),
              Expanded(
                child: _buildStatCard(
                  stats[3]['title'] as String,
                  stats[3]['value'] as String,
                  stats[3]['icon'] as IconData,
                  stats[3]['color'] as Color,
                  config,
                ),
              ),
            ],
          ),
        ],
      );
    }

    // Para tablet y desktop, usar el grid original
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = (constraints.maxWidth - (config['statsColumns'] - 1) * config['cardSpacing']) / config['statsColumns'];

        return Wrap(
          spacing: config['cardSpacing'],
          runSpacing: config['cardSpacing'],
          children: stats.take(config['statsColumns']).map((stat) {
            return SizedBox(
              width: itemWidth,
              child: _buildStatCard(
                stat['title'] as String,
                stat['value'] as String,
                stat['icon'] as IconData,
                stat['color'] as Color,
                config,
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color, Map<String, dynamic> config) {
    return Container(
      padding: EdgeInsets.all(config['cardPadding']),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: config['iconSize'],
            ),
          ),
          SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: config['titleFontSize'],
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: config['smallFontSize'],
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(TeacherDashboardViewModel viewModel, Map<String, dynamic> config) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Columna izquierda
        Expanded(
          flex: 1,
          child: Column(
            children: [
              _buildLevelDistribution(viewModel, config),
              SizedBox(height: config['cardSpacing']),
              _buildTopStudents(viewModel, config),
            ],
          ),
        ),
        SizedBox(width: config['cardSpacing']),
        // Columna derecha
        Expanded(
          flex: 2,
          child: _buildStudentsList(viewModel, config),
        ),
      ],
    );
  }

  Widget _buildMobileTabletLayout(TeacherDashboardViewModel viewModel, Map<String, dynamic> config) {
    return Column(
      children: [
        _buildLevelDistribution(viewModel, config),
        SizedBox(height: config['cardSpacing']),
        _buildTopStudents(viewModel, config),
        SizedBox(height: config['cardSpacing']),
        _buildStudentsList(viewModel, config),
      ],
    );
  }

  Widget _buildLevelDistribution(TeacherDashboardViewModel viewModel, Map<String, dynamic> config) {
    return Container(
      padding: EdgeInsets.all(config['cardPadding']),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.bar_chart,
                color: Color(0xFF4CAF50),
                size: config['iconSize'] * 0.8,
              ),
              SizedBox(width: 8),
              Text(
                'Distribución por Niveles',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: config['titleFontSize'],
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: config['cardSpacing']),
          ...viewModel.nivelDistribution.entries.map((entry) =>
              _buildLevelBar(entry.key, entry.value, viewModel.totalEstudiantes, config)
          ).toList(),
        ],
      ),
    );
  }

  Widget _buildLevelBar(String nivel, int cantidad, int total, Map<String, dynamic> config) {
    double percentage = total > 0 ? (cantidad / total) : 0;
    Color color = _getLevelColor(nivel);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                nivel,
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: config['bodyFontSize'],
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Text(
                '$cantidad estudiantes',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: config['smallFontSize'],
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: percentage,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopStudents(TeacherDashboardViewModel viewModel, Map<String, dynamic> config) {
    final topStudents = viewModel.getTopStudents();

    return Container(
      padding: EdgeInsets.all(config['cardPadding']),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.emoji_events,
                color: Colors.amber,
                size: config['iconSize'] * 0.8,
              ),
              SizedBox(width: 8),
              Text(
                'Top 5 Estudiantes',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: config['titleFontSize'],
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: config['cardSpacing']),
          if (topStudents.isEmpty)
            Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'No hay estudiantes registrados',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: config['bodyFontSize'],
                    color: Colors.grey[500],
                  ),
                ),
              ),
            )
          else
            ...topStudents.asMap().entries.map((entry) {
              int index = entry.key;
              var student = entry.value;
              return _buildTopStudentItem(index + 1, student, config);
            }).toList(),
        ],
      ),
    );
  }

  Widget _buildTopStudentItem(int position, student, Map<String, dynamic> config) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(config['cardPadding'] * 0.75),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            width: config['iconSize'],
            height: config['iconSize'],
            decoration: BoxDecoration(
              color: _getPositionColor(position),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$position',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: config['bodyFontSize'],
                ),
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student.username,
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.bold,
                    fontSize: config['bodyFontSize'],
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  student.nivel,
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    color: _getLevelColor(student.nivel),
                    fontSize: config['smallFontSize'],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${student.porcentaje.toStringAsFixed(1)}%',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.bold,
                  fontSize: config['bodyFontSize'],
                  color: _getLevelColor(student.nivel),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStudentsList(TeacherDashboardViewModel viewModel, Map<String, dynamic> config) {
    return Container(
      padding: EdgeInsets.all(config['cardPadding']),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.group,
                color: Color(0xFF4CAF50),
                size: config['iconSize'] * 0.8,
              ),
              SizedBox(width: 8),
              Text(
                'Todos los Estudiantes',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: config['titleFontSize'],
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: config['cardSpacing']),
          if (viewModel.students.isEmpty)
            Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(
                      Icons.people_outline,
                      size: config['iconSize'] * 2,
                      color: Colors.grey[300],
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No hay estudiantes registrados',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: config['bodyFontSize'],
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            // ...viewModel.students.map((student) => _buildStudentItem(student, config)).toList(),
            ...(viewModel.students.toList()
              ..sort((a, b) => a.username.toLowerCase().compareTo(b.username.toLowerCase())))
                .map((student) => _buildStudentItem(student, config)).toList(),
        ],
      ),
    );
  }

  Widget _buildStudentItem(student, Map<String, dynamic> config) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(config['cardPadding'] * 0.75),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Container(
            width: config['iconSize'],
            height: config['iconSize'],
            decoration: BoxDecoration(
              color: _getLevelColor(student.nivel).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person,
              color: _getLevelColor(student.nivel),
              size: config['iconSize'] * 0.6,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student.username,
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.bold,
                    fontSize: config['bodyFontSize'],
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  student.email,
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    color: Colors.grey[600],
                    fontSize: config['smallFontSize'],
                  ),
                ),
                SizedBox(height: 2),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: _getLevelColor(student.nivel).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Nivel: ${student.nivel}',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      color: _getLevelColor(student.nivel),
                      fontSize: config['smallFontSize'],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${student.puntajeObtenido}/${student.puntajeTotal}',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.bold,
                  fontSize: config['bodyFontSize'],
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 2),
              Text(
                '${student.porcentaje.toStringAsFixed(1)}%',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  color: _getLevelColor(student.nivel),
                  fontSize: config['smallFontSize'],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getLevelColor(String nivel) {
    switch (nivel.toLowerCase()) {
      case 'básico':
        return Colors.red;
      case 'intermedio':
        return Colors.orange;
      case 'avanzado':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Color _getPositionColor(int position) {
    switch (position) {
      case 1:
        return Colors.amber;
      case 2:
        return Colors.grey[400]!;
      case 3:
        return Colors.brown[300]!;
      default:
        return Colors.blue;
    }
  }

  String _getMostCommonLevel(TeacherDashboardViewModel viewModel) {
    if (viewModel.nivelDistribution.isEmpty) return 'N/A';

    String mostCommon = viewModel.nivelDistribution.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;

    return mostCommon;
  }

  void _showLogoutDialog() {
    final config = _getResponsiveConfig(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Cerrar Sesión',
          style: TextStyle(
            fontFamily: 'Nunito',
            fontWeight: FontWeight.bold,
            fontSize: config['titleFontSize'],
          ),
        ),
        content: Text(
          '¿Estás seguro de que quieres cerrar sesión?',
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: config['bodyFontSize'],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancelar',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: config['bodyFontSize'],
                color: Colors.grey[600],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              UserSessionService().logout();
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Cerrar Sesión',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: config['bodyFontSize'],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
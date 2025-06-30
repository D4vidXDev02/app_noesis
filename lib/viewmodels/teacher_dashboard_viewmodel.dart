import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/student_stats.dart';

class TeacherDashboardViewModel with ChangeNotifier {
  List<StudentStats> _students = [];
  bool _isLoading = false;
  String _errorMessage = '';

  // Estadísticas generales
  double _promedioGeneral = 0.0;
  int _totalEstudiantes = 0;
  int _estudiantesActivos = 0;
  Map<String, int> _nivelDistribution = {};

  // Getters
  List<StudentStats> get students => _students;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  double get promedioGeneral => _promedioGeneral;
  int get totalEstudiantes => _totalEstudiantes;
  int get estudiantesActivos => _estudiantesActivos;
  Map<String, int> get nivelDistribution => _nivelDistribution;

  Future<void> loadDashboardData() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      // Cargar estadísticas generales
      final statsResponse = await ApiService.getStudentsStats();
      if (statsResponse['success']) {
        _promedioGeneral = (statsResponse['data']['promedio_general'] ?? 0.0).toDouble();
        _totalEstudiantes = statsResponse['data']['total_estudiantes'] ?? 0;
        _estudiantesActivos = statsResponse['data']['estudiantes_activos'] ?? 0;
        _nivelDistribution = Map<String, int>.from(statsResponse['data']['distribucion_niveles'] ?? {});
      }

      // Cargar progreso de estudiantes
      final progressResponse = await ApiService.getStudentsProgress();
      if (progressResponse['success']) {
        final List<dynamic> studentsData = progressResponse['data']['estudiantes'] ?? [];
        _students = studentsData.map((data) => StudentStats.fromJson(data)).toList();
      }

    } catch (e) {
      _errorMessage = 'Error al cargar datos: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Filtrar estudiantes por nivel
  List<StudentStats> getStudentsByLevel(String nivel) {
    return _students.where((student) => student.nivel == nivel).toList();
  }

  // Obtener top estudiantes
  List<StudentStats> getTopStudents({int limit = 5}) {
    var sortedStudents = List<StudentStats>.from(_students);
    sortedStudents.sort((a, b) => b.porcentaje.compareTo(a.porcentaje));
    return sortedStudents.take(limit).toList();
  }
}
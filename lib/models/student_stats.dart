class StudentStats {
  final String username;
  final String email;
  final int puntajeObtenido;
  final int puntajeTotal;
  final String nivel;
  final String fechaUltimaActividad;
  final int leccionesCompletadas;

  // Constructor para inicializar las estadísticas del estudiante
  StudentStats({
    required this.username,
    required this.email,
    required this.puntajeObtenido,
    required this.puntajeTotal,
    required this.nivel,
    required this.fechaUltimaActividad,
    required this.leccionesCompletadas,
  });

  // Metodo factory para crear estadísticas a partir de un JSON
  factory StudentStats.fromJson(Map<String, dynamic> json) {
    return StudentStats(
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      puntajeObtenido: json['puntaje_obtenido'] ?? 0,
      puntajeTotal: json['puntaje_total'] ?? 20,
      nivel: json['nivel'] ?? 'Básico',
      fechaUltimaActividad: json['fecha_ultima_actividad'] ?? '',
      leccionesCompletadas: json['lecciones_completadas'] ?? 0,
    );
  }

  // calcula el porcentaje de progreso del estudiante
  double get porcentaje => puntajeTotal > 0 ? (puntajeObtenido / puntajeTotal * 100) : 0;
}
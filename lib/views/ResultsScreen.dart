import 'package:flutter/material.dart';
import '../viewmodels/quiz_viewmodel.dart';

class ResultsScreen extends StatelessWidget {
  final int correctAnswers;
  final int totalQuestions;
  final String timeElapsed;
  final QuizViewModel quizViewModel;
  final List<bool> answerHistory;

  const ResultsScreen({
    Key? key,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.timeElapsed,
    required this.quizViewModel,
    required this.answerHistory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final percentage = (correctAnswers / totalQuestions * 100).round();
    final questionStats = quizViewModel.getQuestionStats();
    final performance = _getPerformanceLevel(percentage);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF353535),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Image.asset(
              'assets/logo_noesis.png',
              height: 40,
            ),
          ],
        ),
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      backgroundColor: Color(0xFF353535),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(24),
                child: Column(
                  children: [
                    SizedBox(height: 20),

                    // Título principal
                    Text(
                      'JUEGO COMPLETADO',
                      style: TextStyle(
                        fontFamily: 'Orbitron',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),

                    SizedBox(height: 40),

                    // Tarjeta principal de resultados
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Color(0xFF2A2A2A),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Puntuación y tiempo
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Puntuación',
                                    style: TextStyle(
                                      fontFamily: 'Nunito',
                                      fontSize: 16,
                                      color: Color(0xFF00BCD4),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: '$correctAnswers',
                                          style: TextStyle(
                                            fontFamily: 'Orbitron',
                                            fontSize: 32,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '/$totalQuestions',
                                          style: TextStyle(
                                            fontFamily: 'Orbitron',
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF9E9E9E),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    '$percentage%',
                                    style: TextStyle(
                                      fontFamily: 'Nunito',
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: _getPerformanceColor(percentage),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Tiempo',
                                    style: TextStyle(
                                      fontFamily: 'Nunito',
                                      fontSize: 16,
                                      color: Color(0xFF00BCD4),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    timeElapsed,
                                    style: TextStyle(
                                      fontFamily: 'Orbitron',
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    _getTimePerQuestion(),
                                    style: TextStyle(
                                      fontFamily: 'Nunito',
                                      fontSize: 14,
                                      color: Color(0xFF9E9E9E),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          SizedBox(height: 24),

                          // Indicador de rendimiento
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: _getPerformanceColor(percentage).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _getPerformanceColor(percentage).withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  _getPerformanceIcon(percentage),
                                  color: _getPerformanceColor(percentage),
                                  size: 24,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  performance,
                                  style: TextStyle(
                                    fontFamily: 'Nunito',
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: _getPerformanceColor(percentage),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 24),

                    // Análisis por categorías
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Color(0xFF2A2A2A),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Análisis de Preguntas',
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF00BCD4),
                            ),
                          ),
                          SizedBox(height: 16),

                          ...questionStats.entries.map((entry) {
                            String category = entry.key;
                            int count = entry.value;
                            if (count == 0) return SizedBox.shrink();

                            return Padding(
                              padding: EdgeInsets.only(bottom: 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      category,
                                      style: TextStyle(
                                        fontFamily: 'Nunito',
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Color(0xFF4A4A4A),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      '$count pregunta${count > 1 ? 's' : ''}',
                                      style: TextStyle(
                                        fontFamily: 'Nunito',
                                        fontSize: 14,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),

                    SizedBox(height: 24),

                    // Estadísticas adicionales
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Color(0xFF2A2A2A),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Estadísticas Detalladas',
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF00BCD4),
                            ),
                          ),
                          SizedBox(height: 16),

                          _buildStatRow('Respuestas correctas', '$correctAnswers', Colors.green),
                          _buildStatRow('Respuestas incorrectas', '${totalQuestions - correctAnswers}', Colors.red),
                          _buildStatRow('Precisión', '$percentage%', _getPerformanceColor(percentage)),
                          _buildStatRow('Racha más larga', '${_getLongestStreak()}', Color(0xFF00BCD4)),
                        ],
                      ),
                    ),

                    SizedBox(height: 32),

                    // Botones de acción
                    Column(
                      children: [
                        _buildActionButton(
                          text: 'Mostrar respuestas',
                          icon: Icons.list_alt,
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => AnswersScreen(
                                  quizViewModel: quizViewModel,
                                  answerHistory: answerHistory,
                                ),
                              ),
                            );
                          },
                        ),

                        SizedBox(height: 16),

                        _buildActionButton(
                          text: 'Nuevo quiz',
                          icon: Icons.refresh,
                          onPressed: () {
                            quizViewModel.reset();
                            Navigator.of(context).popUntil((route) => route.isFirst);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Bottom navigation
            Container(
              height: 60,
              decoration: BoxDecoration(
                color: Color(0xFF2A2A2A),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    icon: Icon(Icons.home, color: Colors.white, size: 28),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.favorite_border, color: Colors.white, size: 28),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.person, color: Colors.white, size: 28),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value, Color color) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 16,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String text,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF4A4A4A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 2,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getPerformanceLevel(int percentage) {
    if (percentage >= 90) return 'Excelente';
    if (percentage >= 80) return 'Muy Bueno';
    if (percentage >= 70) return 'Bueno';
    if (percentage >= 60) return 'Regular';
    return 'Necesita Mejora';
  }

  Color _getPerformanceColor(int percentage) {
    if (percentage >= 80) return Colors.green;
    if (percentage >= 60) return Colors.orange;
    return Colors.red;
  }

  IconData _getPerformanceIcon(int percentage) {
    if (percentage >= 90) return Icons.star;
    if (percentage >= 80) return Icons.thumb_up;
    if (percentage >= 70) return Icons.sentiment_satisfied;
    if (percentage >= 60) return Icons.sentiment_neutral;
    return Icons.sentiment_dissatisfied;
  }

  String _getTimePerQuestion() {
    // Convertir tiempo elapsed a segundos
    final parts = timeElapsed.split(':');
    final totalSeconds = int.parse(parts[0]) * 60 + int.parse(parts[1]);
    final avgSeconds = (totalSeconds / totalQuestions).round();
    return '${avgSeconds}s por pregunta';
  }

  int _getLongestStreak() {
    int currentStreak = 0;
    int longestStreak = 0;

    for (bool isCorrect in answerHistory) {
      if (isCorrect) {
        currentStreak++;
        longestStreak = currentStreak > longestStreak ? currentStreak : longestStreak;
      } else {
        currentStreak = 0;
      }
    }

    return longestStreak;
  }
}

// Pantalla para mostrar las respuestas
class AnswersScreen extends StatelessWidget {
  final QuizViewModel quizViewModel;
  final List<bool> answerHistory;

  const AnswersScreen({
    Key? key,
    required this.quizViewModel,
    required this.answerHistory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF353535),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Respuestas',
              style: TextStyle(
                fontFamily: 'Orbitron',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            Image.asset(
              'assets/logo_noesis.png',
              height: 40,
            ),
          ],
        ),
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      backgroundColor: Color(0xFF353535),
      body: SafeArea(
        child: Column(
          children: [
            // Resumen rápido
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              color: Color(0xFF2A2A2A),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildQuickStat('Correctas', answerHistory.where((x) => x).length, Colors.green),
                  _buildQuickStat('Incorrectas', answerHistory.where((x) => !x).length, Colors.red),
                  _buildQuickStat('Total', answerHistory.length, Color(0xFF00BCD4)),
                ],
              ),
            ),

            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: quizViewModel.questions.length,
                itemBuilder: (context, index) {
                  final question = quizViewModel.questions[index];
                  final wasCorrect = index < answerHistory.length ? answerHistory[index] : false;

                  return Container(
                    margin: EdgeInsets.only(bottom: 16),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Color(0xFF2A2A2A),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: wasCorrect ? Colors.green.withOpacity(0.3) : Colors.red.withOpacity(0.3),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header con número y status
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Pregunta ${index + 1}',
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF00BCD4),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: wasCorrect ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    wasCorrect ? Icons.check : Icons.close,
                                    color: wasCorrect ? Colors.green : Colors.red,
                                    size: 16,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    wasCorrect ? 'Correcta' : 'Incorrecta',
                                    style: TextStyle(
                                      fontFamily: 'Nunito',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: wasCorrect ? Colors.green : Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),

                        // Pregunta
                        Text(
                          question.question,
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 16),

                        // Opciones
                        ...question.options.asMap().entries.map((entry) {
                          int optionIndex = entry.key;
                          String option = entry.value;
                          String prefix = String.fromCharCode(65 + optionIndex);
                          bool isCorrect = option == question.correctAnswer;

                          return Container(
                            margin: EdgeInsets.only(bottom: 8),
                            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                            decoration: BoxDecoration(
                              color: isCorrect
                                  ? Colors.green.withOpacity(0.2)
                                  : Color(0xFF4A4A4A),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isCorrect ? Colors.green : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  '$prefix) ',
                                  style: TextStyle(
                                    fontFamily: 'Nunito',
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: isCorrect ? Colors.green : Colors.white,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    option,
                                    style: TextStyle(
                                      fontFamily: 'Nunito',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: isCorrect ? Colors.green : Colors.white,
                                    ),
                                  ),
                                ),
                                if (isCorrect)
                                  Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 20,
                                  ),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Bottom navigation
            Container(
              height: 60,
              decoration: BoxDecoration(
                color: Color(0xFF2A2A2A),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    icon: Icon(Icons.home, color: Colors.white, size: 28),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.favorite_border, color: Colors.white, size: 28),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.person, color: Colors.white, size: 28),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStat(String label, int value, Color color) {
    return Column(
      children: [
        Text(
          '$value',
          style: TextStyle(
            fontFamily: 'Orbitron',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 14,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
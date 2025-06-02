import 'package:flutter/material.dart';
import '../viewmodels/quiz_viewmodel.dart';
import 'ResultsScreen.dart';

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final QuizViewModel viewModel = QuizViewModel();
  String? selectedAnswer;
  bool showFeedback = false;
  bool isCorrect = false;

  // Variables para el tiempo y puntuación
  late DateTime startTime;
  int correctAnswersCount = 0;
  List<bool> answerHistory = []; // Historial de respuestas para análisis

  @override
  void initState() {
    super.initState();
    startTime = DateTime.now();
  }

  void _submitAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
      isCorrect = viewModel.isAnswerCorrect(answer);
      showFeedback = true;

      // Contar respuestas correctas y guardar historial
      if (isCorrect) {
        correctAnswersCount++;
      }
      answerHistory.add(isCorrect);
    });

    Future.delayed(Duration(seconds: 2), () {
      if (!viewModel.isLastQuestion) {
        viewModel.nextQuestion();
        setState(() {
          selectedAnswer = null;
          showFeedback = false;
        });
      } else {
        // Quiz terminado - navegar a pantalla de resultados
        _navigateToResults();
      }
    });
  }

  void _navigateToResults() {
    final endTime = DateTime.now();
    final duration = endTime.difference(startTime);
    final timeElapsed = _formatDuration(duration);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => ResultsScreen(
          correctAnswers: correctAnswersCount,
          totalQuestions: viewModel.questions.length,
          timeElapsed: timeElapsed,
          quizViewModel: viewModel,
          answerHistory: answerHistory,
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  // Metodo para calcular el porcentaje de progreso
  double get progressPercentage => (viewModel.currentIndex + 1) / viewModel.questions.length;

  @override
  Widget build(BuildContext context) {
    final question = viewModel.currentQuestion;

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
            _showExitConfirmation();
          },
        ),
      ),
      backgroundColor: Color(0xFF353535),
      body: SafeArea(
        child: Column(
          children: [
            // Barra de progreso
            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Pregunta ${viewModel.currentIndex + 1} de ${viewModel.questions.length}',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 16,
                          color: Color(0xFF9E9E9E),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '${(progressPercentage * 100).toInt()}%',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 16,
                          color: Color(0xFF00BCD4),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: progressPercentage,
                    backgroundColor: Color(0xFF4A4A4A),
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00BCD4)),
                    minHeight: 6,
                  ),
                ],
              ),
            ),

            // Contenido principal con scroll
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Título del juego
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Test Game ',
                            style: TextStyle(
                              fontFamily: 'Orbitron',
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '🎮',
                            style: TextStyle(fontSize: 24),
                          ),
                        ],
                      ),

                      SizedBox(height: 20),

                      // Estadísticas rápidas
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Color(0xFF2A2A2A),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check_circle, color: Colors.green, size: 16),
                            SizedBox(width: 4),
                            Text(
                              '$correctAnswersCount correctas',
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: 14,
                                color: Colors.green,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 20),

                      Container(
                        width: double.infinity,
                        child: Text(
                          question.question,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      SizedBox(height: 24),

                      // Opciones de respuesta
                      ...question.options.asMap().entries.map((entry) {
                        int index = entry.key;
                        String option = entry.value;
                        String prefix = String.fromCharCode(65 + index); // A, B, C, D

                        Color buttonColor;
                        Color borderColor = Colors.transparent;

                        if (showFeedback && selectedAnswer == option) {
                          buttonColor = isCorrect ? Colors.green : Colors.red;
                          borderColor = isCorrect ? Colors.green : Colors.red;
                        } else if (showFeedback && option == question.correctAnswer) {
                          // Mostrar la respuesta correcta si el usuario se equivocó
                          buttonColor = Colors.green;
                          borderColor = Colors.green;
                        } else {
                          buttonColor = Color(0xFF9E9E9E);
                        }

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                          child: Container(
                            width: double.infinity,
                            constraints: BoxConstraints(
                              maxWidth: 339,
                              minHeight: 80,
                            ),
                            child: ElevatedButton(
                              onPressed: selectedAnswer == null && !showFeedback
                                  ? () => _submitAnswer(option)
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: buttonColor,
                                padding: EdgeInsets.symmetric(
                                    vertical: 16,
                                    horizontal: 20
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  side: BorderSide(
                                    color: borderColor,
                                    width: 2,
                                  ),
                                ),
                                elevation: 0,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    '$prefix) ',
                                    style: TextStyle(
                                      fontFamily: 'Nunito',
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      option,
                                      style: TextStyle(
                                        fontFamily: 'Nunito',
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),

                      SizedBox(height: 16),

                      // Feedback visual de rptas
                      if (showFeedback)
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isCorrect
                                ? Colors.green.withOpacity(0.2)
                                : Colors.red.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isCorrect ? Colors.green : Colors.red,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            isCorrect ? '¡Correcto! ✓' : '¡Incorrecto! ✗',
                            style: TextStyle(
                              color: isCorrect ? Colors.green : Colors.red,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Nunito',
                            ),
                          ),
                        ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Confirmación antes de salir
  void _showExitConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF2A2A2A),
          title: Text(
            '¿Salir del quiz?',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Nunito',
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Si sales ahora, perderás tu progreso actual.',
            style: TextStyle(
              color: Color(0xFF9E9E9E),
              fontFamily: 'Nunito',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar diálogo
              },
              child: Text(
                'Continuar',
                style: TextStyle(
                  color: Color(0xFF00BCD4),
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar diálogo
                Navigator.of(context).pop(); // Salir del quiz
              },
              child: Text(
                'Salir',
                style: TextStyle(
                  color: Colors.red,
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
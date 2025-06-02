import '../models/quiz_question.dart';
import 'dart:math';

class QuizViewModel {
  int _currentIndex = 0;
  List<QuizQuestion> _selectedQuestions = [];

  // Banco completo de 40 preguntas
  final List<QuizQuestion> _allQuestions = [
    // Verb To Be (10 preguntas)
    QuizQuestion(
      question: "He ___ a doctor.",
      options: ["are", "is", "am", "be"],
      correctAnswer: "is",
    ),
    QuizQuestion(
      question: "They ___ my friends.",
      options: ["is", "are", "am", "be"],
      correctAnswer: "are",
    ),
    QuizQuestion(
      question: "My parents ___ always supportive of my decisions.",
      options: ["is", "am", "are", "be"],
      correctAnswer: "are",
    ),
    QuizQuestion(
      question: "The documents ___ supposed to be on the manager's desk this morning.",
      options: ["are", "is", "was", "be"],
      correctAnswer: "are",
    ),
    QuizQuestion(
      question: "I ___ not ready for the exam yet.",
      options: ["is", "are", "am", "be"],
      correctAnswer: "am",
    ),
    QuizQuestion(
      question: "The book ___ on the table.",
      options: ["are", "is", "am", "were"],
      correctAnswer: "is",
    ),
    QuizQuestion(
      question: "We ___ students at the university.",
      options: ["is", "am", "are", "was"],
      correctAnswer: "are",
    ),
    QuizQuestion(
      question: "She ___ very talented in music.",
      options: ["are", "am", "is", "were"],
      correctAnswer: "is",
    ),
    QuizQuestion(
      question: "You ___ welcome to join us anytime.",
      options: ["is", "am", "are", "was"],
      correctAnswer: "are",
    ),
    QuizQuestion(
      question: "It ___ a beautiful day today.",
      options: ["are", "am", "is", "were"],
      correctAnswer: "is",
    ),

    // Present Simple (10 preguntas)
    QuizQuestion(
      question: "She ___ every morning at 6 AM.",
      options: ["wake", "waking", "woke", "wakes"],
      correctAnswer: "wakes",
    ),
    QuizQuestion(
      question: "We ___ to the same school.",
      options: ["goes", "go", "going", "gone"],
      correctAnswer: "go",
    ),
    QuizQuestion(
      question: "He usually ___ his homework before dinner.",
      options: ["do", "did", "does", "doing"],
      correctAnswer: "does",
    ),
    QuizQuestion(
      question: "The train ___ every hour, so don't worry if you miss this one.",
      options: ["departs", "departed", "depart", "is departing"],
      correctAnswer: "departs",
    ),
    QuizQuestion(
      question: "My sister ___ English and French fluently.",
      options: ["speak", "speaks", "speaking", "spoke"],
      correctAnswer: "speaks",
    ),
    QuizQuestion(
      question: "They ___ coffee every morning.",
      options: ["drinks", "drink", "drinking", "drank"],
      correctAnswer: "drink",
    ),
    QuizQuestion(
      question: "The sun ___ in the east.",
      options: ["rise", "rises", "rising", "rose"],
      correctAnswer: "rises",
    ),
    QuizQuestion(
      question: "I ___ my teeth twice a day.",
      options: ["brush", "brushes", "brushing", "brushed"],
      correctAnswer: "brush",
    ),
    QuizQuestion(
      question: "She ___ to work by bus.",
      options: ["travel", "travels", "traveling", "traveled"],
      correctAnswer: "travels",
    ),
    QuizQuestion(
      question: "We ___ our grandparents every weekend.",
      options: ["visit", "visits", "visiting", "visited"],
      correctAnswer: "visit",
    ),

    // Future Perfect (10 preguntas)
    QuizQuestion(
      question: "By 8 PM, I ___ my homework.",
      options: ["will finished", "will be finished", "will finish", "will have finished"],
      correctAnswer: "will have finished",
    ),
    QuizQuestion(
      question: "She ___ dinner before we arrive.",
      options: ["will have cooked", "has cooked", "will cook", "cooks"],
      correctAnswer: "will have cooked",
    ),
    QuizQuestion(
      question: "By next semester, they ___ all the required courses.",
      options: ["will have completed", "complete", "will complete", "completed"],
      correctAnswer: "will have completed",
    ),
    QuizQuestion(
      question: "By 2030, scientists ___ a cure for many rare diseases.",
      options: ["have found", "found", "will have found", "find"],
      correctAnswer: "will have found",
    ),
    QuizQuestion(
      question: "By the time you get home, I ___ the report.",
      options: ["will finish", "will have finished", "finish", "finished"],
      correctAnswer: "will have finished",
    ),
    QuizQuestion(
      question: "They ___ the project by next Friday.",
      options: ["will complete", "will have completed", "complete", "completed"],
      correctAnswer: "will have completed",
    ),
    QuizQuestion(
      question: "By noon, she ___ for three hours.",
      options: ["will study", "will have studied", "studies", "studied"],
      correctAnswer: "will have studied",
    ),
    QuizQuestion(
      question: "We ___ all the books by the end of the month.",
      options: ["will read", "will have read", "read", "reads"],
      correctAnswer: "will have read",
    ),
    QuizQuestion(
      question: "By tomorrow, he ___ the entire presentation.",
      options: ["will prepare", "will have prepared", "prepares", "prepared"],
      correctAnswer: "will have prepared",
    ),
    QuizQuestion(
      question: "The team ___ the championship by next year.",
      options: ["will win", "will have won", "wins", "won"],
      correctAnswer: "will have won",
    ),

    // The Verb Can (10 preguntas)
    QuizQuestion(
      question: "I ___ ride a bike.",
      options: ["can", "am", "have", "do"],
      correctAnswer: "can",
    ),
    QuizQuestion(
      question: "He ___ play the piano.",
      options: ["will", "can", "is", "does"],
      correctAnswer: "can",
    ),
    QuizQuestion(
      question: "She ___ speak three languages fluently.",
      options: ["is", "does", "will", "can"],
      correctAnswer: "can",
    ),
    QuizQuestion(
      question: "Although he's young, he ___ analyze complex systems with ease.",
      options: ["can", "may", "is", "will"],
      correctAnswer: "can",
    ),
    QuizQuestion(
      question: "We ___ help you with your project.",
      options: ["will", "are", "can", "do"],
      correctAnswer: "can",
    ),
    QuizQuestion(
      question: "They ___ swim very well.",
      options: ["are", "do", "will", "can"],
      correctAnswer: "can",
    ),
    QuizQuestion(
      question: "You ___ borrow my car if you need it.",
      options: ["will", "are", "can", "do"],
      correctAnswer: "can",
    ),
    QuizQuestion(
      question: "My brother ___ cook delicious meals.",
      options: ["is", "does", "can", "will"],
      correctAnswer: "can",
    ),
    QuizQuestion(
      question: "She ___ solve difficult math problems quickly.",
      options: ["will", "is", "can", "does"],
      correctAnswer: "can",
    ),
    QuizQuestion(
      question: "We ___ meet tomorrow if you're available.",
      options: ["are", "do", "can", "will"],
      correctAnswer: "can",
    ),
  ];

  // Getters
  List<QuizQuestion> get questions => _selectedQuestions;
  int get currentIndex => _currentIndex;
  QuizQuestion get currentQuestion => _selectedQuestions[_currentIndex];
  bool get isLastQuestion => _currentIndex == _selectedQuestions.length - 1;

  // Constructor que inicializa con preguntas aleatorias
  QuizViewModel() {
    _selectRandomQuestions();
  }

  // Metodo para seleccionar 20 preguntas aleatorias del banco de 40
  void _selectRandomQuestions() {
    final random = Random();
    List<QuizQuestion> tempQuestions = List.from(_allQuestions);
    _selectedQuestions.clear();

    // Seleccionar 20 preguntas aleatorias
    for (int i = 0; i < 20; i++) {
      int randomIndex = random.nextInt(tempQuestions.length);
      _selectedQuestions.add(tempQuestions[randomIndex]);
      tempQuestions.removeAt(randomIndex); // Evitar duplicados
    }
  }

  void nextQuestion() {
    if (_currentIndex < _selectedQuestions.length - 1) {
      _currentIndex++;
    }
  }

  bool isAnswerCorrect(String answer) {
    return answer == currentQuestion.correctAnswer;
  }

  void reset() {
    _currentIndex = 0;
    _selectRandomQuestions(); // Seleccionar nuevas preguntas aleatorias al reiniciar
  }

  // Metodo para obtener estadísticas del banco de preguntas
  Map<String, int> getQuestionStats() {
    int verbToBe = 0;
    int presentSimple = 0;
    int futurePerfect = 0;
    int verbCan = 0;

    // Contar preguntas por categoría en las preguntas seleccionadas
    for (var question in _selectedQuestions) {
      String questionText = question.question.toLowerCase();
      if (questionText.contains('___') &&
          (question.options.contains('is') || question.options.contains('are') || question.options.contains('am'))) {
        verbToBe++;
      } else if (question.options.contains('can')) {
        verbCan++;
      } else if (question.options.contains('will have')) {
        futurePerfect++;
      } else {
        presentSimple++;
      }
    }

    return {
      'Verb To Be': verbToBe,
      'Present Simple': presentSimple,
      'Future Perfect': futurePerfect,
      'Verb Can': verbCan,
    };
  }
}
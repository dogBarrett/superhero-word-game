import 'dart:ui';

class GuessTheImageQuestion {
  String question;
  String answer;
  String pathImage;
  List<String> keyboardButtons = [];
  List<KeyboardCharacter> keyboardCharacter = [];
  bool isDone = false;
  bool isFull = false;

  GuessTheImageQuestion({
    required this.question,
    required this.answer,
    required this.pathImage,
  });

  bool fieldCompleteCorrect() {
    return keyboardCharacter.every((char) => char.correctValue == char.currentValue);
  }
}

class KeyboardCharacter {
  String? correctValue;
  String? currentValue;
  int? currentIndex;
  bool hintShow;
  Color? highlightColor; // Added property

  KeyboardCharacter({
    required this.correctValue,
    this.currentValue,
    this.currentIndex,
    this.hintShow = false,
    this.highlightColor, // Added parameter
  });

  void clearValue() {
    currentValue = null;
    currentIndex = -1;
    highlightColor = null; // Reset highlight color when clearing value
  }
}
class GetQuestions {
  List<GuessTheImageQuestion> listQuestions;

  GetQuestions()
      : listQuestions = [
    GuessTheImageQuestion(
      question: "What is the name of this team?",
      answer: "avengers",
      pathImage: "avengers",
    ),
    GuessTheImageQuestion(
      question: "Who is this?",
      answer: "venom",
      pathImage: "venom",
    ),
    GuessTheImageQuestion(
      question: "Who is this? ....... America",
      answer: "captain",
      pathImage: "captainamerica",

    ),
    GuessTheImageQuestion(
      question: "Who is this? Black .......",
      answer: "panther",
      pathImage: "blackpanther",

    ),
    GuessTheImageQuestion(
      question: "Who is this?",
      answer: "hulk",
      pathImage: "hulk",

    ),
    GuessTheImageQuestion(
      question: "What is Hulk's real name? Bruce ......",
      answer: "banner",
      pathImage: "hulk",

    ),
    GuessTheImageQuestion(
      question: "Who is this ..... Widow?",
      answer: "black",
      pathImage: "blackwidow",

    ),
    GuessTheImageQuestion(
      question: "Who is this ...... Man?",
      answer: "spider",
      pathImage: "spiderman",

    ),
    GuessTheImageQuestion(
      question: "Who is this? ..... Parker",
      answer: "peter",
      pathImage: "spiderman",

    ),
    GuessTheImageQuestion(
      question: "Who is this? Peter ......",
      answer: "parker",
      pathImage: "spiderman",

    ),
    GuessTheImageQuestion(
      question: "Who Spider Man's Aunty? Aunt ...",
      answer: "may",
      pathImage: "spiderman",

    ),
    // Add more questions as needed
  ];
}

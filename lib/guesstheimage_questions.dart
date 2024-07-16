//import 'package:superhero_word_game/guesstheimage.dart';

List<GuessTheImageQuestions> listQuestions = [];

class GuessTheImageQuestions {
  String question = "";
  String pathImage = "";
  String answer = "";
  bool isDone = false;
  bool isFull = false;
  //List<WordFindChar> puzzles = new List<WordFindChar>();
  //List<WordFindChar> puzzles = List<WordFindChar>();
  //List<String> arrayBtns = new List<String>();
  List<String> keyboardButtons = [];
  List<KeyboardCharacter> keyboardCharacter = [];



  GuessTheImageQuestions({
    required this.pathImage,
    required this.question,
    required this.answer,
    this.keyboardButtons = const[],
  });

  void setWordFindChar(List<KeyboardCharacter> keyboardCharacter) => this.keyboardCharacter = keyboardCharacter;

  void setIsDone() => this.isDone = true;

  bool fieldCompleteCorrect() {
    // lets declare class WordFindChar 1st
    // check all field already got value
    // fix color red when value not full but show red color
    bool complete =
        this.keyboardCharacter.where((puzzle) => puzzle.currentValue == "").length == 0;

    if (!complete) {
      // no complete yet
      this.isFull = false;
      return complete;
    }

    else
      this.isFull = true;
    // if already complete, check correct or not

    String answeredString =
        this.keyboardCharacter.map((puzzle) => puzzle.currentValue).join("");

    // if same string, answer is correct..yeay
    return answeredString == this.answer;
  }

  // more prefer name.. haha
  GuessTheImageQuestions clone() {
    return new GuessTheImageQuestions(
      answer: this.answer,
      pathImage: this.pathImage,
      question: this.question,
      keyboardButtons: this.keyboardButtons,
    );
  }

// lets generate sample question
}

// done
class KeyboardCharacter {
  String currentValue = "";
  int currentIndex = 0;
  String correctValue = "";
  bool hintShow = false;

  KeyboardCharacter({
    required this.hintShow,
    required this.correctValue,
    required this.currentIndex,
    required this.currentValue,
  });

  getCurrentValue() {
    if (this.correctValue != "")
      return this.currentValue;
    else if (this.hintShow) return this.correctValue;
  }

  void clearValue() {
    //this.currentIndex = 0;
    this.currentValue = "";
  }
}

class GetQuestions {
  late List<GuessTheImageQuestions> listQuestions;

  GetQuestions() {
    listQuestions = [
      GuessTheImageQuestions(
        question: "What is the name of this team?",
        answer: "avengers",
        pathImage: "avengers",
      ),
      GuessTheImageQuestions(
        question: "Who is this?",
        answer: "venom",
        pathImage: "venom",

      ),
      GuessTheImageQuestions(
        question: "Who is this? ....... America",
        answer: "captain",
        pathImage: "captainamerica",

      ),
      GuessTheImageQuestions(
        question: "Who is this? Black .......",
        answer: "panther",
        pathImage: "blackpanther",

      ),
      GuessTheImageQuestions(
        question: "Who is this?",
        answer: "hulk",
        pathImage: "hulk",

      ),
      GuessTheImageQuestions(
        question: "What is Hulk's real name? Bruce ......",
        answer: "banner",
        pathImage: "hulk",

      ),
      GuessTheImageQuestions(
        question: "Who is this ..... Widow?",
        answer: "black",
        pathImage: "blackwidow",

      ),
      GuessTheImageQuestions(
        question: "Who is this ...... Man?",
        answer: "spider",
        pathImage: "spiderman",

      ),
      GuessTheImageQuestions(
        question: "Who is this? ..... Parker",
        answer: "peter",
        pathImage: "spiderman",

      ),
      GuessTheImageQuestions(
        question: "Who is this? Peter ......",
        answer: "parker",
        pathImage: "spiderman",

      ),
      GuessTheImageQuestions(
        question: "Who Spider Man's Aunty? Aunt ...",
        answer: "may",
        pathImage: "spiderman",

      ),
    ];
  }
}

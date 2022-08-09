//import 'package:superhero_word_game/guesstheimage.dart';

List<WordFindQues> listQuestions;

class WordFindQues {
  String question;
  String pathImage;
  String answer;
  bool isDone = false;
  bool isFull = false;
  List<WordFindChar> puzzles = new List<WordFindChar>();
  List<String> arrayBtns = new List<String>();

  WordFindQues({
    this.pathImage,
    this.question,
    this.answer,
    this.arrayBtns,
  });

  void setWordFindChar(List<WordFindChar> puzzles) => this.puzzles = puzzles;

  void setIsDone() => this.isDone = true;

  bool fieldCompleteCorrect() {
    // lets declare class WordFindChar 1st
    // check all field already got value
    // fix color red when value not full but show red color
    bool complete =
        this.puzzles.where((puzzle) => puzzle.currentValue == null).length == 0;

    if (!complete) {
      // no complete yet
      this.isFull = false;
      return complete;
    }

    this.isFull = true;
    // if already complete, check correct or not

    String answeredString =
        this.puzzles.map((puzzle) => puzzle.currentValue).join("");

    // if same string, answer is correct..yeay
    return answeredString == this.answer;
  }

  // more prefer name.. haha
  WordFindQues clone() {
    return new WordFindQues(
      answer: this.answer,
      pathImage: this.pathImage,
      question: this.question,
    );
  }

// lets generate sample question
}

// done
class WordFindChar {
  String currentValue;
  int currentIndex;
  String correctValue;
  bool hintShow;

  WordFindChar({
    this.hintShow = false,
    this.correctValue,
    this.currentIndex,
    this.currentValue,
  });

  getCurrentValue() {
    if (this.correctValue != null)
      return this.currentValue;
    else if (this.hintShow) return this.correctValue;
  }

  void clearValue() {
    this.currentIndex = null;
    this.currentValue = null;
  }
}

class GetQuestions {
  GetQuestions() {
    listQuestions = [
      WordFindQues(
          question: "What is the name of this team?",
          answer: "avengers",
          pathImage: "avengers"),
      WordFindQues(
          question: "Who is this?", answer: "venom", pathImage: "venom"),
      WordFindQues(
          question: "Who is this? ....... America",
          answer: "captain",
          pathImage: "captainamerica"),
      WordFindQues(
          question: "Who is this? Black .......",
          answer: "panther",
          pathImage: "blackpanther"),
      WordFindQues(
          question: "Who is this?",
          answer: "hulk",
          pathImage: "hulk"),
      WordFindQues(
          question: "What is Hulk's real name? Bruce ......",
          answer: "banner",
          pathImage: "hulk"),
      WordFindQues(
          question: "Who is this ..... Widow?",
          answer: "black",
          pathImage: "blackwidow"),
      WordFindQues(
          question: "Who is this ...... Man?",
          answer: "spider",
          pathImage: "spiderman"),
      WordFindQues(
          question: "Who is this? ..... Parker",
          answer: "peter",
          pathImage: "spiderman"),
      WordFindQues(
          question: "Who is this? Peter ......",
          answer: "parker",
          pathImage: "spiderman"),
      WordFindQues(
          question: "Who Spider Man's Aunty? Aunt ...",
          answer: "may",
          pathImage: "spiderman"),

    ];
  }
}

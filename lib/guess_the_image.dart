
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GuessTheImageQuestion {
  final String question;
  final String answer;
  final String imagePath;
  late List<String> keyboardButtons;
  late List<KeyboardCharacter> keyboardCharacter;
  bool isAnsweredCorrectly = false;

  GuessTheImageQuestion({
    required this.question,
    required this.answer,
    required this.imagePath,
  }) {
    // Initialize keyboard buttons with randomized letters
    keyboardButtons = generateKeyboardButtons(answer);

    // Initialize keyboard characters for answer input
    keyboardCharacter = List.generate(
      answer.length,
          (index) => KeyboardCharacter(correctValue: answer[index], currentValue: null, hintShow: false),
    );
  }

  List<String> generateKeyboardButtons(String answer) {
    // Generate keyboard buttons with correct letters from answer
    List<String> answerLetters = answer.toUpperCase().split('');
    List<String> allLetters = List.generate(26, (index) => String.fromCharCode('A'.codeUnitAt(0) + index));
    List<String> buttons = [];

    // Add all letters from the answer including duplicates
    answerLetters.forEach((letter) {
      buttons.add(letter);
    });

    // Add remaining random letters
    while (buttons.length < 12) {
      String randomLetter = allLetters[Random().nextInt(allLetters.length)];
      if (!buttons.contains(randomLetter) || answerLetters.contains(randomLetter)) {
        buttons.add(randomLetter);
      }
    }

    buttons.shuffle();
    return buttons;
  }
}

class KeyboardCharacter {
  final String correctValue;
  String? currentValue;
  bool hintShow;
  Color? highlightColor;

  KeyboardCharacter({required this.correctValue, this.currentValue, this.hintShow = false, this.highlightColor});
}

class GetQuestions {
  List<GuessTheImageQuestion> listQuestions;

  GetQuestions()
      : listQuestions = [
    GuessTheImageQuestion(
      question: "What is the name of this team?",
      answer: "avengers",
      imagePath: "avengers",
    ),
    GuessTheImageQuestion(
      question: "Who is this?",
      answer: "venom",
      imagePath: "venom",
    ),
    GuessTheImageQuestion(
      question: "Who is this? ....... America",
      answer: "captain",
      imagePath: "captainamerica",
    ),
    GuessTheImageQuestion(
      question: "Who is this? Black .......",
      answer: "panther",
      imagePath: "blackpanther",
    ),
    GuessTheImageQuestion(
      question: "Who is this?",
      answer: "hulk",
      imagePath: "hulk",
    ),
    GuessTheImageQuestion(
      question: "What is Hulk's real name? Bruce ......",
      answer: "banner",
      imagePath: "hulk",
    ),
    GuessTheImageQuestion(
      question: "Who is this ..... Widow?",
      answer: "black",
      imagePath: "blackwidow",
    ),
    GuessTheImageQuestion(
      question: "Who is this ...... Man?",
      answer: "spider",
      imagePath: "spiderman",
    ),
    GuessTheImageQuestion(
      question: "Who is this? ..... Parker",
      answer: "peter",
      imagePath: "spiderman",
    ),
    GuessTheImageQuestion(
      question: "Who is this? Peter ......",
      answer: "parker",
      imagePath: "spiderman",
    ),
    GuessTheImageQuestion(
      question: "Who Spider Man's Aunty? Aunt ...",
      answer: "may",
      imagePath: "spiderman",
    ),
    // Add more questions as needed
  ];
}

class GuessTheImageGame extends StatefulWidget {
  GuessTheImageGame({Key? key}) : super(key: key);

  @override
  _GuessTheImageGameState createState() => _GuessTheImageGameState();
}

class _GuessTheImageGameState extends State<GuessTheImageGame> {
  late List<GuessTheImageQuestion> questionList;
  late GuessTheImageQuestion currentQuestion;
  int questionIndex = 0;
  int totalQuestions = 0;
  int answeredQuestions = 0;
  final Random random = Random();

  @override
  void initState() {
    super.initState();
    loadQuestionsFromGetQuestions();
    initializeGame();
    loadNextQuestion();
  }

  void initializeGame() {
    totalQuestions = questionList.length;
  }

  void loadQuestionsFromGetQuestions() {
    // Initialize questions from GetQuestions.listQuestions
    GetQuestions getQuestions = GetQuestions();
    questionList = List.from(getQuestions.listQuestions);
  }

  void loadNextQuestion() {
    if (answeredQuestions < totalQuestions) {
      do {
        questionIndex = random.nextInt(questionList.length);
      } while (questionList[questionIndex].isAnsweredCorrectly);

      currentQuestion = questionList[questionIndex];
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Text(
          "GUESS THE IMAGE",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        color: Colors.grey[600],
        child: Column(
          children: [
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return GuessTheImageWidget(
                    size: constraints.biggest,
                    question: currentQuestion,
                    onAnswered: () {
                      setState(() {
                        currentQuestion.isAnsweredCorrectly = true;
                      });
                      Future.delayed(Duration(milliseconds: 500), () {
                        setState(() {
                          loadNextQuestion();
                        });
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GuessTheImageWidget extends StatefulWidget {
  final Size size;
  final GuessTheImageQuestion question;
  final VoidCallback onAnswered;

  GuessTheImageWidget({
    required this.size,
    required this.question,
    required this.onAnswered,
    Key? key,
  }) : super(key: key);

  @override
  _GuessTheImageWidgetState createState() => _GuessTheImageWidgetState();
}

class _GuessTheImageWidgetState extends State<GuessTheImageWidget> {
  late Size size;
  late GuessTheImageQuestion question;

  @override
  void initState() {
    super.initState();
    size = widget.size;
    question = widget.question;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      child: Column(
        children: [
          buildImageContainer(),
          buildQuestionRow(),
          buildAnswerRow(),
          buildKeyboard(),
        ],
      ),
    );
  }

  Expanded buildImageContainer() {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(5),
        child: Container(
          alignment: Alignment.center,
          constraints: BoxConstraints(
            maxWidth: size.width * 0.9,
          ),
          child: Image.asset(
            'images/${question.imagePath}.jpeg',
            errorBuilder: (context, error, stackTrace) {
              return Text('Image not found');
            },
          ),
        ),
      ),
    );
  }

  Container buildQuestionRow() {
    return Container(
      padding: EdgeInsets.all(10),
      alignment: Alignment.center,
      child: Text(
        question.question,
        style: TextStyle(
          fontSize: 20.sp,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Container buildAnswerRow() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      alignment: Alignment.center,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(question.answer.length, (index) {
              KeyboardCharacter character = question.keyboardCharacter[index];
              Color color;

              if (question.isAnsweredCorrectly)
                color = Colors.green[300]!;
              else if (character.hintShow)
                color = Colors.yellow[100]!;
              else if (character.currentValue != null)
                color = Color(0xff7EE7FD);
              else
                color = Colors.grey;

              return InkWell(
                onTap: () {
                  if (character.hintShow || question.isAnsweredCorrectly) return;

                  // Call onAnswerButtonPressed when a letter in the answer row is tapped
                  onAnswerButtonPressed(index);
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  width: constraints.biggest.width / 8 - 6,
                  height: constraints.biggest.width / 8 - 6,
                  margin: EdgeInsets.all(3),
                  child: Text(
                    "${character.currentValue ?? ''}".toUpperCase(),
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }

  Container buildKeyboard() {
    return Container(
      padding: EdgeInsets.all(.05.sw),
      alignment: Alignment.center,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 1,
          crossAxisCount: 6,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
        ),
        itemCount: question.keyboardButtons.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          String button = question.keyboardButtons[index];
          bool isSelectable = !question.keyboardCharacter.any((char) => char.correctValue == button);

          Color buttonColor = isSelectable ? Colors.blue : Colors.white12;

          return LayoutBuilder(
            builder: (context, constraints) {
              return Container(
                width: constraints.biggest.width / 8 - 6,
                height: constraints.biggest.width / 8 - 6,
                decoration: BoxDecoration(
                  color: buttonColor,
                  borderRadius: BorderRadius.circular(.02.sw),
                ),
                alignment: Alignment.center,
                child: SizedBox(
                  height: constraints.biggest.height,
                  child: TextButton(
                    child: Text(
                      button.toUpperCase(),
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    onPressed: isSelectable ? () => onKeyboardButtonPressed(index) : null,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void onAnswerButtonPressed(int index) {
    if (question.isAnsweredCorrectly) return;

    // Retrieve the character at the given index in the answer row
    KeyboardCharacter character = question.keyboardCharacter[index];

    // Set the character's current value to null to remove it
    character.currentValue = null;

    // Update the UI
    setState(() {});
  }

  void onKeyboardButtonPressed(int index) {
    if (question.isAnsweredCorrectly) return;

    String button = question.keyboardButtons[index].toUpperCase();

    // Check if there is an available slot for the current button
    KeyboardCharacter? emptyCharacter;
    for (var char in question.keyboardCharacter) {
      if (char.currentValue == null) {
        emptyCharacter = char;
        break;
      }
    }

    // Assign the selected button to the empty slot
    if (emptyCharacter != null) {
      emptyCharacter.currentValue = button;

      // Check if all characters are filled
      bool allFilled = question.keyboardCharacter.every((char) => char.currentValue != null);

      if (allFilled) {
        String enteredAnswer = question.keyboardCharacter.map((char) => char.currentValue!).join();
        if (enteredAnswer.toLowerCase() == question.answer) {
          question.isAnsweredCorrectly = true;
          setState(() {});
          widget.onAnswered();
        } else {
          // Highlight all characters in red for incorrect answer
          question.keyboardCharacter.forEach((char) {
            char.highlightColor = Colors.red;
          });
          setState(() {});
        }
      } else {
        setState(() {});
      }
    }
  }
}

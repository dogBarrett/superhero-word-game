/*
import 'dart:math';


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:word_search_safety/word_search_safety.dart';

import 'guesstheimage_questions.dart';

class GuessTheImage extends StatefulWidget {
  GuessTheImage({Key? key}) : super(key: key);

  @override
  _GuessTheImageState createState() => _GuessTheImageState();
}

class _GuessTheImageState extends State<GuessTheImage> {
  // sent size to our widget
  GlobalKey<_GuessTheImageState> globalKey = GlobalKey();

  // make list question for puzzle
  // make class 1st

  @override
  void initState() {
    super.initState();
    GetQuestions();
  }

  //var randomNumber = new Random();
  //late Size size;
  //List<WordFindQues> listQuestions;
  //int indexQues = 0; // current index question
  //int hintCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Text("GUESS THE IMAGE"),
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
      //body: SafeArea(
      body: Container(
        color: Colors.grey[600],
        child: Column(
          children: [
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Container(
                    color: Colors.grey,
                    // lets make our word find widget
                    // sent list to our widget
                    child: GuessTheImageWidget(
                      constraints.biggest,
                      listQuestions.map((ques) => ques.clone()).toList(),
                      key: globalKey,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        //),
      ),
    );
  }
}

class GuessTheImageWidget extends StatefulWidget {
  Size size;
  List<GuessTheImageQuestions> listQuestions = [];
  GuessTheImageWidget(this.size, this.listQuestions, {Key? key})
      : super(key: key);

  @override
  _GuessTheImageWidgetState createState() => _GuessTheImageWidgetState();
}

class _GuessTheImageWidgetState extends State<GuessTheImageWidget> {
  var randomNumber = new Random();
  late Size size;
  List<GuessTheImageQuestions> listQuestions = [];
  int questionNumber = 0; // current index question
  int hintCount = 0;
  late GuessTheImageQuestions currentQuestion;
  int numberOfQuestions = 0;
  int questionsDone = 0;

  // thanks for watching.. :)

  @override
  void initState() {
    super.initState();
    size = widget.size;
    listQuestions = widget.listQuestions;
    initialiseVariables();

    generatePuzzle();
  }

  void initialiseVariables() {
    numberOfQuestions = listQuestions.length;
    questionsDone = 0;
  }

  @override
  Widget build(BuildContext context) {
    // lets make ui
    // let put current data on question
    currentQuestion = listQuestions[questionNumber];

    return Container(
      width: double.maxFinite,
      child: Column(
        children: [
          //topRow(),
          imageContainer(),
          questionRow(),
          answerRow(),
          keyboard(),
        ],
      ),
    );
  }

  Container topRow() {
    return Container(
        //height: .05.sh,
        //color: Colors.red,
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () => generateHint(),
              child: Icon(
                Icons.lightbulb,
                size: 25.sp,
                color: Colors.yellow[200],
              ),
            ),
            InkWell(
              onTap: () => generatePuzzle(),
              child: Icon(
                Icons.arrow_forward_ios,
                size: 25.sp,
                color: Colors.yellow[200],
              ),
            ),
          ],
        ));
  }

  Expanded imageContainer() {
    return Expanded(
        child: Container(
            //height: .35.sh,
            alignment: Alignment.center,
            padding: EdgeInsets.all(5),
            child: Container(
                alignment: Alignment.center,
                constraints: BoxConstraints(
                  maxWidth: size.width * 0.9,
                  //maxHeight: size.height / 2.5,
                ),
                child: Image.asset(
                  'images/${currentQuestion.pathImage}.jpeg',
                  //child: Image.asset('images/venom.jpeg', fit: BoxFit.contain),
                ))));
  }

  Container questionRow() {
    return Container(
      //height: .08.sh,
      //question text
      padding: EdgeInsets.all(10),
      alignment: Alignment.center,
      child: Text(
        "${currentQuestion.question ?? ''}",
        //"Who is this???",
        style: TextStyle(
          fontSize: 20.sp,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Container answerRow() {
    return Container(
      //height: .08.sh,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      alignment: Alignment.center,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: currentQuestion.keyboardCharacter.map((puzzle) {
              Color color;

              if (currentQuestion.isDone)
                color = Colors.green[300]!;
              else if (puzzle.hintShow)
                color = Colors.yellow[100]!;
              else if (currentQuestion.isFull)
                color = Colors.red;
              else
                color = Color(0xff7EE7FD);

              return InkWell(
                onTap: () {
                  if (puzzle.hintShow || currentQuestion.isDone) return;

                  currentQuestion.isFull = false;
                  puzzle.clearValue();
                  setState(() {});
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
                    "${puzzle.currentValue ?? ''}".toUpperCase(),
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  Container keyboard() {
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
        itemCount: currentQuestion.keyboardButtons.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          // Determine if the button is selected
          bool beenPressed = currentQuestion.keyboardCharacter.indexWhere(
                  (keyboardCharacter) =>
                      keyboardCharacter.currentIndex == index) >=
              0;

          // Determine if the button is in a valid position to be selected
          //bool selectable = !currentQuestion.isDone;
          //bool selectable = !beenPressed && !currentQuestion.isDone;
          bool selectable = true;

          // Define the color based on the button state
          Color color = selectable ? Colors.blue : Colors.white12;

          return LayoutBuilder(
            builder: (context, constraints) {
              return Container(
                width: constraints.biggest.width / 8 - 6,
                height: constraints.biggest.width / 8 - 6,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(.02.sw),
                ),
                alignment: Alignment.center,
                child: SizedBox(
                  height: constraints.biggest.height,
                  child: TextButton(
                    child: Text(
                      "${currentQuestion.keyboardButtons[index]}".toUpperCase(),
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    onPressed: () {
                      if (selectable) {
                        setBtnClick(index);
                      }
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  /*Container keyboard() {
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
        itemCount: 12, // later change
        shrinkWrap: true,
        itemBuilder: (context, index) {
          bool statusBtn = currentQues.puzzles
                  .indexWhere((puzzle) => puzzle.currentIndex == index) >=
              0;

          return LayoutBuilder(
            builder: (context, constraints) {
              Color color = statusBtn ? Colors.white70 : Color(0xff7EE7FD);

              return Container(
                width: constraints.biggest.width / 8 - 6,
                height: constraints.biggest.width / 8 - 6,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(.02.sw),
                ),
                alignment: Alignment.center,
                child: SizedBox(
                  height: constraints.biggest.height,
                  child: TextButton(
                    child: Text(
                      "${currentQues.arrayBtns[index]}".toUpperCase(),
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      //textAlign: TextAlign.left,
                    ),
                    onPressed: () {
                      if (!statusBtn) setBtnClick(index);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }*/

  void generatePuzzle() {
    //int thisNumber = randomNumber.nextInt(listQuestions.length);
    //int thisNumber;

    int previousPuzzle = questionNumber;
    //indexQues = thisNumber;
    //previousPuzzle = indexQues;
    if (questionsDone < numberOfQuestions) {
      do {
        questionNumber = randomNumber.nextInt(listQuestions.length);
      } while ((this.listQuestions[questionNumber].isDone == true) ||
          (previousPuzzle == questionNumber));
      print("here");
      if (this.listQuestions[questionNumber].isDone) return;

      GuessTheImageQuestions currentQuestion = listQuestions[questionNumber];

      final List<String> wl = [currentQuestion.answer];

      final WSSettings ws = WSSettings(
        width: 12, // total random word row we want use
        height: 1,
        orientations: List.from([
          WSOrientation.horizontal,
        ]),
      );

      final WordSearchSafety wordSearch = WordSearchSafety();
      //final WordFindWidget wordSearch = WordFindWidget();

      final WSNewPuzzle newPuzzle = wordSearch.newPuzzle(wl, ws);

      // check if got error generate random word
      if (newPuzzle.errors!.isEmpty) {
        currentQuestion.keyboardButtons =
            newPuzzle.puzzle!.expand((list) => list).toList();
        currentQuestion.keyboardButtons
            .shuffle(); // make shuffle so user not know answer

        bool isDone = currentQuestion.isDone;

        if (!isDone) {
          currentQuestion.keyboardCharacter =
              List.generate(wl[0].split("").length, (index) {
            return KeyboardCharacter(
                correctValue: currentQuestion.answer.split("")[index],
                currentIndex: index,
                currentValue: "",
                hintShow: false);
          });
        }
      }
      questionsDone++;
      hintCount = 0; //number hint per ques we hit
      setState(() {});
    }
  }

  generateHint() async {
    // let dclare hint
    GuessTheImageQuestions currentQuestion = listQuestions[questionNumber];

    List<KeyboardCharacter> puzzleNoHints = currentQuestion.keyboardCharacter
        .where((puzzle) => !puzzle.hintShow && puzzle.currentIndex == 0)
        .toList();

    if (puzzleNoHints.length > 0) {
      hintCount++;
      int indexHint = Random().nextInt(puzzleNoHints.length);
      int countTemp = 0;
      // print("hint $indexHint");

      currentQuestion.keyboardCharacter =
          currentQuestion.keyboardCharacter.map((puzzle) {
        if (!puzzle.hintShow && puzzle.currentIndex == 0) countTemp++;

        if (indexHint == countTemp - 1) {
          puzzle.hintShow = true;
          puzzle.currentValue = puzzle.correctValue;
          puzzle.currentIndex = currentQuestion.keyboardButtons
              .indexWhere((btn) => btn == puzzle.correctValue);
        }

        return puzzle;
      }).toList();

      // check if complete

      if (currentQuestion.fieldCompleteCorrect()) {
        currentQuestion.isDone = true;

        setState(() {});

        await Future.delayed(Duration(seconds: 1));
        generatePuzzle();
      }

      // my wrong..not refresh.. damn..haha
      setState(() {});
    }
  }

  Future<void> setBtnClick(int index) async {
    GuessTheImageQuestions currentQuestion = listQuestions[questionNumber];

    int currentIndexEmpty = currentQuestion.keyboardCharacter
        .indexWhere((puzzle) => puzzle.currentValue == "");

    if (currentIndexEmpty >= 0) {
      currentQuestion.keyboardCharacter[currentIndexEmpty].currentIndex = index;
      currentQuestion.keyboardCharacter[currentIndexEmpty].currentValue =
          currentQuestion.keyboardButtons[index];

      if (currentQuestion.fieldCompleteCorrect()) {
        currentQuestion.isDone = true;

        setState(() {});

        await Future.delayed(Duration(seconds: 1));
        generatePuzzle();
      }
      setState(() {});
    }
  }
}
*/
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:word_search_safety/word_search_safety.dart';

import 'guesstheimage_questions.dart';

class GuessTheImage extends StatefulWidget {
  GuessTheImage({Key? key}) : super(key: key);

  @override
  _GuessTheImageState createState() => _GuessTheImageState();
}

class _GuessTheImageState extends State<GuessTheImage> {
  late List<GuessTheImageQuestions> listQuestions;

  @override
  void initState() {
    super.initState();
    listQuestions = GetQuestions().listQuestions;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Text("GUESS THE IMAGE"),
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
                    listQuestions: listQuestions,
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
  final List<GuessTheImageQuestions> listQuestions;

  GuessTheImageWidget({required this.size, required this.listQuestions, Key? key})
      : super(key: key);

  @override
  _GuessTheImageWidgetState createState() => _GuessTheImageWidgetState();
}

class _GuessTheImageWidgetState extends State<GuessTheImageWidget> {
  var randomNumber = Random();
  late Size size;
  late List<GuessTheImageQuestions> listQuestions;
  int questionNumber = 0; // current index question
  int hintCount = 0;
  int numberOfQuestions = 0;
  int questionsDone = 0;

  @override
  void initState() {
    super.initState();
    size = widget.size;
    listQuestions = widget.listQuestions;
    initialiseVariables();
    generatePuzzle();
  }

  void initialiseVariables() {
    numberOfQuestions = listQuestions.length;
    questionsDone = 0;
  }

  @override
  Widget build(BuildContext context) {
    GuessTheImageQuestions currentQuestion = listQuestions[questionNumber];

    return Container(
      width: double.maxFinite,
      child: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(5),
              child: Image.asset(
                'images/${currentQuestion.pathImage}.jpeg',
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              currentQuestion.question ?? '',
              style: TextStyle(
                fontSize: 20.sp,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          answerRow(currentQuestion),
          keyboard(currentQuestion),
        ],
      ),
    );
  }

  Widget answerRow(GuessTheImageQuestions currentQuestion) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      alignment: Alignment.center,
      child: Wrap(
        alignment: WrapAlignment.center,
        children: currentQuestion.keyboardCharacter.map((puzzle) {
          Color color;

          if (currentQuestion.isDone)
            color = Colors.green[300]!;
          else if (puzzle.hintShow)
            color = Colors.yellow[100]!;
          else if (currentQuestion.isFull)
            color = Colors.red;
          else
            color = Color(0xff7EE7FD);

          return Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
            width: size.width / 8 - 6,
            height: size.width / 8 - 6,
            margin: EdgeInsets.all(3),
            child: Text(
              puzzle.currentValue?.toUpperCase() ?? '',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget keyboard(GuessTheImageQuestions currentQuestion) {
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
        itemCount: currentQuestion.keyboardButtons.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          bool isPressed = currentQuestion.keyboardCharacter.any(
                  (keyboardCharacter) => keyboardCharacter.currentIndex == index);

          Color color = isPressed ? Colors.white12 : Colors.blue;

          return LayoutBuilder(
            builder: (context, constraints) {
              return Container(
                width: constraints.biggest.width / 8 - 6,
                height: constraints.biggest.width / 8 - 6,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(.02.sw),
                ),
                alignment: Alignment.center,
                child: SizedBox(
                  height: constraints.biggest.height,
                  child: TextButton(
                    child: Text(
                      "${currentQuestion.keyboardButtons[index]}".toUpperCase(),
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    onPressed: isPressed ? null : () {
                      if (!isPressed) {
                        setBtnClick(index);
                      }
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void generatePuzzle() {
    if (questionsDone < numberOfQuestions) {
      int previousPuzzle = questionNumber;
      do {
        questionNumber = randomNumber.nextInt(listQuestions.length);
      } while ((listQuestions[questionNumber].isDone == true) ||
          (previousPuzzle == questionNumber));

      GuessTheImageQuestions currentQuestion = listQuestions[questionNumber];

      final List<String> wordList = [currentQuestion.answer];
      final WSSettings wsSettings = WSSettings(
        width: 12,
        height: 1,
        orientations: [WSOrientation.horizontal],
      );

      final WordSearchSafety wordSearch = WordSearchSafety();
      final WSNewPuzzle newPuzzle = wordSearch.newPuzzle(wordList, wsSettings);

      if (newPuzzle.errors!.isEmpty) {
        currentQuestion.keyboardButtons =
            newPuzzle.puzzle!.expand((list) => list).toList();
        currentQuestion.keyboardButtons.shuffle();

        if (!currentQuestion.isDone) {
          currentQuestion.keyboardCharacter = List.generate(
              wordList[0].split("").length, (index) {
            return KeyboardCharacter(
              correctValue: currentQuestion.answer.split("")[index],
              currentIndex: index,
              currentValue: "",
              hintShow: false,
            );
          });
        }
      }
      questionsDone++;
      hintCount = 0;
      setState(() {});
    }
  }

  void generateHint() async {
    GuessTheImageQuestions currentQuestion = listQuestions[questionNumber];
    List<KeyboardCharacter> puzzleNoHints = currentQuestion.keyboardCharacter
        .where((puzzle) => !puzzle.hintShow && puzzle.currentValue.isEmpty)
        .toList();

    if (puzzleNoHints.isNotEmpty) {
      hintCount++;
      int indexHint = Random().nextInt(puzzleNoHints.length);
      int countTemp = 0;

      currentQuestion.keyboardCharacter =
          currentQuestion.keyboardCharacter.map((puzzle) {
            if (!puzzle.hintShow && puzzle.currentValue.isEmpty) countTemp++;

            if (indexHint == countTemp - 1) {
              puzzle.hintShow = true;
              puzzle.currentValue = puzzle.correctValue;
              puzzle.currentIndex = currentQuestion.keyboardButtons
                  .indexWhere((btn) => btn == puzzle.correctValue);
            }

            return puzzle;
          }).toList();

      if (currentQuestion.fieldCompleteCorrect()) {
        currentQuestion.isDone = true;
        setState(() {});
        await Future.delayed(Duration(seconds: 1));
        generatePuzzle();
      }
      setState(() {});
    }
  }

  Future<void> setBtnClick(int index) async {
    GuessTheImageQuestions currentQuestion = listQuestions[questionNumber];

    int currentIndexEmpty = currentQuestion.keyboardCharacter
        .indexWhere((puzzle) => puzzle.currentValue.isEmpty);

    if (currentIndexEmpty >= 0) {
      currentQuestion.keyboardCharacter[currentIndexEmpty].currentIndex = index;
      currentQuestion.keyboardCharacter[currentIndexEmpty].currentValue =
      currentQuestion.keyboardButtons[index];

      if (currentQuestion.fieldCompleteCorrect()) {
        currentQuestion.isDone = true;
        setState(() {});
        await Future.delayed(Duration(seconds: 1));
        generatePuzzle();
      }
      setState(() {});
    }
  }
}
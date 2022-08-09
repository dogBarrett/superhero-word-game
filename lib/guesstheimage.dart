import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:word_search/word_search.dart';

import 'guesstheimage_questions.dart';

class WordFind extends StatefulWidget {
  WordFind({Key key}) : super(key: key);

  @override
  _WordFindState createState() => _WordFindState();
}

class _WordFindState extends State<WordFind> {
  // sent size to our widget
  GlobalKey<_WordFindWidgetState> globalKey = GlobalKey();

  // make list question for puzzle
  // make class 1st

  @override
  void initState() {
    super.initState();
    GetQuestions();
  }

  var randomNumber = new Random();
  Size size;
  //List<WordFindQues> listQuestions;
  int indexQues = 0; // current index question
  int hintCount = 0;

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
                    child: WordFindWidget(
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

class WordFindWidget extends StatefulWidget {
  Size size;
  List<WordFindQues> listQuestions;
  WordFindWidget(this.size, this.listQuestions, {Key key}) : super(key: key);

  @override
  _WordFindWidgetState createState() => _WordFindWidgetState();
}

class _WordFindWidgetState extends State<WordFindWidget> {
  var randomNumber = new Random();
  Size size;
  List<WordFindQues> listQuestions;
  int indexQues = 0; // current index question
  int hintCount = 0;
  WordFindQues currentQues;
  int numberOfQuestions;
  int questionsDone;

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
    currentQues = listQuestions[indexQues];

    return Container(
      width: double.maxFinite,
      child: Column(
        children: [
          topRow(),
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
                  'images/${currentQues.pathImage}.jpeg',
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
        "${currentQues.question ?? ''}",
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
            children: currentQues.puzzles.map((puzzle) {
              Color color;

              if (currentQues.isDone)
                color = Colors.green[300];
              else if (puzzle.hintShow)
                color = Colors.yellow[100];
              else if (currentQues.isFull)
                color = Colors.red;
              else
                color = Color(0xff7EE7FD);

              return InkWell(
                onTap: () {
                  if (puzzle.hintShow || currentQues.isDone) return;

                  currentQues.isFull = false;
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
  }

  void generatePuzzle() {
    //int thisNumber = randomNumber.nextInt(listQuestions.length);
    //int thisNumber;

    int previousPuzzle = indexQues;
    //indexQues = thisNumber;
    //previousPuzzle = indexQues;
    if (questionsDone < numberOfQuestions) {
      do {
        indexQues = randomNumber.nextInt(listQuestions.length);
      } while ((this.listQuestions[indexQues].isDone == true) ||
          (previousPuzzle == indexQues));
      print("here");
      if (this.listQuestions[indexQues].isDone) return;

      WordFindQues currentQues = listQuestions[indexQues];

      final List<String> wl = [currentQues.answer];

      final WSSettings ws = WSSettings(
        width: 12, // total random word row we want use
        height: 1,
        orientations: List.from([
          WSOrientation.horizontal,
        ]),
      );

      final WordSearch wordSearch = WordSearch();

      final WSNewPuzzle newPuzzle = wordSearch.newPuzzle(wl, ws);

      // check if got error generate random word
      if (newPuzzle.errors.isEmpty) {
        currentQues.arrayBtns =
            newPuzzle.puzzle.expand((list) => list).toList();
        currentQues.arrayBtns.shuffle(); // make shuffle so user not know answer

        bool isDone = currentQues.isDone;

        if (!isDone) {
          currentQues.puzzles = List.generate(wl[0].split("").length, (index) {
            return WordFindChar(
                correctValue: currentQues.answer.split("")[index]);
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
    WordFindQues currentQues = listQuestions[indexQues];

    List<WordFindChar> puzzleNoHints = currentQues.puzzles
        .where((puzzle) => !puzzle.hintShow && puzzle.currentIndex == null)
        .toList();

    if (puzzleNoHints.length > 0) {
      hintCount++;
      int indexHint = Random().nextInt(puzzleNoHints.length);
      int countTemp = 0;
      // print("hint $indexHint");

      currentQues.puzzles = currentQues.puzzles.map((puzzle) {
        if (!puzzle.hintShow && puzzle.currentIndex == null) countTemp++;

        if (indexHint == countTemp - 1) {
          puzzle.hintShow = true;
          puzzle.currentValue = puzzle.correctValue;
          puzzle.currentIndex = currentQues.arrayBtns
              .indexWhere((btn) => btn == puzzle.correctValue);
        }

        return puzzle;
      }).toList();

      // check if complete

      if (currentQues.fieldCompleteCorrect()) {
        currentQues.isDone = true;

        setState(() {});

        await Future.delayed(Duration(seconds: 1));
        generatePuzzle();
      }

      // my wrong..not refresh.. damn..haha
      setState(() {});
    }
  }

  Future<void> setBtnClick(int index) async {
    WordFindQues currentQues = listQuestions[indexQues];

    int currentIndexEmpty =
        currentQues.puzzles.indexWhere((puzzle) => puzzle.currentValue == null);

    if (currentIndexEmpty >= 0) {
      currentQues.puzzles[currentIndexEmpty].currentIndex = index;
      currentQues.puzzles[currentIndexEmpty].currentValue =
          currentQues.arrayBtns[index];

      if (currentQues.fieldCompleteCorrect()) {
        currentQues.isDone = true;

        setState(() {});

        await Future.delayed(Duration(seconds: 1));
        generatePuzzle();
      }
      setState(() {});
    }
  }
}

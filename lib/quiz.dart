/*import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:superhero_word_game/guesstheimage_questions.dart';
import 'package:superhero_word_game/quiz_questions.dart';

var finalScore = 0;
var questionNumber = 0;
var hasBeenDone =
    List<bool>.filled(multipleAnswerQuizList.length, false, growable: false);
var randomNumber = new Random();
var hintDone = List<bool>.filled(4, false, growable: false);
int hintsUsed = 0;

bool answerSelected = false;

int numberOfQuestions = multipleAnswerQuizList.length;
int questionsDone = 0;

class MultiQuiz extends StatefulWidget {
  @override
  _MultiQuiz createState() => new _MultiQuiz();
}

class _MultiQuiz extends State<MultiQuiz> {
  @override
  void initState() {
    super.initState();
    initialiseVariables();
  }

  @override
  Widget build(BuildContext context) {
    print(hintsUsed);
    print(questionsDone);
    print(numberOfQuestions);

    return new WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.black,
            title: Text("QUIZ"),
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
          body: new Container(
            color: Colors.grey,
            //child: Container(
            //margin: const EdgeInsets.all(10.0),
            alignment: Alignment.topCenter,
            child: new Column(
              children: <Widget>[
                topRow(),
                Container(
                  //padding: EdgeInsets.all(.05.sw),
                  padding: EdgeInsets.fromLTRB(.05.sw, .05.sh, .05.sw, .05.sh),
                  height: .4.sh,
                  child: new Image.asset(
                    "images/${multipleAnswerQuizList[questionNumber].image}.jpeg",
                  ),
                ),

                //Expanded(
                Container(
                  height: .1.sh,
                  padding: EdgeInsets.fromLTRB(.02.sw, 0, .02.sw, 0),
                  //height: 100,
                  child: new Text(
                    multipleAnswerQuizList[questionNumber].question,
                    textAlign: TextAlign.center,
                    style: new TextStyle(
                      fontSize: 20.0.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
                new Padding(padding: EdgeInsets.all(.01.sh)),

                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    optionButton(0),
                    optionButton(1),
                  ],
                ),

                new Padding(padding: EdgeInsets.all(.02.sh)),

                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    optionButton(2),
                    optionButton(3),
                  ],
                ),
              ],
              //),
            ),
          ),
        ));
  }

  void initialiseVariables() {
    hintsUsed = 0;
    questionsDone = 0;
    answerSelected = false;

    for (int i = 0; i < 4; i++) hintDone[i] = false;
    for (int i = 0; i < multipleAnswerQuizList.length; i++) {
      hasBeenDone[i] = false;
    }
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
              onTap: () => {}, //generatePuzzle(),
              child: Icon(
                Icons.arrow_forward_ios,
                size: 25.sp,
                color: Colors.yellow[200],
              ),
            ),
          ],
        ));
  }

  void generateHint() {
    //find correct answer from options
    int correctAnswer = 0;
    for (int i = 0; i < 4; i++) {
      if (multipleAnswerQuizList[questionNumber].correct ==
          multipleAnswerQuizList[questionNumber].options[i]) {
        correctAnswer = i;
      }
    }

    //give hint of one of the incorrect answers
    int hint = 0;
    if (hintsUsed < 3) {
      do {
        hint = randomNumber.nextInt(4);
      } while (hint == correctAnswer || hintDone[hint]);

      setState(() {
        hintsUsed++;
        hintDone[hint] = true;
      });
    }
  }

  Container optionButton(int thisNumber) {
    int correctAnswer = 0;

    for (int i = 0; i < 4; i++) {
      if (multipleAnswerQuizList[questionNumber].correct ==
          multipleAnswerQuizList[questionNumber].options[i]) {
        correctAnswer = i;
      }
    }

    //Color color = hintDone[thisNumber] ? Colors.white70 : Color(0xff7EE7FD);
    Color color = hintDone[thisNumber]
        ? Colors.white70
        : (correctAnswer == thisNumber && answerSelected)
            ? Colors.green
            : Color(0xff7EE7FD);
    return Container(
        height: .06.sh,
        width: .4.sw,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(.02.sw),
        ),
        child: MaterialButton(
          color: color,
          onPressed: () async {
            if (multipleAnswerQuizList[questionNumber].options[thisNumber] ==
                multipleAnswerQuizList[questionNumber].correct) {
              debugPrint("Correct");
              finalScore++;
            } else {
              debugPrint("Wrong");
            }
            answerSelected = true;
            setState(() {});
            await Future.delayed(Duration(seconds: 1));
            //show correct answer box green for 1 second
            hasBeenDone[questionNumber] = true;
            answerSelected = false;
            questionsDone++;
            updateQuestion();
          },
          child: new Text(
            multipleAnswerQuizList[questionNumber].options[thisNumber],
            style: new TextStyle(fontSize: 10.sp, color: Colors.black),
          ),
        ));
  }

  Future<void> updateQuestion() async {
    if (questionsDone < numberOfQuestions) {
      setState(() {
        hintsUsed = 0;
        for (int i = 0; i < 4; i++) hintDone[i] = false;

        do {
          questionNumber = randomNumber.nextInt(multipleAnswerQuizList.length);
        } while (hasBeenDone[questionNumber]);
      });
    } else {
      hintsUsed = 0;
      questionsDone = 0;
      answerSelected = false;
      for (int i = 0; i < 4; i++) hintDone[i] = false;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => Summary(score: finalScore),
        ),
      );
    }
  }
}


class Summary extends StatelessWidget {
  final int score;
  Summary({Key? key, required this.score}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: new Container(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text(
                "Final Score: $score",
                style: new TextStyle(fontSize: 35.0),
              ),
              new Padding(padding: EdgeInsets.all(30.0)),
              new MaterialButton(
                color: Colors.red,
                onPressed: () {
                  questionNumber = 0;
                  finalScore = 0;
                  Navigator.of(context)
                    ..pop()
                    ..pop();
                },
                child: new Text(
                  "Reset Quiz",
                  style: new TextStyle(fontSize: 20.0, color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
*/

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:superhero_word_game/guesstheimage_questions.dart';
import 'package:superhero_word_game/quiz_questions.dart';

class MultiQuiz extends StatefulWidget {
  @override
  _MultiQuizState createState() => _MultiQuizState();
}

class _MultiQuizState extends State<MultiQuiz> {
  final Random _random = Random();
  int _finalScore = 0;
  int _questionNumber = 0;
  int _hintsUsed = 0;
  int _questionsDone = 0;
  bool _answerSelected = false;
  List<bool> _hasBeenDone = List<bool>.filled(multipleAnswerQuizList.length, false);
  List<bool> _hintDone = List<bool>.filled(4, false);

  @override
  void initState() {
    super.initState();
    _initialiseVariables();
  }

  void _initialiseVariables() {
    _hintsUsed = 0;
    _questionsDone = 0;
    _answerSelected = false;
    _hintDone = List<bool>.filled(4, false);
    _hasBeenDone = List<bool>.filled(multipleAnswerQuizList.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.black,
          title: Text("QUIZ"),
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
          color: Colors.grey,
          alignment: Alignment.topCenter,
          child: Column(
            children: <Widget>[
              _buildTopRow(),
              _buildImage(),
              _buildQuestion(),
              _buildOptionsRow(0, 1),
              SizedBox(height: 20),
              _buildOptionsRow(2, 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopRow() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: _generateHint,
            child: Icon(
              Icons.lightbulb,
              size: 25.sp,
              color: Colors.yellow[200],
            ),
          ),
          InkWell(
            onTap: () {}, // Add functionality if needed
            child: Icon(
              Icons.arrow_forward_ios,
              size: 25.sp,
              color: Colors.yellow[200],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: .05.sw, vertical: .05.sh),
      height: .4.sh,
      child: Image.asset(
        "images/${multipleAnswerQuizList[_questionNumber].image}.jpeg",
      ),
    );
  }

  Widget _buildQuestion() {
    return Container(
      height: .1.sh,
      padding: EdgeInsets.symmetric(horizontal: .02.sw),
      child: Text(
        multipleAnswerQuizList[_questionNumber].question,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20.sp, color: Colors.white),
      ),
    );
  }

  Widget _buildOptionsRow(int index1, int index2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _buildOptionButton(index1),
        _buildOptionButton(index2),
      ],
    );
  }

  Widget _buildOptionButton(int index) {
    final correctAnswer = multipleAnswerQuizList[_questionNumber].correct;
    final isCorrect = correctAnswer == multipleAnswerQuizList[_questionNumber].options[index];
    final color = _hintDone[index]
        ? Colors.white70
        : (_answerSelected && isCorrect)
        ? Colors.green
        : Color(0xff7EE7FD);

    return Container(
      height: .06.sh,
      width: .4.sw,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(.02.sw),
      ),
      child: MaterialButton(
        color: color,
        onPressed: _hintDone[index] ? null : () => _handleAnswer(index, isCorrect),
        child: Text(
          multipleAnswerQuizList[_questionNumber].options[index],
          style: TextStyle(fontSize: 10.sp, color: Colors.black),
        ),
      ),
    );
  }

  void _generateHint() {
    final correctAnswer = multipleAnswerQuizList[_questionNumber].correct;
    final correctIndex = multipleAnswerQuizList[_questionNumber].options.indexOf(correctAnswer);

    if (_hintsUsed < 3) {
      int hintIndex;
      do {
        hintIndex = _random.nextInt(4);
      } while (hintIndex == correctIndex || _hintDone[hintIndex]);

      setState(() {
        _hintsUsed++;
        _hintDone[hintIndex] = true;
      });
    }
  }

  void _handleAnswer(int index, bool isCorrect) async {
    if (isCorrect) {
      _finalScore++;
    }

    setState(() {
      _answerSelected = true;
      _hintDone[index] = true;
    });

    await Future.delayed(Duration(seconds: 1));

    setState(() {
      _answerSelected = false;
      _questionsDone++;
      _hasBeenDone[_questionNumber] = true;
    });

    if (_questionsDone < multipleAnswerQuizList.length) {
      _updateQuestion();
    } else {
      _showSummary();
    }
  }

  void _updateQuestion() {
    setState(() {
      _hintsUsed = 0;
      _hintDone = List<bool>.filled(4, false);
      do {
        _questionNumber = _random.nextInt(multipleAnswerQuizList.length);
      } while (_hasBeenDone[_questionNumber]);
    });
  }

  void _showSummary() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Summary(score: _finalScore),
      ),
    );
  }
}

class Summary extends StatelessWidget {
  final int score;

  const Summary({Key? key, required this.score}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Final Score: $score",
                style: TextStyle(fontSize: 35.sp),
              ),
              SizedBox(height: 30),
              MaterialButton(
                color: Colors.red,
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: Text(
                  "Reset Quiz",
                  style: TextStyle(fontSize: 20.sp, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:async';

import 'package:superhero_word_game/wordsearch_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:word_search_safety/word_search_safety.dart';

class WordSearchWidget extends StatefulWidget {
  WordSearchWidget({Key key}) : super(key: key);

  @override
  _WordSearchWidget createState() => _WordSearchWidget();
}

class _WordSearchWidget extends State<WordSearchWidget> {
  Duration duration = Duration();
  Timer timer;
  int minutes = 0;
  int seconds = 0;

  int record = 0;

  int finalTime = 0;

  int correctAnswers = 0;
  int totalAnswers = 0;

  double fontSize = 10.sp;
  int numBoxPerRow = 20;
  double padding = 5;
  Size sizeBox = Size.zero;
  int numberOfWords = 0;

  double boxDimensions = 0;


  ValueNotifier<List<List<String>>> listChars;
  ValueNotifier<List<CrosswordAnswer>> answerList;
  ValueNotifier<CurrentDragObj> currentDragObj;

  ValueNotifier<List<int>> charsDone;

  @override
  void initState() {
    super.initState();
    correctAnswers = 0;
    getRecords();
    setVarsFromDifficulty();

    if (.6.sh > .97.sw){
      boxDimensions = .97.sw;}
    else{
      boxDimensions = .6.sh;
    }

    listChars = new ValueNotifier<List<List<String>>>([]);
    answerList = new ValueNotifier<List<CrosswordAnswer>>([]);
    currentDragObj = new ValueNotifier<CurrentDragObj>(new CurrentDragObj());
    charsDone = new ValueNotifier<List<int>>(new List<int>());
    generateRandomWord();
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) => addTime());
  }

  void addTime() {
    final addSeconds = 1;

    setState(() {
      seconds = duration.inSeconds + addSeconds;

      duration = Duration(seconds: seconds);
    });
  }

  void resetPuzzle() {
    correctAnswers = 0;
    setState(() {
      timer.cancel();
      duration = Duration(seconds: 0);
      startTimer();
      getRecords();
      listChars = new ValueNotifier<List<List<String>>>([]);
      answerList = new ValueNotifier<List<CrosswordAnswer>>([]);
      currentDragObj = new ValueNotifier<CurrentDragObj>(new CurrentDragObj());
      charsDone = new ValueNotifier<List<int>>(new List<int>());
      generateRandomWord();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void setVarsFromDifficulty() {
    switch (difficulty) {
      case 1:
        {
          numBoxPerRow = 9;
          fontSize = 30.sp;
          numberOfWords = 6;
          break;
        }
      case 2:
        {
          numBoxPerRow = 12;
          fontSize = 24.sp;
          numberOfWords = 9;
          break;
        }
      case 3:
        {
          numBoxPerRow = 16;
          fontSize = 18.sp;
          numberOfWords = 12;
          break;
        }
      case 4:
        {
          numBoxPerRow = 20;
          fontSize = 14.sp;
          numberOfWords = 12;
          break;
        }
    }
    totalAnswers = numberOfWords;
  }

  @override
  Widget build(BuildContext context) {
    //Size size = MediaQuery.of(context).size;
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return Scaffold(
        appBar: AppBar(
          title: Text('$minutes:$seconds'),
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
            color: Colors.grey[300],

            alignment: Alignment.center,
            child: Container(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                  Container(

                    decoration: new BoxDecoration(
                      border: Border.all(color: Colors.black),
                        color: const Color(0xff7c94b6),
                        image: new DecorationImage(
                          colorFilter: new ColorFilter.mode(
                              Colors.black.withOpacity(0.4), BlendMode.dstATop),
                          image:
                              new AssetImage('images/$categorySelection.jpeg'),
                          fit: BoxFit.cover,
                        )),

                    //color: Colors.blue,
                    alignment: Alignment.center,
                    height: boxDimensions,
                    width: boxDimensions,
                    padding: EdgeInsets.all(padding),
                    margin: EdgeInsets.all(padding),
                    child: drawCrosswordBox(),
                  ),
                  Container(
                    // alignment: Alignment.center,
                    // lets show list word we need solve
                    child: drawAnswerList(),
                  ),
                  /*ElevatedButton(
                    child: Text("Reset"),
                    onPressed: () {
                      resetPuzzle();
                    },
                  )*/
                ]))));
  }

  void onDragEnd(PointerUpEvent event) {
    print("PointerUpEvent");
    // check if drag line object got value or not.. if no no need to clear
    if (currentDragObj.value.currentDragLine == null) return;

    currentDragObj.value.currentDragLine.clear();
    currentDragObj.notifyListeners();

    checkForPuzzleComplete();
  }

  void onDragUpdate(PointerMoveEvent event) {
    // generate ondragLine so we know to highlight path later & clear if condition dont meet .. :D
    generateLineOnDrag(event);

    // get index on drag

    int indexFound = answerList.value.indexWhere((answer) {
      return answer.answerLines.join("-") ==
          currentDragObj.value.currentDragLine.join("-");
    });
print(currentDragObj.value.currentDragLine.join("-"));


    if (indexFound >= 0) {
      answerList.value[indexFound].done = true;
      correctAnswers++;
      print(correctAnswers);
      // save answerList which complete
      charsDone.value.addAll(answerList.value[indexFound].answerLines);
      charsDone.notifyListeners();
      answerList.notifyListeners();
      onDragEnd(null);
    }
  }

  void checkForPuzzleComplete() {
    if (correctAnswers == totalAnswers) {
      print("puzzle is complete");
      timer.cancel();
      finalTime = duration.inSeconds;
      print(record);
      setRecords();
      print('$finalTime was your score, the record is $record');
      showRecord();
    }
  }

  Future getRecords() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (difficulty == 1) record = prefs.getInt("easyWordSearchRecord") ?? 0;
    if (difficulty == 2) record = prefs.getInt("mediumWordSearchRecord") ?? 0;
    if (difficulty == 3) record = prefs.getInt("hardWordSearchRecord") ?? 00;
    if (difficulty == 4) record = prefs.getInt("insaneWordSearchRecord") ?? 0;

    print('record: $record');
  }

  Future setRecords() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (difficulty == 1 && (finalTime < record || record == 0))
      prefs.setInt("easyWordSearchRecord", finalTime);

    if (difficulty == 2 && (finalTime < record || record == 0))
      prefs.setInt("mediumWordSearchRecord", finalTime);

    if (difficulty == 3 && (finalTime < record || record == 0))
      prefs.setInt("hardWordSearchRecord", finalTime);

    if (difficulty == 4 && (finalTime < record || record == 0))
      prefs.setInt("insaneWordSearchRecord", finalTime);
  }

  Future<void> showRecord() async {
    int recordMinutes = record ~/ 60;
    int recordSeconds = record % 60;
    int finalTimeMinutes = finalTime ~/ 60;
    int finalTimeSeconds = finalTime % 60;

    String twoDigits(int n) => n.toString().padLeft(2, '0');

    String displayMinutes = twoDigits(finalTimeMinutes);
    String displaySeconds = twoDigits(finalTimeSeconds);
    String displayRecordMinutes = twoDigits(recordMinutes);
    String displayRecordSeconds = twoDigits(recordSeconds);

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: Colors.white,
              child: Container(
                width: .9.sw,
                height: .9.sh,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "PUZZLE FINISHED",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30.sp,
                        //color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Your time: $displayMinutes:$displaySeconds",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.sp,
                        //color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      (record <= finalTime || record == 0)
                          ? "Current record: $displayRecordMinutes:$displayRecordSeconds"
                          : "Previous record: $displayRecordMinutes:$displayRecordSeconds",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.sp,
                        //color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      (finalTime < record || record == 0)
                          ? "Well done, you have the new record!"
                          : "",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30.sp,
                        //color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ElevatedButton(
                      child: Text("CONTINUE"),
                      onPressed: () {
                        Navigator.of(context)
                          ..pop()
                          ..pop();
                      },
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(10.0),
                alignment: Alignment.center,
              ),
            );
          },
        );
      },
    );
  }

  int calculateIndexBasePosLocal(Offset localPosition) {
    // get size max per box
    double maxSizeBox =
    //    ((sizeBox.width - (numBoxPerRow - 1) * padding) / numBoxPerRow);
        ((boxDimensions - (numBoxPerRow - 1) * padding) / numBoxPerRow);

    if (localPosition.dy > sizeBox.width || localPosition.dx > sizeBox.width)
      return -1;

    int x = 0, y = 0;
    double yAxis = 0, xAxis = 0;
    double yAxisStart = 0, xAxisStart = 0;

    for (var i = 0; i < numBoxPerRow; i++) {
      xAxisStart = xAxis;
      xAxis += maxSizeBox +
          (i == 0 || i == (numBoxPerRow - 1) ? padding / 2 : padding);

      if (xAxisStart < localPosition.dx && xAxis > localPosition.dx) {
        x = i;
        break;
      }
    }

    for (var i = 0; i < numBoxPerRow; i++) {
      yAxisStart = yAxis;
      yAxis += maxSizeBox +
          (i == 0 || i == (numBoxPerRow - 1) ? padding / 2 : padding);

      if (yAxisStart < localPosition.dy && yAxis > localPosition.dy) {
        y = i;
        break;
      }
    }

    return y * numBoxPerRow + x;
  }

  void generateLineOnDrag(PointerMoveEvent event) {
    // if current drag line is null, dlcare new list for we can save value
    if (currentDragObj.value.currentDragLine == null)
      currentDragObj.value.currentDragLine = new List<int>();

    // we need calculate index array base local position on drag
    int indexBase = calculateIndexBasePosLocal(event.localPosition);

    if (indexBase >= 0) {
      // check drag line already pass 2 box
      if (currentDragObj.value.currentDragLine.length >= 2) {
        // check drag line is straight line
        WSOrientation wsOrientation;

        if (currentDragObj.value.currentDragLine[0] % numBoxPerRow ==
            currentDragObj.value.currentDragLine[1] % numBoxPerRow)
          wsOrientation =
              WSOrientation.vertical; // this should vertical.. my mistake.. :)
        else if (currentDragObj.value.currentDragLine[0] ~/ numBoxPerRow ==
            currentDragObj.value.currentDragLine[1] ~/ numBoxPerRow)
          wsOrientation = WSOrientation.horizontal;

        if (wsOrientation == WSOrientation.horizontal) {
          if (indexBase ~/ numBoxPerRow !=
              currentDragObj.value.currentDragLine[1] ~/ numBoxPerRow)
            onDragEnd(null);
        } else if (wsOrientation == WSOrientation.vertical) {
          if (indexBase % numBoxPerRow !=
              currentDragObj.value.currentDragLine[1] % numBoxPerRow)
            onDragEnd(null);
        } else
          onDragEnd(null);
      }

      if (!currentDragObj.value.currentDragLine.contains(indexBase))
        currentDragObj.value.currentDragLine.add(indexBase);
      else if (currentDragObj.value.currentDragLine.length >=
          2) if (currentDragObj.value.currentDragLine[
              currentDragObj.value.currentDragLine.length - 2] ==
          indexBase) onDragEnd(null);
    }
    // before mistake , should in here
    currentDragObj.notifyListeners();
  }

  void onDragStart(int indexArray) {
    try {
      List<CrosswordAnswer> indexSelecteds = answerList.value
          .where((answer) => answer.indexArray == indexArray)
          .toList();

      // check indexSelecteds got any match , if 0 no proceed!
      if (indexSelecteds.length == 0) return;
      // nice triggered
      currentDragObj.value.indexArrayOnTouch = indexArray;
      currentDragObj.notifyListeners();
    } catch (e) {}
  }

  // nice one

  Widget drawCrosswordBox() {
    // add listener tp catch drag, push down & up
    return Listener(
      onPointerUp: (event) => onDragEnd(event),
      onPointerMove: (event) => onDragUpdate(event),
      child: LayoutBuilder(
        builder: (context, constraints) {
          //sizeBox = Size(constraints.maxWidth, constraints.maxWidth);
          sizeBox = Size(.7.sh, .7.sh);
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 1,
              crossAxisCount: numBoxPerRow,
              crossAxisSpacing: padding,
              mainAxisSpacing: padding,
            ),
            itemCount: numBoxPerRow * numBoxPerRow,
            physics: ScrollPhysics(),
            itemBuilder: (context, index) {
              // we need expand because to merge 2d array to become 1..
              // example [["x","x"],["x","x"]] become ["x","x","x","x"]
              String char = listChars.value.expand((e) => e).toList()[index];

              // yeayy.. now we got crossword box.. easy right!!
              // later i will show how to display current word on crossword
              // next show color path on box when drag, we will using Valuelistener
              // done .. yeayy.. this is simple crossword system
              return Listener(
                onPointerDown: (event) => onDragStart(index),
                child: ValueListenableBuilder(
                  valueListenable: currentDragObj,
                  builder: (context, CurrentDragObj value, child) {
                    Color color;

                    if (value.currentDragLine.contains(index))
                      color = Colors
                          .white24; // change color when path line is contain index
                    else if (charsDone.value.contains(index))
                      color = Colors
                          .blueGrey; // change color box already path correct

                    return Container(
                      decoration: BoxDecoration(
                        color: color,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        char.toUpperCase(),
                        style: TextStyle(
                            fontSize: getFontSize(), fontWeight: FontWeight.bold),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  void generateRandomWord() {
    int maxCount = numberOfWords;

    final List<String> words = getWords(categorySelection);

    List<String> wl = [];

    for (int i = 0; i < maxCount; i++) {
      wl.add(words[i]);
    }

    // setup configuration to generate crossword

    // Create the puzzle sessting object
    final WSSettings ws = WSSettings(
      width: numBoxPerRow,
      height: numBoxPerRow,
      orientations: List.from([
        WSOrientation.horizontal,
        WSOrientation.horizontalBack,
        WSOrientation.vertical,
        WSOrientation.verticalUp,
        // WSOrientation.diagonal,
        // WSOrientation.diagonalUp,
      ]),
    );

    // Create new instance of the WordSearch class
    final WordSearch wordSearch = WordSearch();

    // Create a new puzzle
    final WSNewPuzzle newPuzzle = wordSearch.newPuzzle(wl, ws);

    /// Check if there are errors generated while creating the puzzle
    if (newPuzzle.errors.isEmpty) {
      // if no error.. proceed

      // List<List<String>> charsArray = newPuzzle.puzzle;
      listChars.value = newPuzzle.puzzle;
      // done pass..ez

      // Solve puzzle for given word list
      final WSSolved solved = wordSearch.solvePuzzle(newPuzzle.puzzle, wl);

      answerList.value = solved.found
          .map((solve) => new CrosswordAnswer(solve, numPerRow: numBoxPerRow))
          .toList();
    }
  }

  drawAnswerList() {
    return Container(
      height: .25.sh,
      child: ValueListenableBuilder(
        valueListenable: answerList,
        builder: (context, List<CrosswordAnswer> value, child) {
          // lets make custom widget using Column & Row

          // how many row child we want show per row?
          int perColTotal = 3;

          // generate using list.generate
          List<Widget> list = List.generate(
              (value.length ~/ perColTotal) +
                  ((value.length % perColTotal) > 0 ? 1 : 0), (int index) {
            int maxColumn = (index + 1) * perColTotal;

            return Container(
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Row(
                // generate child row per row
                // all close on each other.. let make row child distance equally
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                    maxColumn > value.length
                        ? maxColumn - value.length
                        : perColTotal, ((indexChild) {
                  // forgot to declare array for access answerList
                  int indexArray = (index) * perColTotal + indexChild;

                  return Container(
                    width: .3.sw,
                    child: Text(
                      // make text more clearly to read
                      "${value[indexArray].wsLocation.word}".toUpperCase(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: getAnswersFontSize(),
                        color: value[indexArray].done
                            ? Colors.green
                            : Colors.black,
                        decoration: value[indexArray].done
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                  );
                })).toList(),
              ),
            );
          }).toList();

          return Container(
            child: Column(
              children: list,
            ),
          );
        },
      ),
    );
  }

  getFontSize() {
    switch (difficulty){
      case 1:
        return 20.sp;
      case 2:
        return 16.sp;
      case 3:
        return 14.sp;
      case 4:
        return 12.sp;
    }
  }

  getAnswersFontSize() {
    switch (difficulty){
      case 1:
        return 16.sp;
      case 2:
        return 16.sp;
      case 3:
        return 12.sp;
      case 4:
        return 12.sp;
    }
  }
}

class CurrentDragObj {
  Offset currentDragPos;
  Offset currentTouch;
  int indexArrayOnTouch;
  List<int> currentDragLine = new List<int>();

  CurrentDragObj({
    this.indexArrayOnTouch,
    this.currentTouch,
  });
}

class CrosswordAnswer {
  bool done = false;
  int indexArray;
  WSLocation wsLocation;
  List<int> answerLines;

  CrosswordAnswer(this.wsLocation, {int numPerRow}) {
    this.indexArray = this.wsLocation.y * numPerRow + this.wsLocation.x;
    generateAnswerLine(numPerRow);
  }

  // get answer index for each character word
  void generateAnswerLine(int numPerRow) {
    // declare new list<int>
    this.answerLines = new List<int>();

    // push all index based base word array
    this.answerLines.addAll(List<int>.generate(this.wsLocation.overlap,
        (index) => generateIndexBaseOnAxis(this.wsLocation, index, numPerRow)));
  }

// calculate index base axis x & y
  generateIndexBaseOnAxis(WSLocation wsLocation, int i, int numPerRow) {
    int x = wsLocation.x, y = wsLocation.y;

    if (wsLocation.orientation == WSOrientation.horizontal ||
        wsLocation.orientation == WSOrientation.horizontalBack)
      x = (wsLocation.orientation == WSOrientation.horizontal) ? x + i : x - i;
    else
      y = (wsLocation.orientation == WSOrientation.vertical) ? y + i : y - i;

    return x + y * numPerRow;
  }
}

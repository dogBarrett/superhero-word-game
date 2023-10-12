/*import 'package:superhero_word_game/wordsearch_widget.dart';
import 'package:superhero_word_game/quiz.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'guesstheimage.dart';
import 'main_menu.dart';
import 'wordsearch_menu.dart';

// @dart=2.9
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        //designSize: const Size(414.0, 896.0),
        //builder: () => MaterialApp(
        builder: (context , child) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blueGrey,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      //home: MyHomePage(title: 'Simple Crossword Game'),
      home: MainMenu(),
    );
  });
}}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        alignment: Alignment.center,
        child: WordSearchMenu(),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
*/

import 'dart:math';

import 'package:crossword/components/line_decoration.dart';
import 'package:crossword/crossword.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crossword Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const GamePage(),
    );
  }
}

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  List<List<String>> letters = [];
  List<Color> lineColors = [];

  List<int> letterGrid = [11, 14];

  List<List<String>> generateRandomLetters() {
    final random = Random();
    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    List<List<String>> array = List.generate(
        letterGrid.first,
            (_) => List.generate(
            letterGrid.last, (_) => letters[random.nextInt(letters.length)]));

    return array;
  }

  Color generateRandomColor() {
    Random random = Random();

    int r = random.nextInt(200) - 128; // Red component between 128 and 255
    int g = random.nextInt(200) - 128; // Green component between 128 and 255
    int b = random.nextInt(200) - 128; // Blue component between 128 and 255

    return Color.fromARGB(255, r, g, b);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    lineColors = List.generate(100, (index) => generateRandomColor()).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Crossword(

          letters: const [
            ["F", "L", "U", "T", "T", "E", "R", "W", "U", "D", "B", "C"],
            ["R", "M", "I", "O", "P", "U", "I", "Q", "R", "L", "E", "G"],
            ["T", "V", "D", "I", "R", "I", "M", "U", "A", "H", "E", "A"],
            ["D", "A", "R", "T", "N", "S", "T", "O", "Y", "J", "R", "M"],
            ["O", "G", "A", "M", "E", "S", "C", "O", "L", "O", "R", "O"],
            ["S", "R", "T", "I", "I", "I", "F", "X", "S", "P", "E", "D"],
            ["Y", "S", "N", "E", "T", "M", "M", "C", "E", "A", "T", "S"],
            ["W", "E", "T", "P", "A", "T", "D", "Y", "L", "M", "N", "U"],
            ["O", "T", "E", "H", "R", "O", "G", "P", "T", "U", "O", "E"],
            ["K", "R", "R", "C", "G", "A", "M", "E", "S", "S", "T", "S"],
            ["S", "E", "S", "T", "L", "A", "O", "P", "U", "P", "E", "S"]
          ],
          spacing: const Offset(30, 30),
          onLineDrawn: (List<String> words) {},
          textStyle: const TextStyle(color: Colors.white, fontSize: 20),
          lineDecoration:
          LineDecoration(lineColors: lineColors, strokeWidth: 20),
          hints: const ["FLUTTER", "GAMES", "UI", "COLORS"],
        ));
  }
}
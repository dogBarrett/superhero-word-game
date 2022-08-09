import 'dart:core';

import 'package:superhero_word_game/quiz.dart';
import 'package:superhero_word_game/sudoku/main.dart';
import 'package:superhero_word_game/wordsearch_menu.dart';
import 'package:superhero_word_game/wordsearch_widget.dart';
import 'package:superhero_word_game/wordsearch_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'guesstheimage.dart';
class MainMenu extends StatefulWidget {
  @override
  _MainMenu createState() => new _MainMenu();
}

class _MainMenu extends State<MainMenu> {
  @override
  Widget build(BuildContext context) {
    //var appBarHeight = AppBar().preferredSize.height;
    //var paddingTop = MediaQuery.of(context).padding.top;
    return new Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.black,
          title: Text(""),
        ),
        body: Container(
            width: 1.sw,
            height: 1.sh,
            color: Colors.black,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 0.8.sh,
                    width: 0.97.sw,
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          button("Word Search", "wordsearch"),
                          button("Guess the Image", "guesstheimage"),
                          button("Quiz", "quiz"),
                          button("Sudoku", "sudoku"),
                        ],
                      ),
                      //padding: EdgeInsets.only(left: 0.02.sh, right: 0.02.sh),
                    ),
                  ),
                ])));
  }

  GestureDetector button(String title, String text) {
    return GestureDetector(
      onTap: () {
        switch (text) {
          case "wordsearch":
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => WordSearchMenu(),
              ),
            );
            break;
          case "guesstheimage":
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => WordFind(),
              ),);

            break;
          case "quiz":
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => MultiQuiz(),
              ),
            );
            break;
          case "sudoku":
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => Sudoku(),
              ),
            );
            break;
        }
      },
      child: getTile(title, text),
    );
  }

  Container getTile(String thisTitle, String imageFile) {
    imageFile = "images/${imageFile}.jpeg";

    return Container(
      height: 0.2.sh,
      width: 1.sw,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(1),
        borderRadius: BorderRadius.circular(0.02.sw),
      ),
      margin: EdgeInsets.only(bottom: 0.01.sh),
      child: Stack(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(0.02.sw),
            child: Container(
              height: 0.4.sh,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(imageFile),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.6),
                    BlendMode.srcOver,
                  ),
                ),
              ),
              width: 1.sw,
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              height: 0.2.sh,
              width: 1.sw,
              margin: EdgeInsets.only(
                left: 0.05.sw,
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: <Widget>[
                    Text(
                      thisTitle.toUpperCase(),
                      style: TextStyle(
                        fontSize: 18.sp,
                        letterSpacing: 0.3,
                        wordSpacing: 1,
                        color: Colors.white,
                      ),
                    ),
                  ]),
            ),
          )
        ],
      ),
    );
  }
}

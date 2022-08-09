import 'dart:core';

import 'package:superhero_word_game/wordsearch_widget.dart';
import 'package:superhero_word_game/wordsearch_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WordSearchMenu extends StatefulWidget {
  @override
  _WordSearchMenu createState() => new _WordSearchMenu();
}

class _WordSearchMenu extends State<WordSearchMenu> {
  @override
  Widget build(BuildContext context) {
    var appBarHeight = AppBar().preferredSize.height;
    var paddingTop = MediaQuery.of(context).padding.top;
    return new Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.black,
          title: Text("WORDSEARCH"),
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
            width: 1.sw,
            height: 1.sh,
            color: Colors.black,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        difficultyButton("Easy", 1),
                        difficultyButton("Medium", 2),
                        difficultyButton("Hard", 3),
                        difficultyButton("Insane", 4),
                      ]),
                  Container(
                    height: .75.sh,
                    width: .97.sw,
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          button("Avengers", "avengers"),
                          button("Batman", "batman"),
                          button("Black Panther", "blackpanther"),
                          button("Captain America", "captainamerica"),
                          button("Eternals", "eternals"),
                          button("Iron Man", "ironman"),
                          button("Justice League", "justiceleague"),
                          button("Guardians of the Galaxy",
                              "guardiansofthegalaxy"),
                          button("Spider Man", "spiderman_movie"),
                          button("Superman", "superman"),
                          button("Thor", "thor"),
                          button("Venom", "venom"),
                        ],
                      ),
                    ),
                  ),
                ])));
  }

  SizedBox difficultyButton(String text, int level) {
    return SizedBox(
        height: .05.sh,
        width: .23.sw,
        child: ElevatedButton(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 10.sp,
            ),
          ),
          onPressed: () {
            difficulty = level;
            setState(() {});
          },
          style: difficulty != level
              ? ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white24))
              : ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blueGrey)),
        ));
  }

  GestureDetector button(String title, String text) {
    return GestureDetector(
      onTap: () {
        categorySelection = text;
        openCrossword();
      },
      child: getTile(title, text),
    );
  }

  void openCrossword() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => WordSearchWidget(),
      ),
    );
  }

  Container getTile(String thisTitle, String imageFile) {
    imageFile = "images/${imageFile}.jpeg";

    return Container(
      height: 0.1.sh,
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
              width: 1.sw,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(imageFile),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.5),
                    BlendMode.srcOver,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              height: 0.1.sh,
              width: 1.sw,
              margin: EdgeInsets.only(left: 0.05.sw),
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
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mangavocabulometer/screens/AuthTestPage.dart';
import 'package:mangavocabulometer/screens/FlashCard_B.dart';
import 'package:mangavocabulometer/screens/Flashcard.dart';
import 'package:mangavocabulometer/screens/HomePage.dart';
import 'package:mangavocabulometer/screens/ReviewHome.dart';
import 'package:mangavocabulometer/screens/ReviewHomeB.dart';
import 'package:mangavocabulometer/screens/ReviewSetA.dart';
import 'package:mangavocabulometer/screens/ReviewSetB.dart';
import 'package:mangavocabulometer/screens/User_Information.dart';

class BottomTabBar extends StatefulWidget {
  @override
  BottomTabBarState createState() => BottomTabBarState();
}

class BottomTabBarState extends State<BottomTabBar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
          border: Border(top: BorderSide(width: 1.0)),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.import_contacts),
              title: Text('Home'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.create),
              title: Text('setA'),
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.create), title: Text("setB")),
            BottomNavigationBarItem(
                icon: Icon(Icons.font_download), title: Text("test"))
          ]),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return CupertinoTabView(
              builder: (context) {
                return CupertinoPageScaffold(
                  //画面上部にバーが出てくる
                  /*navigationBar: CupertinoNavigationBar(
                  leading: Icon(Icons.book),
                ),*/
                  child: HomePage(),
                );
              },
            );
          case 1:
            return CupertinoTabView(
              builder: (context) {
                return CupertinoPageScaffold(
                  /*navigationBar: CupertinoNavigationBar(
                  leading: Icon(Icons.card_giftcard),
                ),*/
                  child: ReviewHome(),
                );
              },
            );
          case 2:
            return CupertinoTabView(
              builder: (context) {
                return CupertinoPageScaffold(
                  child: ReviewHomeB(),
                );
              },
            );
          case 3:
            return CupertinoTabView(
              builder: (context) {
                return CupertinoPageScaffold(
                  child: AuthTestPage(),
                );
              },
            );
          /* default:
            return CupertinoTabView( builder: (context) {
              return CupertinoPageScaffold(
                navigationBar: CupertinoNavigationBar(
                  leading: Icon(Icons.book),
                ),
                child: new HomePage(),
              );
            },);*/
        }
      },
    );
  }
}

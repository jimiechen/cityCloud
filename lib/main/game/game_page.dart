import 'package:cityCloud/expanded/cubit/global_cubit.dart';
import 'package:cityCloud/main/empty_page.dart';
import 'package:cityCloud/router/router.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'custom_game.dart';

class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  CustomGame _box2dGame;

  @override
  void initState() {
    super.initState();
    // _box2dComponent = MyBox2D();
    _box2dGame = CustomGame();
    GlobalCubit().listen((cubitState) {
      if (cubitState is GlobalTapOnPersionSpriteRemider) {
        ///点击了小人头部提示
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: Text('点击了小人头上的提示'),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text(
                    '确定',
                    style: TextStyle(decoration: TextDecoration.none, fontSize: 16),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _box2dGame.widget,
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                FlatButton(
                  color: Colors.red,
                  onPressed: () {
                    _box2dGame.randomAddPerson();
                  },
                  child: Text('添加小人'),
                ),
                FlatButton(
                  color: Colors.red,
                  onPressed: () {
                    _box2dGame.randomAddCar();
                  },
                  child: Text('添加小车'),
                ),
                FlatButton(
                  color: Colors.red,
                  onPressed: () {
                    Navigator.push(context, Router.routeForPage(page: EmptyPage()));
                  },
                  child: Text('跳到空白页'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
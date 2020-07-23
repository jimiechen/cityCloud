import 'package:cityCloud/expanded/cubit/global_cubit.dart';
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
    return _box2dGame.widget;
  }
}

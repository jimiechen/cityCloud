import 'package:cityCloud/expanded/cubit/global_cubit.dart';
import 'package:cityCloud/main/game/custom_game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CustomGame _box2dGame = CustomGame();
  @override
  void initState() {
    super.initState();
    // _box2dComponent = MyBox2D();
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
      ],
    ));
  }
}

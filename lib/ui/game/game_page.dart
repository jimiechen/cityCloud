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
  }

  @override
  Widget build(BuildContext context) {
    return _box2dGame.widget;
  }
}

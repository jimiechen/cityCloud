import 'package:flame/flame.dart';
import 'package:flutter/material.dart';

import '../game/game_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    ['map_tile_0.png', 'people-body-5.png', 'people-eyes-1005.png', 'people-face-1001.png', 'people-hair-2.png', 'people-hand-2.png', 'people-headb-1.png', 'people-leg-5.png']
        .forEach((element) {
      Flame.images.load(element);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('游戏'),
      ),
      body: Column(
        children: <Widget>[
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => GamePage()));
            },
            child: Container(
              color: Colors.red,
              height: 40,
              child: Text('跳转到游戏界面'),
            ),
          ),
        ],
      ),
    );
  }
}

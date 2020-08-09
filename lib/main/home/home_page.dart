import 'package:cityCloud/router/router.dart';
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
    Flame.images.loadAll([
      'map_tile_0.png',
      'excavator_back.png',
      'excavator_back_shadow.png',
      'excavator_front.png',
      'excavator_front_shadow.png',
      'excavator_side.png',
      'excavator_side_shadow.png',
      'map_tile_view_0.png',
      'map_tile_view_1.png',
    ]);
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
              Navigator.push(context, Router.routeForPage(page: GamePage()));
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

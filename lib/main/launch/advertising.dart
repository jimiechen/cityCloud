import 'dart:async';

import 'package:cityCloud/main/home/home_page.dart';
import 'package:cityCloud/router/router.dart';
import 'package:cityCloud/styles/color_helper.dart';
import 'package:flutter/material.dart';

class AdvertisingPage extends StatefulWidget {
  @override
  _AdvertisingPageState createState() => _AdvertisingPageState();
}

class _AdvertisingPageState extends State<AdvertisingPage> {
  StreamController<int> streamController = StreamController<int>();
  Timer _timer;
  int _count = 3;
  @override
  void initState() {
    super.initState();
    streamController.add(_count);
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _count--;
      if (_count <= 0) {
        gotoHomePage();
      } else {
        streamController.add(_count);
      }
    });
  }

  void gotoHomePage() {
    _timer.cancel();
    streamController.close();
    // Navigator.pushAndRemoveUntil(
    //     context,
    //     Router.routeForPage(
    //       page: HomePage(),
    //     ),
    //     (_) => false);
    Navigator.push(
      context,
      Router.routeForPage(
        page: HomePage(),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
    streamController.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 15 + MediaQuery.of(context).padding.top,
            right: 10,
            child: SizedBox(
              width: 64,
              height: 30,
              child: FlatButton(
                padding: const EdgeInsets.all(0),
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(width: 1, color: ColorHelper.DividerColor),
                ),
                onPressed: () {
                  gotoHomePage();
                },
                child: StreamBuilder(
                  stream: streamController.stream,
                  builder: (context, snapshot) {
                    return Text(
                      '跳过 ${snapshot.data}',
                      style: TextStyle(fontSize: 14),
                    );
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

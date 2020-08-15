import 'dart:math';

import 'package:cityCloud/styles/color_helper.dart';
import 'package:cityCloud/styles/custom_style.dart';
import 'package:cityCloud/widgets/sawtooth_widget.dart';
import 'package:flutter/material.dart';

class HomeMenuPage extends StatefulWidget {
  @override
  _HomeMenuPageState createState() => _HomeMenuPageState();
}

class _HomeMenuPageState extends State<HomeMenuPage> with SingleTickerProviderStateMixin {
  TransformationController _transformationController = TransformationController();
  double _startTapY;
  AnimationController _animationController;
  double _startTapAnimationValue;
  double _interactiveViewMinHeight = 100;
  double _interactiveViewExtentedHeight = 0;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 200),
      reverseDuration: Duration(milliseconds: 200),
      vsync: this,
      value: 0,
    );
    // double bottomPadding = MediaQuery.of(context).padding.bottom;
    // print(bottomPadding);
  }

  Iterable<Widget> menuContent() sync* {
    yield Container(
      height: 50,
      alignment: Alignment.center,
      child: Text.rich(
        TextSpan(
          children: [
            WidgetSpan(
                child: Icon(
              Icons.bookmark_border,
              size: 18,
              color: ColorHelper.DividerColor,
            )),
            TextSpan(
              text: '记录今天的第一个动态',
              style: TextStyle(
                color: Color(0xFF555555),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double bottomPadding = MediaQuery.of(context).padding.bottom;
    _interactiveViewExtentedHeight = MediaQuery.of(context).size.height - bottomPadding - 60 - _interactiveViewMinHeight - MediaQuery.of(context).padding.top - 40;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        AnimatedBuilder(
          animation: _animationController,
          child: InteractiveViewer(
            transformationController: _transformationController,
            onInteractionStart: (detail) {
              _startTapY = detail.localFocalPoint.dy;
              _startTapAnimationValue = _animationController.value;
            },
            onInteractionUpdate: (detail) {
              _animationController.value = _startTapAnimationValue + min((_startTapY - detail.localFocalPoint.dy) / _interactiveViewExtentedHeight, 1 - _startTapAnimationValue);
            },
            onInteractionEnd: (detial) {
              if (_animationController.value > _startTapAnimationValue) {
                ///手势向上
                if (_animationController.value > 0.2) {
                  _animationController.forward();
                } else {
                  _animationController.reverse();
                }
              } else {
                ///手势向下
                if (_animationController.value > 0.8) {
                  _animationController.forward();
                } else {
                  _animationController.reverse();
                }
              }
            },
            child: Column(children: [
              SizedBox(
                height: 9,
                width: BoxConstraints.expand().maxWidth,
                child: SawtoothWidget(
                  xStep: 8,
                  color: ColorHelper.ColorF2,
                ),
              ),
              Container(
                height: 40,
                color: ColorHelper.ColorF2,
                child: Row(
                  children: [
                    Spacer(),
                    Container(
                      alignment: Alignment.center,
                      height: 26,
                      width: 100,
                      decoration: BoxDecoration(
                        color: ColorHelper.ColorEB,
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Text(
                        '今日',
                        style: TextStyle(color: ColorHelper.ThemeColor),
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ),
              Divider(
                height: 1,
                thickness: 1,
                color: ColorHelper.DividerColor,
              ),
              Expanded(
                child: Container(
                  color: ColorHelper.ColorF2,
                  child: ListView(
                    physics: ClampingScrollPhysics(),
                    padding: const EdgeInsets.all(0),
                    children: [
                      ...menuContent(),
                    ],
                  ),
                ),
              ),
            ]),
          ),
          builder: (_, child) {
            return SizedBox(
              height: _interactiveViewExtentedHeight * _animationController.value + _interactiveViewMinHeight,
              width: BoxConstraints.expand().maxWidth,
              child: child,
            );
          },
        ),
        Container(
          height: 60 + bottomPadding,
          padding: EdgeInsets.only(left: 12, right: 12, bottom: bottomPadding),
          decoration: BoxDecoration(
            boxShadow: CustomStyle.defaultBoxShadow,
            color: ColorHelper.ColorE7,
          ),
          child: Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.menu,
                  size: 30,
                  color: Color(0xFF555555),
                ),
                onPressed: () {},
              ),
              Spacer(),
              IconButton(
                icon: Icon(
                  Icons.control_point,
                  size: 38,
                  color: Color(0xFF555555),
                ),
                onPressed: () {},
              ),
              Spacer(),
              IconButton(
                icon: Icon(
                  Icons.person_outline,
                  size: 30,
                  color: Color(0xFF555555),
                ),
                onPressed: () {},
              ),
            ],
          ),
        )
      ],
    );
  }
}

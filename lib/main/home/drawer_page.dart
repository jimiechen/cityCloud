import 'dart:async';

import 'package:cityCloud/r.dart';
import 'package:cityCloud/styles/color_helper.dart';
import 'package:flutter/material.dart';

class DrawerPage extends StatefulWidget {
  @override
  _DrawerPageState createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> with TickerProviderStateMixin {
  List<String> _titleList = [
    '订单',
    '安全',
    '钱包',
    '客服',
    '设置',
  ];
  AnimationController _animationController;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 200,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      color: Colors.white,
      child: SafeArea(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (_, __) {
            return Stack(
              children: [
                Column(
                  children: [
                    SizedBox(height: 180),
                    ..._titleList.map(
                      (e) => GestureDetector(
                        onTap: () {
                          print('tap on:$e');
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          height: 48,
                          color: Colors.white,
                          child: Row(
                            children: [
                              Icon(Icons.message),
                              SizedBox(width: 8),
                              Text(e),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Spacer(),
                    Divider(height: 1),
                    Container(
                      height: 45,
                      alignment: Alignment.center,
                      child: Text('法律条款与平台规则 >'),
                    ),
                  ],
                ),
                AnimatedBuilder(
                    animation: _animationController,
                    builder: (_, __) {
                      return Positioned(
                        top: 25 - _animationController.value * 10,
                        height: 50,
                        child: Row(
                          children: [
                            Image.asset(
                              R.assetsImagesPeopleHair5,
                              width: 40,
                              height: 40,
                            ),
                            Text('吉祥鸟'),
                          ],
                        ),
                      );
                    }),
                Container(
                  margin: EdgeInsets.only(top: 80, left: 16, right: 16),
                  height: 58,
                  decoration: BoxDecoration(
                    color: Colors.yellow[600],
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 115, left: 16, right: 16),
                  height: 58,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[900],
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 50, bottom: 46),
                  child: _GridContent(
                    animationController: _animationController,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _GridContent extends StatefulWidget {
  final AnimationController animationController;

  const _GridContent({Key key, @required this.animationController}) : super(key: key);
  @override
  __GridContentState createState() => __GridContentState();
}

class __GridContentState extends State<_GridContent> with TickerProviderStateMixin {
  List<String> _titleList = [
    '推荐有奖',
    '车主招募',
    '学生中心',
    '优惠商城',
    '积分商城',
    '权益抽奖',
    '暂时空',
    '暂时空',
    '暂时空',
    '暂时空',
    '暂时空',
    '暂时空',
    '暂时空',
    '暂时空',
    '暂时空',
    '暂时空',
    '暂时空',
    '暂时空',
    '暂时空',
    '暂时空',
    '暂时空',
    '暂时空',
    '暂时空',
    '暂时空',
    '暂时空',
  ];
  ScrollController _scrollController = ScrollController();
  double _scrollStartOffset = 0;

  void scrollTo(double offset) {
    Timer.run(() {
      _scrollController.animateTo(offset, duration: Duration(milliseconds: 100), curve: Curves.linear);
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, boxconstraints) {
      double topSpace = boxconstraints.maxHeight - 190;
      return NotificationListener(
        onNotification: (notification) {
          print(notification);
          if (notification is ScrollStartNotification) {
            _scrollStartOffset = _scrollController.offset;
          } else if (notification is ScrollUpdateNotification) {
            if (notification.dragDetails == null) {
              if (_scrollController.offset < topSpace && _scrollController.offset > 0) {
                if ((_scrollStartOffset - topSpace).abs() < 1) {
                  widget.animationController?.reverse();
                  scrollTo(0);
                } else if (_scrollStartOffset.abs() < 1) {
                  widget.animationController?.forward();
                  scrollTo(topSpace);
                }
              }
            }
          } else if (notification is ScrollEndNotification) {
            if (_scrollController.offset < topSpace && _scrollController.offset > 0) {
              if (_scrollStartOffset > topSpace) {
                widget.animationController?.reverse();
                scrollTo(0);
              } else {
                widget.animationController?.forward();
                scrollTo(topSpace);
              }
            }
          }
          return true;
        },
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: SizedBox(
                height: topSpace,
              ),
            ),
            SliverToBoxAdapter(
              child: GestureDetector(
                onTap: () {
                  widget.animationController?.forward();
                  scrollTo(topSpace);
                },
                child: Container(
                  height: 30,
                  color: Colors.white,
                  alignment: Alignment.center,
                  child: Icon(Icons.arrow_drop_up),
                ),
              ),
            ),
            SliverGrid.count(
              crossAxisCount: 3,
              children: _titleList
                  .map(
                    (e) => Container(
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(Icons.local_activity),
                          Text(
                            e,
                            style: TextStyle(fontSize: 13, color: ColorHelper.Black153),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      );
    });
  }
}

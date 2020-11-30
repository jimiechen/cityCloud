import 'dart:async';
import 'dart:math';

import 'package:cityCloud/dart_class/class/commond_cubit.dart';
import 'package:cityCloud/r.dart';
import 'package:cityCloud/styles/color_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  double opacityValueForAnimation() {
    return _animationController.value > 0.5 ? 0 : (1 - _animationController.value * 2);
  }

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
                      top: 25 - _animationController.value * 20,
                      left: _animationController.value * 108,
                      height: 50,
                      child: Row(
                        children: [
                          Image.asset(
                            R.assetsImagesPeopleHair5,
                            width: 40,
                            height: 40,
                          ),
                          Opacity(
                            opacity: opacityValueForAnimation(),
                            child: Text('吉祥鸟'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (_, __) {
                    return Container(
                      margin: EdgeInsets.only(top: 80 - _animationController.value * 12, left: 16, right: 16),
                      height: 58,
                      decoration: BoxDecoration(
                        color: Colors.yellow[600].withOpacity(opacityValueForAnimation()),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    );
                  },
                ),
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (_, __) {
                    return Container(
                      margin: EdgeInsets.only(top: 115 - _animationController.value * 12, left: 16, right: 16),
                      height: 58,
                      decoration: BoxDecoration(
                        color: Colors.blueGrey[900].withOpacity(opacityValueForAnimation()),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    );
                  },
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
  CommondCubit<bool> _topSpaceOpenCubit = CommondCubit<bool>(true);
  bool _gridViewIsOpenWhenStartScroll = false;

  ///是否代码控制滚动的
  bool _isCodeControlScroll = false;

  void scrollTo(double offset) {
    Timer.run(() {
      _isCodeControlScroll = true;
      _scrollController.animateTo(offset, duration: Duration(milliseconds: 200), curve: Curves.linear).whenComplete(() => _isCodeControlScroll = false);
    });
  }

  void reset(double topSpace) {
    if (_isCodeControlScroll) return;
    if (_topSpaceOpenCubit.state && _scrollController.offset < topSpace && _scrollController.offset > 0) {
      if (_gridViewIsOpenWhenStartScroll) {
        scrollTo(0);
      } else {
        scrollTo(topSpace);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, boxconstraints) {
      double topSpace = boxconstraints.maxHeight - 170;
      return NotificationListener(
        onNotification: (notification) {
          print(notification);
          if (notification is ScrollStartNotification) {
            _gridViewIsOpenWhenStartScroll = !_topSpaceOpenCubit.state || _scrollController.offset >= topSpace;
          } else if (notification is ScrollUpdateNotification) {
            if (_topSpaceOpenCubit.state && _scrollController.offset < topSpace && _scrollController.offset > 0) {
              widget.animationController.value = _scrollController.offset / topSpace;
            }
            if (notification.dragDetails == null) {
              reset(topSpace);
            }
          } else if (notification is ScrollEndNotification) {
            reset(topSpace);
            if (_topSpaceOpenCubit.state && _scrollController.offset > topSpace) {
              _topSpaceOpenCubit.addState(false);
              _scrollController.jumpTo(_scrollController.offset - topSpace);
            } else if (!_topSpaceOpenCubit.state && _scrollController.offset.abs() < 0.1) {
              _topSpaceOpenCubit.addState(true);
              _scrollController.jumpTo(_scrollController.offset + topSpace);
            }
          }
          return true;
        },
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: BlocBuilder(
                  cubit: _topSpaceOpenCubit,
                  builder: (_, currentState) {
                    return SizedBox(
                      height: currentState == true ? topSpace : 0,
                    );
                  }),
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
              childAspectRatio: 1.2,
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

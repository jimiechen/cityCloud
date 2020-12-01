import 'dart:async';
import 'dart:math';

import 'package:cityCloud/dart_class/class/commond_cubit.dart';
import 'package:cityCloud/r.dart';
import 'package:cityCloud/styles/color_helper.dart';
import 'package:cityCloud/widgets/custom_viewport_sliver.dart';
import 'package:cityCloud/widgets/hit_test_manager_widget.dart';
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
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
                          padding: const EdgeInsets.symmetric(horizontal: 20),
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
                      child: Text(
                        '法律条款与平台规则 >',
                        style: TextStyle(fontSize: 13, color: ColorHelper.Black153),
                      ),
                    ),
                  ],
                ),
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (_, __) {
                    return Positioned(
                      top: 25 - _animationController.value * 20,
                      left: 16 + _animationController.value * 85,
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
                    return Opacity(
                      opacity: opacityValueForAnimation(),
                      child: Container(
                        margin: EdgeInsets.only(top: 80 - _animationController.value * 12, left: 16, right: 16),
                        padding: const EdgeInsets.all(10),
                        height: 58,
                        decoration: BoxDecoration(
                          color: ColorHelper.ThemeColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '白银会员',
                                  style: TextStyle(fontSize: 13, color: ColorHelper.Black33),
                                ),
                                Container(
                                  height: 16,
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    // color: Colors.yellow[300],
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: ColorHelper.Black153),
                                  ),
                                  child: Text(
                                    '查看权益 >',
                                    style: TextStyle(fontSize: 11, color: ColorHelper.Black51),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '享24元快车券、快速通道、行程险等权益',
                              style: TextStyle(fontSize: 10, color: ColorHelper.ThemeBlack),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (_, __) {
                    return Opacity(
                      opacity: opacityValueForAnimation(),
                      child: Container(
                        margin: EdgeInsets.only(top: 115 - _animationController.value * 12, left: 16, right: 16),
                        padding: const EdgeInsets.all(10),
                        height: 58,
                        decoration: BoxDecoration(
                          color: Colors.blueGrey[900],
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '超级会员',
                                  style: TextStyle(fontSize: 13, color: ColorHelper.ThemeColor),
                                ),
                                Container(
                                  height: 16,
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.yellow[300],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '立即开通 >',
                                    style: TextStyle(fontSize: 11, color: ColorHelper.ThemeColor),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '享24元快车券、快速通道、行程险等权益',
                              style: TextStyle(fontSize: 10, color: ColorHelper.ThemeColor),
                            ),
                          ],
                        ),
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
      _scrollController.animateTo(offset, duration: Duration(milliseconds: 200), curve: Curves.linear);
    });
  }

  void reset(double topSpace) {
    ///如果是代码控制的滚动，那就没必要重新矫正CustomScrollView的offset了
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
  void dispose() {
    _topSpaceOpenCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, boxconstraints) {
      double topSpace = boxconstraints.maxHeight - 170;
      return NotificationListener(
        onNotification: (notification) {
          if (notification is ScrollStartNotification) {
            if (notification.dragDetails != null) {
              _isCodeControlScroll = false;
            }
            _gridViewIsOpenWhenStartScroll = !_topSpaceOpenCubit.state || _scrollController.offset >= topSpace;
          } else if (notification is ScrollUpdateNotification) {
            if (_topSpaceOpenCubit.state && _scrollController.offset <= topSpace && _scrollController.offset >= 0) {
              widget.animationController.value = _scrollController.offset / topSpace;
            }
            if (notification.dragDetails == null) {
              reset(topSpace);
            }
          } else if (notification is ScrollEndNotification) {
            reset(topSpace);
            _isCodeControlScroll = false;
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
        child: HitTestCheckWidget(
          checkHitTestPermission: (offset) {
            return _topSpaceOpenCubit.state ? (offset.dy + _scrollController.offset) > topSpace : true;
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
                    if (widget.animationController.isDismissed) {
                      widget.animationController?.forward();
                      scrollTo(topSpace);
                    } else if (widget.animationController.isCompleted) {
                      widget.animationController?.reverse();
                      scrollTo(0);
                    }
                  },
                  child: Container(
                    height: 30,
                    color: Colors.white,
                    alignment: Alignment.center,
                    child: AnimatedBuilder(
                      animation: widget.animationController,
                      child: Icon(Icons.arrow_drop_up),
                      builder: (_, child) {
                        return Transform.rotate(
                          angle: widget.animationController.value * pi,
                          child: child,
                        );
                      },
                    ),
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
              CustomViewportSliver(
                heightBuilder: (viewportHeight, precedingScrollExtent) {
                  double preHeight =
                      _topSpaceOpenCubit.state ? precedingScrollExtent - topSpace : precedingScrollExtent;
                  return max(0, viewportHeight - preHeight);
                },
                child: Container(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

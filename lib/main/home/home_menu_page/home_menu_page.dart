import 'dart:async';
import 'dart:math';

import 'package:cityCloud/styles/color_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/home_page_cubit.dart';
import 'cubit/home_menu_page_cubit.dart';

class HomeMenuPage extends StatefulWidget {
  @override
  _HomeMenuPageState createState() => _HomeMenuPageState();
}

class _HomeMenuPageState extends State<HomeMenuPage> with TickerProviderStateMixin {
  double _startTapY;
  AnimationController _animationController;
  double _startTapAnimationValue;
  double _interactiveViewMinHeight = 170;
  double _interactiveViewExtentedHeight = 0;
  StreamSubscription _streamSubscription;

  HomeMenuPageCubit _pageCubit = HomeMenuPageCubit();

  List<String> _tabsTitle = ['地区', '推荐', '关注'];
  TabController _tabController;
  PageController _pageController = PageController(initialPage: 0);
  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _tabsTitle.length,
      vsync: this,
    );
    _animationController = AnimationController(
      duration: Duration(milliseconds: 200),
      reverseDuration: Duration(milliseconds: 200),
      vsync: this,
      value: 0,
    );
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        BlocProvider.of<HomePageCubit>(context).add(HomePageCubitShowMenu());
        setState(() {});
      } else if (status == AnimationStatus.dismissed) {
        BlocProvider.of<HomePageCubit>(context).add(HomePageCubitHideMenu());
        setState(() {});
      }
    });

    _streamSubscription = BlocProvider.of<HomePageCubit>(context).listen((currentState) {
      if (currentState is HomePageCubitTapOnTaskCenter ||
          currentState is HomePageCubitTapOnMessageCenter ||
          currentState is HomePageCubitTapOnFriendDynamic ||
          currentState is HomePageCubitTapOnUserCenter) {
        _animationController.forward();
      }
    });
  }

  ///任务中心
  Iterable<Widget> taskCenterContent() sync* {
    yield Container(
      height: 120,
      width: BoxConstraints.expand().maxWidth,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: BlocBuilder<HomePageCubit, HomePageCubitState>(
        buildWhen: (preState, currentState) => currentState is HomePageCubitShowMenu || currentState is HomePageCubitHideMenu,
        builder: (_, currentState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 20,
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: ColorHelper.DividerColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text('当前35481人在线'),
              ),
              SizedBox(height: 12),
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: ColorHelper.BGColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Text('记录今天有趣的事情'),
              ),
            ],
          );
        },
      ),
    );

    yield Container(
      height: 50,
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: Container(
              color: Colors.white,
              alignment: Alignment.center,
              child: Text('搜索其他'),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              alignment: Alignment.center,
              child: Text('查看频道'),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              alignment: Alignment.center,
              child: Text('有趣视频'),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              alignment: Alignment.center,
              child: Text('我的收藏'),
            ),
          ),
        ],
      ),
    );
    yield Expanded(
      child: Container(
        color: ColorHelper.ColorF2,
        child: ListView(
          physics: ClampingScrollPhysics(),
          padding: const EdgeInsets.all(0),
          children: [
            SizedBox(height: 8),
            Container(
              height: 40,
              color: Colors.white,
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: Icon(Icons.arrow_downward),
                onPressed: () {
                  _animationController.reverse();
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double bottomPadding = MediaQuery.of(context).padding.bottom;
    double topPadding = MediaQuery.of(context).padding.top;
    _interactiveViewExtentedHeight = _interactiveViewMinHeight + 100;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          height: 45 + MediaQuery.of(context).padding.top,
          width: BoxConstraints.expand().maxWidth,
          padding: EdgeInsets.only(top: topPadding),
          color: Colors.white,
          child: TabBar(
            tabs: _tabsTitle.map((e) => Text(e)).toList(),
            controller: _tabController,
            isScrollable: true,
            indicatorColor: Colors.transparent,
            labelColor: ColorHelper.Black51,
            unselectedLabelColor: ColorHelper.Black153,
            unselectedLabelStyle: TextStyle(color: ColorHelper.Black153, fontSize: 13),
            labelStyle: TextStyle(color: ColorHelper.Black51, fontSize: 16, fontWeight: FontWeight.bold),
            onTap: (index) {
              _pageController.animateToPage(
                index,
                duration: Duration(milliseconds: 20),
                curve: Curves.linear,
              );
            },
          ),
        ),
        Expanded(
          child: IgnoreHitTestWidget(
            child: PageView(
              controller: _pageController,
              physics: _animationController.isCompleted ? null : NeverScrollableScrollPhysics(),
              onPageChanged: (index) {
                _tabController.animateTo(index);
              },
              children: [
                Column(
                  children: [
                    Spacer(),
                    AnimatedBuilder(
                      animation: _animationController,
                      child: InteractiveViewer(
                          onInteractionStart: (detail) {
                            _startTapY = detail.localFocalPoint.dy;
                            _startTapAnimationValue = _animationController.value;
                          },
                          onInteractionUpdate: (detail) {
                            _animationController.value =
                                _startTapAnimationValue + min((_startTapY - detail.localFocalPoint.dy) / _interactiveViewExtentedHeight, 1 - _startTapAnimationValue);
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
                          child: Column(
                            children: [...taskCenterContent()],
                          )),
                      builder: (_, child) {
                        return SizedBox(
                          height: _interactiveViewExtentedHeight * _animationController.value + _interactiveViewMinHeight,
                          width: BoxConstraints.expand().maxWidth,
                          child: child,
                        );
                      },
                    ),
                  ],
                ),
                Container(color: Colors.white),
                Container(color: Colors.white),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }
}

class IgnoreHitTestWidget extends SingleChildRenderObjectWidget {
  const IgnoreHitTestWidget({
    Key key,
    Widget child,
  }) : super(key: key, child: child);

  @override
  IgnoreHitTestRender createRenderObject(BuildContext context) {
    final IgnoreHitTestRender renderObject = IgnoreHitTestRender();
    return renderObject;
  }
}

class IgnoreHitTestRender extends RenderProxyBox {
  IgnoreHitTestRender({
    RenderBox child,
  }) : super(child);

  @override
  bool hitTest(BoxHitTestResult result, {Offset position}) {
    bool b = super.hitTest(result, position: position);
    // print(result);
    return false;
  }
}

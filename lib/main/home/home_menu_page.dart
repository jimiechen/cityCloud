import 'dart:async';
import 'dart:math';

import 'package:cityCloud/r.dart';
import 'package:cityCloud/styles/color_helper.dart';
import 'package:cityCloud/styles/custom_style.dart';
import 'package:cityCloud/widgets/custom_widget.dart';
import 'package:cityCloud/widgets/sawtooth_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/home_page_cubit.dart';

class HomeMenuPage extends StatefulWidget {
  @override
  _HomeMenuPageState createState() => _HomeMenuPageState();
}

class _HomeMenuPageState extends State<HomeMenuPage> with SingleTickerProviderStateMixin {
  double _startTapY;
  AnimationController _animationController;
  double _startTapAnimationValue;
  double _interactiveViewMinHeight = 100;
  double _interactiveViewExtentedHeight = 0;
  StreamSubscription _streamSubscription;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 200),
      reverseDuration: Duration(milliseconds: 200),
      vsync: this,
      value: 0,
    );
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        BlocProvider.of<HomePageCubit>(context).add(HomePageCubitShowMenu());
      } else if (status == AnimationStatus.dismissed) {
        BlocProvider.of<HomePageCubit>(context).add(HomePageCubitHideMenu());
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
      height: 40,
      color: ColorHelper.ColorF2,
      child: BlocBuilder<HomePageCubit, HomePageCubitState>(
        buildWhen: (preState, currentState) => currentState is HomePageCubitShowMenu || currentState is HomePageCubitHideMenu,
        builder: (_, currentState) {
          return Row(
            children: [
              Expanded(
                child: Visibility(
                  visible: currentState is HomePageCubitShowMenu,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        _animationController.reverse();
                      },
                    ),
                  ),
                ),
              ),
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
              Expanded(
                child: Visibility(
                  visible: currentState is HomePageCubitShowMenu,
                  child: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right:12),
                    child: Text(
                      '0',
                      style: TextStyle(
                        color: ColorHelper.ThemeColor,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
    yield Divider(
      height: 1,
      thickness: 1,
      color: ColorHelper.DividerColor,
    );
    yield Container(
      height: 50,
      color: ColorHelper.ColorF2,
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
    yield Expanded(
      child: Container(
        color: ColorHelper.ColorF2,
        child: ListView(
          physics: ClampingScrollPhysics(),
          padding: const EdgeInsets.all(0),
          children: [
            CustomWidget.emptyWidget(tips: '当前还没有任务', top: 80),
          ],
        ),
      ),
    );
  }

  ///消息中心
  Iterable<Widget> messageCenterContent() sync* {
    yield Container(
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
              '消息中心',
              style: TextStyle(color: ColorHelper.ThemeColor),
            ),
          ),
          Spacer(),
        ],
      ),
    );
    yield Divider(
      height: 1,
      thickness: 1,
      color: ColorHelper.DividerColor,
    );
    yield Container(
      height: 50,
      color: ColorHelper.ColorF2,
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
              text: '去打招呼吧',
              style: TextStyle(
                color: Color(0xFF555555),
              ),
            ),
          ],
        ),
      ),
    );
    yield Expanded(
      child: Container(
        color: ColorHelper.ColorF2,
        child: ListView(
          physics: ClampingScrollPhysics(),
          padding: const EdgeInsets.all(0),
          children: [
            CustomWidget.emptyWidget(tips: '当前还没有消息', top: 80),
          ],
        ),
      ),
    );
  }

  ///好友动态
  Iterable<Widget> friendDynamicContent() sync* {
    yield Container(
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
              '好友动态',
              style: TextStyle(color: ColorHelper.ThemeColor),
            ),
          ),
          Spacer(),
        ],
      ),
    );
    yield Divider(
      height: 1,
      thickness: 1,
      color: ColorHelper.DividerColor,
    );
    yield Expanded(
      child: Container(
        color: ColorHelper.ColorF2,
        child: ListView(
          physics: ClampingScrollPhysics(),
          padding: const EdgeInsets.all(0),
          children: [
            CustomWidget.emptyWidget(tips: '当前还没有动态，快去关注更多游客吧', top: 80),
          ],
        ),
      ),
    );
  }

  ///个人中心
  Iterable<Widget> userCenterContent() sync* {
    final List<String> titleList = ['我的动态', '栏目名字', '栏目名字', '栏目名字'];
    yield Container(
      height: 40,
      color: ColorHelper.ColorF2,
      child: Row(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  _animationController.reverse();
                },
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            height: 26,
            width: 100,
            decoration: BoxDecoration(
              color: ColorHelper.ColorEB,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Text(
              '个人中心',
              style: TextStyle(color: ColorHelper.ThemeColor),
            ),
          ),
          Spacer(),
        ],
      ),
    );
    yield Divider(
      height: 1,
      thickness: 1,
      color: ColorHelper.DividerColor,
    );
    yield Expanded(
      child: Container(
        color: ColorHelper.ColorF2,
        child: ListView(
          padding: const EdgeInsets.all(0),
          physics: ClampingScrollPhysics(),
          children: [
            Container(
              height: 122,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    R.assetsImagesIconIconProsperity,
                    width: 67,
                    height: 67,
                  ),
                  Text('昵称')
                ],
              ),
            ),
            SizedBox(
              height: 8,
            ),
            for (var title in titleList) ...[
              Container(
                height: 60,
                color: Colors.white,
                padding: const EdgeInsets.only(right: 12),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Image.asset(R.assetsImagesIconIconProsperity),
                    ),
                    Text(title),
                    Spacer(),
                    Icon(Icons.keyboard_arrow_right),
                  ],
                ),
              ),
              Container(
                height: 1,
                margin: const EdgeInsets.only(left: 60),
                color: ColorHelper.DividerColor,
              ),
            ],
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
            child: BlocBuilder<HomePageCubit, HomePageCubitState>(
              buildWhen: (preState, currentState) =>
                  currentState is HomePageCubitTapOnTaskCenter ||
                  currentState is HomePageCubitTapOnMessageCenter ||
                  currentState is HomePageCubitTapOnFriendDynamic ||
                  currentState is HomePageCubitTapOnUserCenter ||
                  (currentState is HomePageCubitHideMenu && preState is! HomePageCubitTapOnTaskCenter),
              builder: (_, currentState) {
                return Column(
                  children: [
                    SizedBox(
                      height: 9,
                      width: BoxConstraints.expand().maxWidth,
                      child: SawtoothWidget(
                        xStep: 8,
                        color: ColorHelper.ColorF2,
                      ),
                    ),
                    if (currentState is HomePageCubitTapOnMessageCenter)
                      ...messageCenterContent()
                    else if (currentState is HomePageCubitTapOnFriendDynamic)
                      ...friendDynamicContent()
                    else if (currentState is HomePageCubitTapOnUserCenter)
                      ...userCenterContent()
                    else
                      ...taskCenterContent()
                  ],
                );
              },
            ),
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
                onPressed: () {
                  BlocProvider.of<HomePageCubit>(context).add(HomePageCubitTapOnMessageList());
                },
              ),
              Spacer(),
              IconButton(
                icon: Icon(
                  Icons.control_point,
                  size: 38,
                  color: Color(0xFF555555),
                ),
                onPressed: () {
                  BlocProvider.of<HomePageCubit>(context).add(HomePageCubitTapOnAddDynamic());
                },
              ),
              Spacer(),
              IconButton(
                icon: Icon(
                  Icons.person_outline,
                  size: 30,
                  color: Color(0xFF555555),
                ),
                onPressed: () {
                  BlocProvider.of<HomePageCubit>(context).add(HomePageCubitTapOnUserCenter());
                },
              ),
            ],
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }
}

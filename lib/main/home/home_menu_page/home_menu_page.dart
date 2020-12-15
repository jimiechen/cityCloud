import 'dart:async';

import 'package:cityCloud/expanded/global_cubit/global_cubit.dart';
import 'package:cityCloud/router/router.dart';
import 'package:cityCloud/styles/color_helper.dart';
import 'package:cityCloud/widgets/hit_test_manager_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hrlweibo/pages/home/weibo_follow_page.dart';
import 'package:flutter_hrlweibo/pages/home/weibo_publish_page.dart';
import 'package:flutter_hrlweibo/pages/vedio/video_recommend_page.dart';

import '../cubit/home_page_cubit.dart';

const double TopContentHeight = 90;
const double TopDownArrowHeight = 45;

class HomeMenuPage extends StatefulWidget {
  @override
  _HomeMenuPageState createState() => _HomeMenuPageState();
}

class _HomeMenuPageState extends State<HomeMenuPage> with TickerProviderStateMixin {
  double _firstPageOriginHeight = 170;
  double _topSpaceHeight;
  double _pageViewHeight;
  double _topBarHeight;

  ScrollController _scrollController = ScrollController();

  AnimationController _tabBarAnimationController;
  AnimationController _downArrowAnimationController;
  StreamSubscription _streamSubscription;
  StreamSubscription _globalCubitStreamSubscription;

  List<String> _tabsTitle = ['地区', '推荐', '关注'];

  ///推荐页面
  VideoRecommendPage _videoRecommendPage = VideoRecommendPage();

  ///关注页面
  WeiBoFollowPage _weiBoFollowPage = WeiBoFollowPage();
  TabController _tabController;
  PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    HomePageCubit homePageCubit = BlocProvider.of<HomePageCubit>(context);
    _tabController = TabController(
      length: _tabsTitle.length,
      vsync: this,
    );
    _tabController.addListener(() {
      setState(() {});
      if (_tabController.index == 0) {
        homePageCubit.add(HomePageCubitStartGame());
      } else {
        homePageCubit.add(HomePageCubitStopGame());
      }
    });
    _scrollController.addListener(() {
      if (_scrollController.offset > _topSpaceHeight - _topBarHeight - 10) {
        if (homePageCubit.state is! HomePageCubitStopGame) {
          homePageCubit.add(HomePageCubitStopGame());
        }
      } else if (_scrollController.offset < _topSpaceHeight - _topBarHeight - 15) {
        if (homePageCubit.state is! HomePageCubitStartGame) {
          homePageCubit.add(HomePageCubitStartGame());
        }
      }

      if (_scrollController.offset < _topSpaceHeight - _topBarHeight) {
        if (!_tabBarAnimationController.isAnimating && !_tabBarAnimationController.isDismissed) {
          _tabBarAnimationController.reverse();
        }
      } else {
        if (!_tabBarAnimationController.isAnimating && !_tabBarAnimationController.isCompleted) {
          _tabBarAnimationController.forward();
        }
      }

      double start = _pageViewHeight - _firstPageOriginHeight;
      if (_scrollController.offset < start) {
        if (!_downArrowAnimationController.isAnimating && !_downArrowAnimationController.isDismissed) {
          _downArrowAnimationController.reverse();
        }
      } else if (_scrollController.offset < _pageViewHeight) {
        if (!_downArrowAnimationController.isAnimating) {
          _downArrowAnimationController.animateTo((_scrollController.offset - start) / (_pageViewHeight - start),
              duration: Duration.zero);
        }
      } else if (_scrollController.offset >= _pageViewHeight) {
        if (!_downArrowAnimationController.isAnimating && !_downArrowAnimationController.isCompleted) {
          _downArrowAnimationController.forward();
        }
      }
    });
    _tabBarAnimationController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
      value: 0,
    );
    _downArrowAnimationController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
      value: 0,
    );

    // _streamSubscription = BlocProvider.of<HomePageCubit>(context).listen((currentState) {
    //   if (currentState is HomePageCubitTapOnTaskCenter ||
    //       currentState is HomePageCubitTapOnMessageCenter ||
    //       currentState is HomePageCubitTapOnFriendDynamic ||
    //       currentState is HomePageCubitTapOnUserCenter) {
    //     // _animationController.forward();
    //     print(currentState);
    //   }
    // });

    _globalCubitStreamSubscription = GlobalCubit().listen((globalCubitState) {
      if (globalCubitState is GlobalTapOnPersionSpriteMessageRemider) {
        ///点击带信封小人
        _weiBoFollowPage = WeiBoFollowPage(personId: globalCubitState.personModel.id,);
        _tabController.animateTo(2);
        tabBarIndexChange(2);
      }
    });
  }

  @override
  void dispose() {
    _tabBarAnimationController.dispose();
    _downArrowAnimationController.dispose();
    _streamSubscription?.cancel();
    _globalCubitStreamSubscription?.cancel();
    super.dispose();
  }

  void tabBarIndexChange(index) {
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 20),
      curve: Curves.linear,
    );
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 24,
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: ColorHelper.DividerColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text('当前35481人在线'),
          ),
          SizedBox(height: 12),
          GestureDetector(
            onTap: () {
              Navigator.push(context, RouterManager.routeForPage(page: WeiBoPublishPage()));
            },
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: ColorHelper.BGColor,
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Text('记录今天有趣的事情'),
            ),
          ),
        ],
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
    // yield SizedBox(height: 8);
    // yield ;
  }

  Widget topBar() {
    double topPadding = MediaQuery.of(context).padding.top;
    _topBarHeight = topPadding + TopContentHeight;
    return AnimatedBuilder(
      animation: _tabBarAnimationController,
      builder: (_, __) {
        return Positioned(
          left: 0,
          right: 0,
          top: -_tabBarAnimationController.value * _topBarHeight,
          child: Container(
            height: _topBarHeight,
            width: BoxConstraints.expand().maxWidth,
            padding: EdgeInsets.only(top: topPadding),
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  height: 45,
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.person),
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                      ),
                      Text('佛山市'),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.message),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(Icons.qr_code_scanner),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: TabBar(
                    tabs: _tabsTitle
                        .map(
                          (e) => Container(
                            height: 42,
                            alignment: Alignment.center,
                            child: Text(e),
                          ),
                        )
                        .toList(),
                    controller: _tabController,
                    isScrollable: true,
                    indicatorColor: Colors.transparent,
                    labelColor: ColorHelper.Black51,
                    unselectedLabelColor: ColorHelper.Black153,
                    unselectedLabelStyle: TextStyle(color: ColorHelper.Black153, fontSize: 13),
                    labelStyle: TextStyle(color: ColorHelper.Black51, fontSize: 16, fontWeight: FontWeight.bold),
                    onTap: tabBarIndexChange,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget downArrow() {
    double topPadding = MediaQuery.of(context).padding.top;
    return AnimatedBuilder(
      animation: _downArrowAnimationController,
      builder: (_, __) {
        return Container(
          height: TopDownArrowHeight + topPadding,
          color: Colors.white.withOpacity(_downArrowAnimationController.value),
          padding: EdgeInsets.only(top: topPadding),
          alignment: Alignment.centerLeft,
          child: IconButton(
            icon: Icon(
              Icons.arrow_downward,
              color: ColorHelper.ThemeBlack.withOpacity(_downArrowAnimationController.value),
            ),
            onPressed: () {
              _scrollController.animateTo(0, duration: Duration(milliseconds: 200), curve: Curves.linear);
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        _pageViewHeight = constraints.maxHeight;
        _topSpaceHeight = _pageViewHeight - _firstPageOriginHeight;
        double manualMoveHeight = _topSpaceHeight * 0.5;
        return Stack(
          children: [
            HitTestAbsorbCheckWidget(
              checkHitTestAbsorb: (hitTestPosition) {
                return hitTestPosition.dy + _scrollController.offset > _topSpaceHeight;
              },
              child: HitTestIgnoreManagerWidget(
                ignoreHitTest: _tabController.index == 0,
                hitestChild: Listener(
                  onPointerMove: (_) {},
                  onPointerUp: (_) {
                    if (_scrollController.offset > manualMoveHeight &&
                        _scrollController.offset < _topSpaceHeight - _topBarHeight) {
                      _scrollController.animateTo(manualMoveHeight,
                          duration: Duration(milliseconds: 200), curve: Curves.linear);
                    } else if (_scrollController.offset >= _topSpaceHeight - _topBarHeight &&
                        _scrollController.offset < _pageViewHeight) {
                      _scrollController.animateTo(_pageViewHeight,
                          duration: Duration(milliseconds: 200), curve: Curves.linear);
                    }
                  },
                  child: HitTestCheckWidget(
                    checkHitTestPermission: (hitTestPosition) {
                      return hitTestPosition.dy + _scrollController.offset > _topSpaceHeight;
                    },
                    child: ListView(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(0),
                      children: [
                        SizedBox(height: _topSpaceHeight),
                        ...taskCenterContent(),
                        Container(
                          color: Colors.yellow,
                          height: MediaQuery.of(context).size.height,
                        ),
                        Container(
                          height: 30,
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ),
                ),
                ignoreWidgetBuilder: (child) {
                  return PageView(
                    key: ValueKey('PageView'),
                    controller: _pageController,
                    onPageChanged: (index) {
                      if (index != _tabController.index) {
                        _tabController.animateTo(index);
                      }
                    },
                    children: [
                      child,
                      Padding(
                        padding: EdgeInsets.only(top: _topBarHeight),
                        child: _videoRecommendPage,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: _topBarHeight),
                        child: _weiBoFollowPage,
                      ),
                    ],
                  );
                },
              ),
            ),
            downArrow(),
            topBar(),
          ],
        );
      },
    );
  }
}

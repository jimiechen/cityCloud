import 'dart:async';

import 'package:cityCloud/expanded/global_cubit/global_cubit.dart';
import 'package:cityCloud/expanded/log_recorder/log_recorder.dart';
import 'package:cityCloud/main/game/custom_game.dart';
import 'package:cityCloud/main/home/bloc/home_page_bloc.dart';
import 'package:cityCloud/main/home/cubit/home_page_cubit.dart';
import 'package:cityCloud/main/home/home_menu_page/home_menu_page.dart';
import 'package:cityCloud/main/home/home_status_page.dart';
import 'package:cityCloud/user_info/user_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'drawer_page.dart';
import 'widget/person_detail_widget.dart';
import 'widget/save_person_widget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CustomGame _box2dGame;
  HomeMenuPage _homeMenuPage = HomeMenuPage();
  HomeStatusPage _homeStatusPage = HomeStatusPage();
  HomePageBloc _bloc = HomePageBloc();

  ///用与模块间事件传递
  HomePageCubit _cubit = HomePageCubit();

  StreamSubscription _streamSubscription;

  @override
  void initState() {
    super.initState();
    LogRecorder.addLog(logDescription: '打开首页', logType: LogType.openPage);
    _box2dGame = CustomGame(homePageBloc: _bloc, homePageCubit: _cubit);
    GlobalCubit().listen((cubitState) {
      if (cubitState is GlobalTapOnPersionSprite) {
        ///点击了小人
        showDialog(
          context: context,
          child: PersonDetailWidget(),
        );
      } else if (cubitState is GlobalTapOnPersionSpriteNumberRemider) {
        ///点击带数字小人
        showDialog(context: context, child: SavePersonWidget());
      } else if (cubitState is GlobalCubitStateAddPerson) {
        _box2dGame.randomAddPerson(toUpload: true);
      } else if (cubitState is GlobalCubitStateAddCar) {
        _box2dGame.randomAddCar(toUpload: true);
      }
    });

    _streamSubscription = _cubit.listen((currentState) {
      if (currentState is HomePageCubitTapOnTaskCenter) {
        _box2dGame.randomAddPerson(toUpload: UserInfo().gameDataSyncServer, useEnterAnimation: true);
        LogRecorder.addLog(logDescription: '点击按钮手动添加小人', logType: LogType.addPerson);
      } else if (currentState is HomePageCubitTapOnMessageCenter) {
        _box2dGame.randomAddCar(toUpload: UserInfo().gameDataSyncServer);
        LogRecorder.addLog(logDescription: '点击按钮手动添加小车', logType: LogType.addCar);
      } else if (currentState is HomePageCubitTapOnFriendDynamic) {
        _box2dGame.randomAddTile(toUpload: UserInfo().gameDataSyncServer);
        LogRecorder.addLog(logDescription: '点击按钮手动添加地图块', logType: LogType.addMapTile);
      }
    });
  }

  @override
  void dispose() {
    _bloc.close();
    _cubit.close();
    _streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        drawer: DrawerPage(),
        drawerEnableOpenDragGesture: false,
        body: MultiBlocProvider(
          providers: [
            BlocProvider.value(value: _bloc),
            BlocProvider.value(value: _cubit),
          ],
          child: Stack(
            children: [
              RepaintBoundary(
                child: _box2dGame.widget,
              ),
              _homeStatusPage,
              _homeMenuPage,
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:cityCloud/expanded/global_cubit/global_cubit.dart';
import 'package:cityCloud/main/game/custom_game.dart';
import 'package:cityCloud/main/home/bloc/home_page_bloc.dart';
import 'package:cityCloud/main/home/cubit/home_page_cubit.dart';
import 'package:cityCloud/main/home/home_menu_page/home_menu_page.dart';
import 'package:cityCloud/main/home/home_status_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  @override
  void initState() {
    super.initState();
    _box2dGame = CustomGame(homePageBloc: _bloc,homePageCubit: _cubit);
    GlobalCubit().listen((cubitState) {
      if (cubitState is GlobalTapOnPersionSpriteRemider) {
        ///点击了小人头部提示
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: Text('点击了小人头上的提示'),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text(
                    '确定',
                    style: TextStyle(decoration: TextDecoration.none, fontSize: 16),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      }
      else if (cubitState is GlobalCubitStateAddPerson) {
        _box2dGame.randomAddPerson(toUpload: true);
      }
       else if (cubitState is GlobalCubitStateAddCar) {
        _box2dGame.randomAddCar(toUpload: true);
      }
    });
  }

  @override
  void dispose() {
    _bloc.close();
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: _bloc),
          BlocProvider.value(value: _cubit),
        ],
        child: Stack(
          children: [
            _box2dGame.widget,
            _homeStatusPage,
            _homeMenuPage,
          ],
        ),
      ),
    );
  }
}

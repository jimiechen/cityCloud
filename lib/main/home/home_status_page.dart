import 'dart:async';

import 'package:cityCloud/main/home/cubit/home_page_cubit.dart';
import 'package:cityCloud/r.dart';
import 'package:cityCloud/styles/color_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeStatusPage extends StatefulWidget {
  @override
  _HomeStatusPageState createState() => _HomeStatusPageState();
}

class _HomeStatusPageState extends State<HomeStatusPage> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
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
    _streamSubscription = BlocProvider.of<HomePageCubit>(context).listen((currentState) {
      if (currentState is HomePageCubitShowMenu) {
        _animationController.forward();
      } else if (currentState is HomePageCubitHideMenu) {
        _animationController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double topPadding = MediaQuery.of(context).padding.top;
    return AnimatedBuilder(
      animation: _animationController,
      builder: (_, child) {
        return Padding(
          padding: EdgeInsets.only(top: (topPadding + 100) * (1 - _animationController.value), left: 12, right: 12),
          child: Opacity(
            opacity: 1 - _animationController.value,
            child: child,
          ),
        );
      },
      child: Row(
        children: [
          Column(
            children: [
              Container(
                width: 100,
                height: 50,
                padding: const EdgeInsets.only(top: 6, bottom: 16, left: 20),
                foregroundDecoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(R.assetsImagesIconIconProsperity),
                    alignment: Alignment.centerLeft,
                    fit: BoxFit.contain,
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.only(left: 8),
                  decoration: BoxDecoration(
                    color: Color(0xBB000000),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '79',
                    style: TextStyle(color: ColorHelper.ThemeColor, fontSize: 16),
                  ),
                ),
              )
            ],
          ),
          Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                height: 26,
                width: 150,
                margin: const EdgeInsets.only(top: 6),
                padding: const EdgeInsets.only(left: 8, right: 2),
                decoration: BoxDecoration(
                  color: Color(0xBB000000),
                  borderRadius: BorderRadius.circular(15),
                ),
                alignment: Alignment.center,
                child: Row(
                  children: [
                    Image.asset(
                      R.assetsImagesIconIconCoin,
                      width: 22,
                    ),
                    Text(
                      ' 79',
                      style: TextStyle(color: ColorHelper.ThemeColor, fontSize: 16),
                    ),
                    Spacer(),
                    Image.asset(
                      R.assetsImagesIconIconCube,
                      width: 24,
                    ),
                    Text(
                      '69',
                      style: TextStyle(color: Color.fromRGBO(92, 178, 170, 1), fontSize: 16),
                    ),
                    Spacer(),
                    Image.asset(
                      R.assetsImagesIconIconCoin,
                      width: 22,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                height: 26,
                // width: 75,
                margin: const EdgeInsets.only(top: 6),
                padding: const EdgeInsets.only(left: 8, right: 2),
                decoration: BoxDecoration(
                  color: Color(0xBB000000),
                  borderRadius: BorderRadius.circular(15),
                ),
                alignment: Alignment.center,
                child: Row(
                  children: [
                    Image.asset(
                      R.assetsImagesIconIconCoin,
                      width: 22,
                    ),
                    Text(
                      ' 5/5 ',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    Image.asset(
                      R.assetsImagesIconIconCoin,
                      width: 22,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () {
                  BlocProvider.of<HomePageCubit>(context).add(HomePageCubitTapOnTaskCenter());
                },
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(25), color: ColorHelper.ColorE3),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              GestureDetector(
                onTap: () {
                  BlocProvider.of<HomePageCubit>(context).add(HomePageCubitTapOnMessageCenter());
                },
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(25), color: ColorHelper.ColorE3),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              GestureDetector(
                onTap: () {
                  BlocProvider.of<HomePageCubit>(context).add(HomePageCubitTapOnFriendDynamic());
                },
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(25), color: ColorHelper.ColorE3),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

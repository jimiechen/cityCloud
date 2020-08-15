import 'package:cityCloud/styles/color_helper.dart';
import 'package:flutter/material.dart';

class CustomStyle {
//阴影框
  static List<BoxShadow> get defaultBoxShadow {
    return [BoxShadow(color: ColorHelper.DividerColor, spreadRadius: 1, blurRadius: 2)];
  }
}
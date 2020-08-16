import 'package:cityCloud/dart_class/extension/string_extension.dart';
import 'package:cityCloud/r.dart';
import 'package:flutter/material.dart';

class CustomWidget {
  static Widget emptyWidget({double top, double bottom, String tips}) {
    Widget emptyImage = Container(
      padding: EdgeInsets.only(top: top ?? 0, bottom: bottom ?? 0),
      child: Center(child: Image.asset(R.assetsImagesBackgroundBgEmpty,width: 149,height: 120,)),
    );
    if (tips.isNotNullAndEmpty) {
      return Column(
        children: [
          emptyImage,
          SizedBox(height: 12,),
          Text(tips,style: TextStyle(color: Color(0xFFA3A3A3),fontSize: 16),),
        ],
      );
    }
    return emptyImage;
  }
}

import 'package:cityCloud/const/config.dart';
import 'package:cityCloud/r.dart';
import 'package:cityCloud/styles/color_helper.dart';
import 'package:flutter/material.dart';
import 'package:pangolin/pangolin.dart' as Pangolin;

class SavePersonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 340,
          width: 300,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Material(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  R.assetsImagesPeopleHair5,
                  width: 80,
                  height: 80,
                ),
                Text(
                  '抢救业务员',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '业绩压力压得我快喘不过气了，可以帮我减轻负担吗？我不想被裁员呀...',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: ColorHelper.Black153,
                  ),
                ),
                Spacer(),
                Divider(),
                FlatButton(
                  minWidth: 120,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: BorderSide(
                      color: ColorHelper.ThemeColor,
                      width: 1,
                    ),
                  ),
                  onPressed: () {
                    Pangolin.loadSplashAd(mCodeId: PangolinSplashAdCodeID, debug: false);
                    Future((){
                      Navigator.pop(context);
                    });
                  },
                  child: Text('抢救他'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:cityCloud/expanded/database/database.dart';
import 'package:cityCloud/r.dart';
import 'package:cityCloud/styles/color_helper.dart';
import 'package:flutter/material.dart';

class PersonDetailWidget extends StatefulWidget {
  final PersonModel personModel;

  const PersonDetailWidget({Key key, this.personModel}) : super(key: key);
  @override
  _PersonDetailWidgetState createState() => _PersonDetailWidgetState();
}

class _PersonDetailWidgetState extends State<PersonDetailWidget> {
  PersonModel personModel;
  List<String> personList = ['杰克森*豪尔', '雷切尔', '小明', '老黄'];
  int currentPersonIndex = 0;
  @override
  void initState() {
    super.initState();
    personModel = widget.personModel;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 400,
          width: 300,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Material(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        size: 18,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Text(
                      '旅客',
                      style: TextStyle(fontSize: 18),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.help_outline,
                        size: 16,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 100,
                  child: Row(
                    children: [
                      Image.asset(
                        R.assetsImagesPeopleHair5,
                        width: 60,
                        height: 60,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              personList[currentPersonIndex],
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '市民详细介绍市民详细介绍市民详细介绍市民详细介绍市民详细介绍市民详细介绍',
                              style: TextStyle(
                                fontSize: 12,
                                color: ColorHelper.Black153,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: ColorHelper.BGColor,
                  width: BoxConstraints.expand().maxWidth,
                  child: Text(
                    '工作状态',
                    style: TextStyle(
                      fontSize: 12,
                      color: ColorHelper.Black153,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '当前工作',
                      style: TextStyle(
                        fontSize: 14,
                        color: ColorHelper.Black51,
                      ),
                    ),
                    Text(
                      '无所事事',
                      style: TextStyle(
                        fontSize: 13,
                        color: ColorHelper.Black153,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '金币生产量',
                      style: TextStyle(
                        fontSize: 14,
                        color: ColorHelper.Black51,
                      ),
                    ),
                    Text(
                      '0/HR',
                      style: TextStyle(
                        fontSize: 13,
                        color: ColorHelper.Black153,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                SizedBox(
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      FlatButton(
                        minWidth: 100,
                        color: Colors.orange,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        onPressed: () {},
                        child: Text('邀请'),
                      ),
                      FlatButton(
                        minWidth: 70,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          side: BorderSide(
                            color: ColorHelper.DividerColor,
                            width: 1,
                          ),
                        ),
                        onPressed: () {
                          currentPersonIndex--;
                          if (currentPersonIndex < 0) {
                            currentPersonIndex = personList.length - 1;
                          }
                          setState(() {});
                        },
                        child: Icon(Icons.keyboard_arrow_left),
                      ),
                      FlatButton(
                        minWidth: 70,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          side: BorderSide(
                            color: ColorHelper.DividerColor,
                            width: 1,
                          ),
                        ),
                        onPressed: () {
                          currentPersonIndex++;
                          if (currentPersonIndex >= personList.length) {
                            currentPersonIndex = 0;
                          }
                          setState(() {});
                        },
                        child: Icon(Icons.keyboard_arrow_right),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

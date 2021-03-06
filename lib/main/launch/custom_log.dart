import 'dart:async';

import 'package:cityCloud/expanded/database/database.dart';
import 'package:cityCloud/widgets/default_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:moor/moor.dart';

class CustomLogPage extends StatefulWidget {
  @override
  _CustomLogPageState createState() => _CustomLogPageState();
}

class _CustomLogPageState extends State<CustomLogPage> {
  List<LogInfo> _logList;
  @override
  void initState() {
    super.initState();
    refreshData();
  }

  void refreshData(){
    CustomDatabase db = CustomDatabase();
    (db.select(db.logInfos)
          ..orderBy([
            (t) => OrderingTerm.asc(t.logName),
          ]))
        .get()
        .then((value) {
      setState(() {
        _logList = value;
      });
    });
  }

  void clear() {
    CustomDatabase.share.delete(CustomDatabase.share.logInfos).go().then((value) {
      Timer.run(() {
        refreshData();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        titleText: '查看自定义日志',
        actionText: '删除',
        actionTextOnTap: clear,
      ),
      body: ListView.separated(
        itemBuilder: (_, index) {
          LogInfo logInfo = _logList[index];
          return Container(
            color: Colors.white,
            child: ListTile(
              title: Text(
                logInfo.logName,
              ),
              subtitle: Text(logInfo.date),
              trailing: Text(logInfo.logDescription??''),
            ),
          );
        },
        separatorBuilder: (_, __) => Divider(
          height: 1,
        ),
        itemCount: _logList?.length ?? 0,
      ),
    );
  }
}

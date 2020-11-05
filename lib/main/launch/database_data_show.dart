import 'dart:async';

import 'package:cityCloud/expanded/database/database.dart';
import 'package:cityCloud/widgets/default_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:moor/moor.dart' hide Column;

class BarItem {
  final TableInfo table;
  final String title;

  BarItem({@required this.table, @required this.title});
}

class DatabaseDataShowPage extends StatefulWidget {
  @override
  _DatabaseDataShowPageState createState() => _DatabaseDataShowPageState();
}

class _DatabaseDataShowPageState extends State<DatabaseDataShowPage> with SingleTickerProviderStateMixin {
  List<Map> _dataList = [];
  TabController _tabController;
  List<BarItem> _tabBarItems;
  @override
  void initState() {
    super.initState();

    _tabBarItems = [
      BarItem(table: CustomDatabase.share.personModels, title: 'person'),
      BarItem(table: CustomDatabase.share.tileInfos, title: 'map'),
      BarItem(table: CustomDatabase.share.carInfos, title: 'car'),
    ];
    _tabController = TabController(initialIndex: 0, length: _tabBarItems.length, vsync: this);
    refreshData();
  }

  void refreshData() {
    BarItem item = _tabBarItems[_tabController.index];
    CustomDatabase.share.select(item.table).get().then((value) {
      setState(() {
        _dataList = value?.map((e) => e.toJson())?.toList() ?? [];
      });
    });
  }

  void clear() {
    BarItem item = _tabBarItems[_tabController.index];
    CustomDatabase.share.delete(item.table).go().then((value) {
      Timer.run(() {
        refreshData();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        titleText: '小人数据库数据',
        actionText: '删除',
        actionTextOnTap: clear,
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            isScrollable: true,
            labelColor: Colors.red,
            unselectedLabelColor: Colors.black,
            labelStyle: TextStyle(color: Colors.red, fontSize: 16),
            unselectedLabelStyle: TextStyle(color: Colors.black, fontSize: 14),
            onTap: (index) {
              refreshData();
            },
            tabs: _tabBarItems
                .map(
                  (e) => Container(
                    height: 40,
                    alignment: Alignment.center,
                    child: Text(
                      e.title,
                    ),
                  ),
                )
                ?.toList(),
          ),
          Expanded(
            child: ListView.separated(
              itemBuilder: (_, index) {
                Map contentJson = _dataList[index];
                return Row(
                  children: [
                    Container(
                      width: 30,
                      alignment: Alignment.center,
                      child: Text(
                        '$index',
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(contentJson?.toString()?.replaceAll(',', '\n') ?? ''),
                    ),
                  ],
                );
              },
              separatorBuilder: (_, __) => Divider(
                height: 1,
              ),
              itemCount: _dataList.length,
            ),
          ),
        ],
      ),
    );
  }
}

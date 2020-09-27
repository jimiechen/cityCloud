import 'package:cityCloud/expanded/database/database.dart';
import 'package:cityCloud/widgets/default_app_bar.dart';
import 'package:flutter/material.dart';

class DatabaseDataShowPage extends StatefulWidget {
  @override
  _DatabaseDataShowPageState createState() => _DatabaseDataShowPageState();
}

class _DatabaseDataShowPageState extends State<DatabaseDataShowPage> {
  List<PersonModel> personList = [];
  @override
  void initState() {
    super.initState();
    CustomDatabase.share.select(CustomDatabase.share.personModels).get().then((value) {
      setState(() {
        personList = value??[];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        titleText: '小人数据库数据',
      ),
      body: ListView.separated(itemBuilder: (_,index){
        PersonModel model = personList[index];
        return Text(model.toString());
      }, separatorBuilder: (_,__)=>Divider(height: 1,), itemCount: personList.length),
    );
  }
}

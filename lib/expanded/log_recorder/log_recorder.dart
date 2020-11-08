import 'package:cityCloud/expanded/database/database.dart';
import 'package:moor/moor.dart';

enum LogType {
  initApp,
  openPage,
  addPerson,
  addMapTile,
  addCar,
}

extension on LogType {
  String get name {
    switch (this) {
      case LogType.initApp:
        return '打开app';
        break;
      case LogType.openPage:
        return '打开页面';
        break;
      case LogType.addPerson:
        return '添加小人';
        break;
      case LogType.addMapTile:
        return '添加地图块';
        break;
      case LogType.addCar:
        return '添加小车';
        break;
    }
  }
}

class LogInfos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get date => text()();
  TextColumn get logName => text()();
  TextColumn get logDescription => text().nullable()();
}

class LogRecorder {
  static addLogWithCompanion(LogInfosCompanion info) {
    CustomDatabase db = CustomDatabase();
    db.into(db.logInfos).insert(info);
  }

  static addLog({
    @required LogType logType,
    @required String logDescription,
  }) {
    addLogWithCompanion(
      LogInfosCompanion.insert(
        date: DateTime.now().toString(),
        logName: logType.name,
        logDescription: logDescription != null ? Value<String>(logDescription) : Value.absent(),
      ),
    );
  }
}

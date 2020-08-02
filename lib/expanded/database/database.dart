import 'dart:io';

import 'package:cityCloud/util/list_data_cache_manager.dart/list_item.dart';
import 'package:moor/moor.dart';
import 'package:moor_ffi/moor_ffi.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

// this annotation tells moor to prepare a database class that uses both of the
// tables we just defined. We'll see how to use that database class in a moment.
LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    assert(() {
      print(dbFolder.path);
      return true;
    }());
    final file = File(path.join(dbFolder.path, 'lbx_db.sqlite'));
    return VmDatabase(file);
  });
}

@UseMoor(tables: [CacheDBItems], daos: [CacheDBItemsDao])
class CustomDatabase extends _$CustomDatabase {
  // we tell the database where to store the data with this constructor
  static CustomDatabase _share = CustomDatabase._();
  static CustomDatabase get share => _share;
  factory CustomDatabase() => _share;
  CustomDatabase._() : super(_openConnection());

  // you should bump this number whenever you change or add a table definition. Migrations
  // are covered later in this readme.
  @override
  int get schemaVersion => 1;
}

import 'package:bytebank/database/dao/contact.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> getDatabase() async {
  final String path = join(await getDatabasesPath(), 'bytebank.db');

  return openDatabase(
    path,
    version: 1,
    onCreate: (db, version) {
      db.execute(ContactDao.tableSql);
    },
    // onDowngrade: onDatabaseDowngradeDelete,
  );
}

import 'package:registrador_de_desejos/data/services/desire_dao.dart';
import "package:sqflite/sqflite.dart";
import "package:path/path.dart";

Future<Database> getDatabase() async {
  final String path = join(await getDatabasesPath(), "desires_db.db");
  return openDatabase(path, onCreate: (db, version){
      db.execute(DesireDAO.tableSql);
  }, version: 1);
}
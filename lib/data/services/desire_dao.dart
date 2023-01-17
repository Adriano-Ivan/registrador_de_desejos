

import 'package:registrador_de_desejos/data/database.dart';
import 'package:registrador_de_desejos/data/models/desire.dart';
import "package:sqflite/sqflite.dart";

class DesireDAO {
  static const String tableSql = "CREATE TABLE $_tableName("
      "$_id INTEGER NOT NULL PRIMARY KEY, "
      "$_title VARCHAR(50), "
      "$_description VARCHAR(256), "
      "$_desireNumber INTEGER, "
      "$_desireColor VARCHAR(10), "
      "$_accomplishedDesire INTEGER)";

  static const String _tableName = "desires_table";

  static const String _id = "id";
  static const String _title = "title";
  static const String _description = "description";
  static const String _desireNumber = "desire_number";
  static const String _desireColor = "desire_color";
  static const String _accomplishedDesire = "accomplished_desire";

  save(Desire desire) async {
    final Database database = await getDatabase();
    var itemExists = await find(desire.id);
    Map<String, dynamic> desireMap = toMap(desire);

    if(itemExists == null ){
      return await database.insert(_tableName, desireMap);
    } else {
      return await database.update(
        _tableName,
        desireMap,
        where: "$_id = ?",
        whereArgs: [desire.id]
      );
    }
  }

  Future<Desire?> find(int? id) async{
    if(id == null){
      return null;
    }

    final Database database = await getDatabase();

    final List<Map<String, dynamic>> result  = await database
        .query(_tableName, where: "$_id = ?", whereArgs: [id]);

    if(result.length == 0){
      return null;
    }

    return toObject(result[0]);
  }

  Future<List<Desire>> findAll() async {
    final Database database = await getDatabase();
    final List<Map<String, dynamic>> result = await database.query(_tableName);

    return toList(result);
  }

  delete(int id) async {
    final Database database = await getDatabase();
    return await database.delete(
      _tableName,
      where: "$_id = ?",
      whereArgs: [id],
    );
  }

  List<Desire> toList(List<Map<String, dynamic>> mapDesires){
    final List<Desire> desires = [];
    for(Map<String, dynamic> row in mapDesires){

      final Desire desire = toObject(row);
      desires.add(desire);
    }

    return desires;
  }

  Desire toObject(Map<String, dynamic> mapDesire){
    return Desire(
      title: mapDesire[_title],
      description: mapDesire[_description],
      desireColor: mapDesire[_desireColor],
      desireNumber: mapDesire[_desireNumber],
      accomplishedDesire: mapDesire[_accomplishedDesire] == 1? true : false
    );
  }

  Map<String, dynamic> toMap(Desire desire){
    final Map<String, dynamic> mapDesire = Map();
    mapDesire[_title] = desire.title;
    mapDesire[_desireNumber] = desire.desireNumber;
    mapDesire[_desireColor]  = desire.desireColor;
    mapDesire[_accomplishedDesire] = desire.accomplishedDesire ? 1 : 0;
    mapDesire[_description] = desire.description;

    return mapDesire;
  }
}
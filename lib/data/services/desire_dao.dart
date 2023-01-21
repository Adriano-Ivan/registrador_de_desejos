

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
      "$_targetDate VARCHAR(30), "
      "$_accomplishedDesireDateItDesireWasAccomplished VARCHAR(30), "
      "$_accomplishedDesire INTEGER)";

  static const String _tableName = "desires_table";

  static const String _id = "id";
  static const String _title = "title";
  static const String _description = "description";
  static const String _desireNumber = "desire_number";
  static const String _desireColor = "desire_color";
  static const String _accomplishedDesire = "accomplished_desire";
  static const String _targetDate = "target_date";
  static const String _accomplishedDesireDateItDesireWasAccomplished = "accomplished_desire_date_if_desire_was_accomplished";

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

  Future<List<Desire>> findAllAccomplishedOrNotAccomplished(int accomplished) async {
    final Database database = await getDatabase();
    final List<Map<String, dynamic>> result = await database.query(_tableName,
        where: "$_accomplishedDesire = ?", whereArgs: [accomplished]);

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
      id: mapDesire[_id],
      title: mapDesire[_title],
      description: mapDesire[_description],
      desireColor: mapDesire[_desireColor],
      desireNumber: mapDesire[_desireNumber],
      accomplishedDesire: mapDesire[_accomplishedDesire] == 1? true : false,
      targetDate: convertToDate(mapDesire[_targetDate]),
      accomplishedDesireDateIfDesireWasAccomplished: convertToDate(mapDesire[_accomplishedDesireDateItDesireWasAccomplished])
    );
  }

  DateTime convertToDate(String targetDateString){
    return DateTime.parse(targetDateString);
  }

  String convertToDateString(DateTime targetDateObject){
    return "${targetDateObject.year}-"
        "${targetDateObject.month.toString().length == 1 ? "0${targetDateObject.month}" : targetDateObject.month}-"
        "${targetDateObject.day.toString().length == 1 ? "0${targetDateObject.day}" : targetDateObject.day}";
  }

  Map<String, dynamic> toMap(Desire desire){
    final Map<String, dynamic> mapDesire = Map();
    mapDesire[_title] = desire.title;
    mapDesire[_desireNumber] = desire.desireNumber;
    mapDesire[_desireColor]  = desire.desireColor;
    mapDesire[_accomplishedDesire] = desire.accomplishedDesire ? 1 : 0;
    mapDesire[_description] = desire.description;
    mapDesire[_targetDate] = convertToDateString(desire.targetDate);
    mapDesire[_accomplishedDesireDateItDesireWasAccomplished] = convertToDateString(desire.accomplishedDesireDateIfDesireWasAccomplished);

    return mapDesire;
  }
}


import 'package:registrador_de_desejos/data/database.dart';
import 'package:registrador_de_desejos/data/models/desire.dart';
import 'package:registrador_de_desejos/data/models/statistic_percentage_status_comparison.dart';
import "package:sqflite/sqflite.dart";

class DesireDAO {
  static const String tableSql = "CREATE TABLE $_tableName("
      "$_id INTEGER NOT NULL PRIMARY KEY, "
      "$_title VARCHAR(50), "
      "$_description VARCHAR(256), "
      "$_desireNumber INTEGER, "
      "$_desireColor VARCHAR(10), "
      "$_targetDate VARCHAR(30), "
      "$_accomplishedDesireDateIfDesireWasAccomplished VARCHAR(30), "
      "$_accomplishedDesire INTEGER)";

  static const String _tableName = "desires_table";

  static const String _id = "id";
  static const String _title = "title";
  static const String _description = "description";
  static const String _desireNumber = "desire_number";
  static const String _desireColor = "desire_color";
  static const String _accomplishedDesire = "accomplished_desire";
  static const String _targetDate = "target_date";
  static const String _accomplishedDesireDateIfDesireWasAccomplished = "accomplished_desire_date_if_desire_was_accomplished";

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

  Future<List<Desire>> findAllTodayDesires() async {
    final Database database = await getDatabase();
    DateTime now = DateTime.now();
    final List<Map<String,dynamic>> result = await database.query(_tableName,
      where: "$_targetDate = ?", whereArgs: ["${convertToDateString(now)}"]
    );

    return toList(result);
  }

  Future<StatisticPercentageStatusComparison> returnStatisticPercentageStatusComparison() async{
    final Database database = await getDatabase();

    int allDesires = await countAllDesires(database);
    int accomplishedBeforeTargetDate = await returnNumberOfAccomplishedBeforeTargetDate(database);
    int numberOfPending = await returnNumberOfPending(database);
    int numberOfPendingAndNotAccomplished = await returnNumberOfNotAccomplishedAndPending(database);
    int accomplished = await returnNumberOfAccomplished(database);

    print("$accomplishedBeforeTargetDate, $numberOfPending, $numberOfPendingAndNotAccomplished, $accomplished");
    return StatisticPercentageStatusComparison(
        numberOfAccomplishedPercentage: accomplished > 0 ? (accomplished / allDesires ) * 100 : accomplished.toDouble(),
        numberOfAccomplishedInAdvancePercentage: accomplishedBeforeTargetDate > 0 ?
                (accomplishedBeforeTargetDate / allDesires) * 100 : accomplishedBeforeTargetDate.toDouble(),
        numberOfPendingPercentage: numberOfPending > 0 ?
              (numberOfPending / allDesires) * 100 : numberOfPending.toDouble(),
        numberOfNotAccomplishedUntilTargetDatePercentage: numberOfPendingAndNotAccomplished > 0 ?
                  (numberOfPendingAndNotAccomplished / allDesires) * 100 : numberOfPendingAndNotAccomplished.toDouble(),
        numberOfAccomplishedQuantity: accomplished,
        numberOfAccomplishedInAdvanceQuantity: accomplishedBeforeTargetDate,
        numberOfNotAccomplishedUntilTargetDateQuantity: numberOfPendingAndNotAccomplished,
        numberOfPendingQuantity: numberOfPending
    );
  }

  Future<int> countAllDesires(Database database) async{
    var objectWithCount = await database.rawQuery(
        "SELECT count(*) number from $_tableName"
    );

    return int.parse("${objectWithCount[0]['number']}");
  }

  Future<int> returnNumberOfPending(Database database) async {
    var objectWithCount = await database.rawQuery(
        "SELECT count(*) number from $_tableName where $_accomplishedDesire = 0 AND "
            "date($_targetDate) >= date('${convertToDateString(DateTime.now())}')"

    );

    return int.parse("${objectWithCount[0]['number']}");
  }

  Future<int> returnNumberOfNotAccomplishedAndPending(Database database) async{
    var objectWithCount = await database.rawQuery(
          "SELECT count(*) number from $_tableName where $_accomplishedDesire = 0 AND "
          "date($_targetDate) < date('${convertToDateString(DateTime.now())}') "
      );

    return int.parse("${objectWithCount[0]['number']}");
  }

  Future<int> returnNumberOfAccomplishedBeforeTargetDate(Database database) async {
    var  objectWithCount = await database.rawQuery(
        "SELECT count(*) number from $_tableName where $_accomplishedDesire = 1 AND "
            "date( $_targetDate) > date($_accomplishedDesireDateIfDesireWasAccomplished)"
      );

    return int.parse("${objectWithCount[0]['number']}");
  }

  Future<int> returnNumberOfAccomplished(Database database) async{
    var objectWithCount = await database.rawQuery("SELECT count(*) number from $_tableName where $_accomplishedDesire = 1 AND "
        "date($_targetDate) <= date($_accomplishedDesireDateIfDesireWasAccomplished)"
    );

    return int.parse("${objectWithCount[0]['number']}");

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
      accomplishedDesireDateIfDesireWasAccomplished: convertToDate(mapDesire[_accomplishedDesireDateIfDesireWasAccomplished])
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
    mapDesire[_accomplishedDesireDateIfDesireWasAccomplished] = convertToDateString(desire.accomplishedDesireDateIfDesireWasAccomplished);

    return mapDesire;
  }
}
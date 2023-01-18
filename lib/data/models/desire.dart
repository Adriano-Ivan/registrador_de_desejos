

class Desire {

  int? id;
  String title;
  String description;
  int desireNumber;
  String desireColor;
  bool accomplishedDesire;
  DateTime targetDate;
  DateTime accomplishedDesireDateItDesireWasAccomplished;

  Desire({this.id,required this.title, required this.description, required this.desireNumber,
           required this.desireColor, required this.accomplishedDesire, required this.targetDate,
            required this.accomplishedDesireDateItDesireWasAccomplished});

  String returnTargetDateString(){
    return "${this.targetDate.day}/${this.targetDate.month}/${this.targetDate.year}";
  }
}
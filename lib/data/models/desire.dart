

class Desire {

  int? id;
  String title;
  String description;
  int desireNumber;
  String desireColor;
  bool accomplishedDesire;
  DateTime targetDate;
  DateTime accomplishedDesireDateIfDesireWasAccomplished;

  Desire({this.id,required this.title, required this.description, required this.desireNumber,
           required this.desireColor, required this.accomplishedDesire, required this.targetDate,
            required this.accomplishedDesireDateIfDesireWasAccomplished});

  String returnTargetDateString(){
    return "${this.targetDate.day}/${this.targetDate.month}/${this.targetDate.year}";
  }
}

import 'package:flutter/material.dart';
import 'package:registrador_de_desejos/data/models/desire.dart';
import 'package:registrador_de_desejos/pages/utils/color_converter.dart';

class DesireItem extends StatefulWidget{
  final Desire desire;

  DesireItem({required this.desire});

  @override
  _DesireItem createState() => _DesireItem();
}

class _DesireItem extends State<DesireItem>{

  bool dateIsBeforeNow(DateTime dateTimeObject){
    return DateUtils.dateOnly(dateTimeObject).isBefore(DateUtils.dateOnly(DateTime.now()));
  }
  
  bool dateIsAfterNow(DateTime dateTimeObject){
    return DateUtils.dateOnly(dateTimeObject).isAfter(DateUtils.dateOnly(DateTime.now()));
  }
  
  bool dateIsAtTheSameMomentAsToday(DateTime dateTimeObject){
    return DateUtils.dateOnly(dateTimeObject).isAtSameMomentAs(DateUtils.dateOnly(DateTime.now()));
  }

  bool dateIsAfterAnotherDate(DateTime dateTimeObject, DateTime dateTimeObject2){
    return DateUtils.dateOnly(dateTimeObject).isAfter(DateUtils.dateOnly(dateTimeObject2));
  }

  String defineGeneralStatus(){
    if(dateIsBeforeNow(widget.desire.targetDate) && !widget.desire.accomplishedDesire){
      return "Desejo pendente de realização e com data alvo ultrapassada";
    }

    if((dateIsAfterNow(widget.desire.targetDate) ||
        dateIsAtTheSameMomentAsToday(widget.desire.targetDate))
            && !widget.desire.accomplishedDesire){
      return "Desejo pendente de realização";
    }

    if(dateIsAfterAnotherDate(widget.desire.targetDate,
        widget.desire.accomplishedDesireDateItDesireWasAccomplished) &&
        widget.desire.accomplishedDesire){
      return "Desejo realizado antes da data alvo";
    }

    return "Desejo realizado";
  }

  @override
  Widget build(BuildContext context){
    return InkWell(
      child:  Container(

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    leading:widget.desire.accomplishedDesire ?
                    Icon(Icons.done,color: Colors.green,) : Icon(Icons.incomplete_circle, color:Colors.red),
                    title: Text(widget.desire.title),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(widget.desire.returnTargetDateString()),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      width: 40,
                      height: 40,
                      color: ColorConverter.convertStringToColor(widget.desire.desireColor)
                  ),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Expanded(
                child:
                    Text("Status geral: ${defineGeneralStatus()}",textAlign: TextAlign.left,),
              ),
            ),
            Container(
              height: 1,
              decoration: BoxDecoration(
                border: Border.all(color: Color.fromRGBO(166, 166, 166, 1.0))
              ),
            )
          ],
        ),
      ),
      onTap: (){

      },
    );
  }
}

import 'package:flutter/material.dart';
import "package:provider/provider.dart";
import 'package:registrador_de_desejos/data/models/desire.dart';
import 'package:registrador_de_desejos/data/services/desire_dao.dart';
import 'package:registrador_de_desejos/pages/utils/color_converter.dart';
import 'package:registrador_de_desejos/pages/utils/colors_for_accomplishment.dart';
import 'package:registrador_de_desejos/pages/utils/form_desire_routed_arguments.dart';
import 'package:registrador_de_desejos/pages/widgets/delete_button.dart';
import 'package:registrador_de_desejos/providers/app_navigation_provider.dart';

class DesireItem extends StatefulWidget{
  final Desire desire;
  final Function reconfigureList;

  DesireItem({required this.desire,required this.reconfigureList});

  @override
  _DesireItem createState() => _DesireItem();
}

class _DesireItem extends State<DesireItem>{

  Desire? desireToOperate = null;
  bool desireDone = false;
  bool thereWasAToggleAction = false;

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
    if(dateIsBeforeNow(desireToOperate!.targetDate) && !desireToOperate!.accomplishedDesire){
      return "Desejo pendente de realização e com data alvo ultrapassada";
    }

    if((dateIsAfterNow(desireToOperate!.targetDate) ||
        dateIsAtTheSameMomentAsToday(desireToOperate!.targetDate))
            && !desireToOperate!.accomplishedDesire){
      return "Desejo pendente de realização";
    }

    if(dateIsAfterAnotherDate(desireToOperate!.targetDate,
        desireToOperate!.accomplishedDesireDateIfDesireWasAccomplished) &&
        desireToOperate!.accomplishedDesire){
      return "Desejo realizado antes da data alvo";
    }

    return "Desejo realizado";
  }

  void confirmDeleteOperation(){
    DesireDAO().delete(desireToOperate!.id!);

    Navigator.of(context).pop();
    Navigator.of(context).pop();

    widget.reconfigureList();
  }

  void showDeleteConfirmation(){
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text("Por favor, confirme a deleção"),
            content: SingleChildScrollView(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DeleteButton(operationToExecute: confirmDeleteOperation),
                  ElevatedButton(
                      onPressed:(){
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor:Colors.green
                      ),
                      child:Text("Cancelar")
                  )
                ],
              ),
            )
          );
        }
    );
  }

  void openOptionsOfOperations(){
      showDialog(
          context: context,
          builder: (context){
            return AlertDialog(
              insetPadding: EdgeInsets.zero,
              title: Text("Operaçãoes com o desejo:"),
              content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState){
                  return SingleChildScrollView(
                    child: Column(

                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Switch(
                                  value: desireDone,
                                  overlayColor: doneColor,
                                  trackColor: undoneColor,
                                  thumbColor: const MaterialStatePropertyAll<Color>(Colors.black),
                                  onChanged: (bool value) {
                                    setState(() {
                                      desireDone =value;
                                    });
                                  },
                              ),
                              Text(desireDone ? "Desejo realizado" : "Desejo não realizado"),

                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                              onPressed: (){
                                Navigator.of(context).pop();

                                Provider.of<AppNavigationProvider>(context, listen: false).changeScreen(1);
                                Navigator.of(context).pushReplacementNamed("/form_desire",
                                    arguments: FormDesireRoutedArguments(
                                        isToEdit: true,
                                        desire: desireToOperate
                                    )
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:Colors.green
                              ),
                              child: Text("Editar")
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DeleteButton(
                            operationToExecute: showDeleteConfirmation,
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
              actions: [
                ElevatedButton(
                    onPressed: (){
                      Navigator.of(context).pop();

                      if(desireToOperate!.accomplishedDesire != desireDone){
                        desireToOperate!.accomplishedDesire = desireDone;
                        DesireDAO().save(desireToOperate!);

                        setState(() {

                        });
                      }
                    },
                    child: Text("Fechar")
                )
              ],
            );
          });
  }

  @override
  Widget build(BuildContext context){
    desireToOperate = widget.desire;

    desireDone = desireToOperate!.accomplishedDesire;

    return InkWell(
      child:  Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    leading:desireToOperate!.accomplishedDesire ?
                    Icon(Icons.done,color: Colors.green,) : Icon(Icons.incomplete_circle, color:Colors.red),
                    title: Text(desireToOperate!.title),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(desireToOperate!.returnTargetDateString()),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      width: 40,
                      height: 40,
                      color: ColorConverter.convertStringToColor(desireToOperate!.desireColor)
                  ),
                )
              ],
            ),
            Container(
              padding: EdgeInsets.all(8.0),
              child: Flex(
                direction: Axis.horizontal,
                children: [
                  Expanded(
                    child:
                    Text("Status geral: ${defineGeneralStatus()}",textAlign: TextAlign.left,),
                  ),
                ],
                )
            ) ,
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
        desireDone = desireToOperate!.accomplishedDesire;
        openOptionsOfOperations();
      },
    );
  }
}
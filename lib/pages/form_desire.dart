
import 'package:flutter/material.dart';
import "package:provider/provider.dart";
import 'package:flutter/services.dart';
import "package:intl/intl.dart";
import 'package:registrador_de_desejos/data/models/desire.dart';
import 'package:registrador_de_desejos/data/services/desire_dao.dart';
import 'package:registrador_de_desejos/pages/utils/color_converter.dart';
import 'package:registrador_de_desejos/pages/utils/colors_for_accomplishment.dart';
import 'package:registrador_de_desejos/pages/utils/form_desire_routed_arguments.dart';
import 'package:registrador_de_desejos/pages/widgets/app_desires_bottom_navigation_bar.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:registrador_de_desejos/providers/app_navigation_provider.dart';

class FormDesire extends StatefulWidget {

  @override
  _FormDesire createState() => _FormDesire();
}

class _FormDesire extends State<FormDesire>{
  final _formKey = GlobalKey<FormState>();

  Color colorForDesire = Colors.amber;
  Color currentColor = Colors.amber;

  Desire? desireIfItIsToEdit = null;
  bool itIsToEdit = false;
  int? desireIdIfItIsToEdit = null;

  bool desireDone = false;
  bool wasInModalOrAccomplishedWasEdited = false;

  final TextEditingController numberController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController targetDateController = TextEditingController();

  DateTime targetDateObject = DateTime.now();
  String targetDateText = DateFormat("dd/MM/yyyy").format(DateTime.now());
  String colorString = "";

  void defineDefaultValuesWhenItIsToEdit(){
    desireIdIfItIsToEdit = desireIfItIsToEdit!.id;
    colorForDesire = convertStringToColor(desireIfItIsToEdit!.desireColor);
    currentColor = convertStringToColor(desireIfItIsToEdit!.desireColor);
    desireDone = desireIfItIsToEdit!.accomplishedDesire;

    targetDateObject = desireIfItIsToEdit!.targetDate;
    targetDateText = DateFormat("dd/MM/yyyy").format(desireIfItIsToEdit!.targetDate);
    colorString = desireIfItIsToEdit!.desireColor;

    targetDateController.text =  targetDateText;
    descriptionController.text = desireIfItIsToEdit!.description;
    titleController.text = desireIfItIsToEdit!.title;
    numberController.text = "${desireIfItIsToEdit!.desireNumber}";
  }

  Color convertStringToColor(String stringColor){
    return ColorConverter.convertStringToColor(stringColor);
  }

  String convertColorToString(Color color){
    return ColorConverter.convertColorToString(color);
  }

  void changeColor(Color color) {
    setState(() {
      colorForDesire = color;
      colorString = convertColorToString(color);
    });
  }

  void showColorDialog(){
    showDialog(
      builder: (context) {
        return AlertDialog(
          title: const Text('Escolha uma cor'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState){
              return  SingleChildScrollView(
              child: ColorPicker(
              pickerColor: colorForDesire,
        onColorChanged: changeColor,
        ));


            }),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Salvar'),
              onPressed: () {
                setState(()  {
                    currentColor = colorForDesire;
                    wasInModalOrAccomplishedWasEdited = true;
                });

                Navigator.of(context).pop();

              },
            ),
          ],
        );
      },
      context: context,
    );
  }

  @override
  Widget build(BuildContext context){
    final FormDesireRoutedArguments args = ModalRoute.of(context)!.settings.arguments as FormDesireRoutedArguments;

    targetDateController.text = targetDateText;

    if(args != null && args.desire != null && !wasInModalOrAccomplishedWasEdited){
      itIsToEdit = args!.isToEdit;
      desireIfItIsToEdit = args!.desire;
      defineDefaultValuesWhenItIsToEdit();
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(
              !args.isToEdit && !Provider.of<AppNavigationProvider>(context,listen:false).isEditing ?
              "Registre um desejo" :
              "Edite o desejo"
          )
        ),
        body:  SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: titleController,
                        decoration: InputDecoration(
                            labelText: "Título do desejo"
                        ),
                        validator: (value){
                          if(value != null){
                            if(value.isEmpty){
                              return "Campo precisa estar preenchido";
                            }
                          }

                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: descriptionController,
                        decoration: InputDecoration(
                            labelText: "Descrição do desejo"
                        ),
                        validator: (value){
                          if(value != null){
                            if(value.isEmpty){
                              return "Campo precisa estar preenchido";
                            }
                          }

                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: numberController,
                        onChanged: (value){
                            final number = int.tryParse(value);
                            if(number != null){
                              final text = number.clamp(1, 100).toString();
                              final selection = TextSelection(baseOffset: text.length, extentOffset: text.length);

                              numberController.value = TextEditingValue(
                                text: text,
                                selection: selection
                              );
                            }
                        },
                        decoration: InputDecoration(
                          labelText: "Número para classificar o desejo ( 1 a 100):"
                       ),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          // for below version 2 use this
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
// for version 2 and greater youcan also use this
                          FilteringTextInputFormatter.digitsOnly

                        ],
                        validator: (value){
                          if(value != null){
                            if(value.isEmpty){
                              return "Campo precisa estar preenchido";
                            }
                          }

                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: targetDateController,
                        decoration: InputDecoration(
                          icon: Icon(Icons.edit_calendar),
                          labelText: "Escolha uma 'data-alvo' para o desejo"
                        ),
                        readOnly: true,
                        onTap: () async{
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: targetDateObject,
                              firstDate: DateTime(1950),
                              lastDate:DateTime(2100)
                          );

                          if(pickedDate != null){
                            setState(() {
                              targetDateText = DateFormat("dd/MM/yyyy").format(pickedDate);
                              targetDateController.text = targetDateText;
                              targetDateObject = pickedDate;
                              wasInModalOrAccomplishedWasEdited = true;
                            });

                          }
                        },
                      )
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(

                            children: [
                              Text("Escolha uma cor:"),
                            ],
                          ),
                          Row(
                            children: [
                              InkWell(
                                onTap: showColorDialog,
                                child: Row(
                                  children: [
                                    ElevatedButton(
                                        onPressed: showColorDialog,
                                        child: Text("Escolher")
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Container(
                                        width: 30,
                                        height: 30,
                                        color: colorForDesire,
                                      ),
                                    )
                                  ],
                                ),
                              )

                            ],
                          )


                        ],
                      ) ,
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text("Desejo realizado ?")
                            ],
                          ),
                          Row(
                            children: [
                              Switch(
                                value: desireDone,
                                overlayColor: doneColor,
                                trackColor: undoneColor,
                                thumbColor: const MaterialStatePropertyAll<Color>(Colors.black),
                                onChanged: (bool value) {

                                    setState(() {
                                      desireDone = value;
                                      wasInModalOrAccomplishedWasEdited = true;
                                    });

                                },
                              ),
                            ],
                          )
                        ],
                      )
                    ),
                    ElevatedButton(
                        onPressed: (){
                          if(_formKey.currentState!.validate()){
                            Desire desire = Desire(
                                id: desireIdIfItIsToEdit,
                                title: titleController.text,
                                description: descriptionController.text,
                                desireNumber: int.parse(numberController.text),
                                desireColor: !colorString.isEmpty ? colorString : convertColorToString(colorForDesire),
                                accomplishedDesire: desireDone,
                                targetDate: targetDateObject,
                                accomplishedDesireDateIfDesireWasAccomplished: DateTime.now()
                            );

                            DesireDAO().save(desire);

                            if(!Provider.of<AppNavigationProvider>(context,listen:false).isEditing){
                              Provider.of<AppNavigationProvider>(context, listen: false).changeScreen(0);
                              Navigator.of(context).pushReplacementNamed("/home");
                            }
                          }

                        },
                        child: Text("Salvar")
                    )
                  ],
                )
            ),
          ),
        ),

      bottomNavigationBar: AppDesiresBottomNavigationBar(),
    );
  }
}

import 'package:flutter/material.dart';
import "package:provider/provider.dart";
import 'package:flutter/services.dart';
import 'package:registrador_de_desejos/data/models/desire.dart';
import 'package:registrador_de_desejos/data/services/desire_dao.dart';
import 'package:registrador_de_desejos/pages/utils/form_desire_routed_arguments.dart';
import 'package:registrador_de_desejos/pages/widgets/app_bottom_navigation_bar.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:registrador_de_desejos/providers/app_navigation_provider.dart';

class FormDesire extends StatefulWidget {

  @override
  _FormDesire createState() => _FormDesire();
}

class _FormDesire extends State<FormDesire>{
  final _formKey = GlobalKey<FormState>();
  Color colorForDesire = Color.fromRGBO(0, 0, 0, 1);
  Color currentColor = Color.fromRGBO(0, 0, 0, 1);

  bool desireDone = false;

  final TextEditingController numberController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String colorString = "";

  Color convertStringToColor(String stringColor){
    var hexColor = stringColor.replaceAll("#", "");
    if(hexColor.length == 6){
      hexColor= "FF"+hexColor;
    }
    if(hexColor.length == 8){
      return Color(int.parse("0x$hexColor"));
    }
    return Colors.black45;
  }

  String convertColorToString(Color color){
    return "#${color.value.toRadixString(16).substring(2,8)}";
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
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: colorForDesire,
              onColorChanged: changeColor,
            ),

          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Salvar'),
              onPressed: () {
                setState(() => currentColor = colorForDesire);
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

    final MaterialStateProperty<Color?> doneColor =
    MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.selected)) {
          return Colors.amber;
        }
        return null;
      },
    );

    final MaterialStateProperty<Color?> undoneColor =
    MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        // Material color when switch is selected.
        if (states.contains(MaterialState.selected)) {
          return Colors.amber.withOpacity(0.54);
        }
        // Material color when switch is disabled.
        if (states.contains(MaterialState.disabled)) {
          return Colors.grey.shade400;
        }
        // Otherwise return null to set default material color
        // for remaining states such as when the switch is
        // hovered, or focused.
        return null;
      },
    );

    return Scaffold(
        appBar: AppBar(
          title: Text(
              !args.isToEdit ?
              "Registre um desejo" :
              "Edite o desejo"
          )
        ),
        body: Padding(
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
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                          labelText: "Descrição do desejo"
                      ),
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
                    ),
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
                            ElevatedButton(
                                onPressed: showColorDialog,
                                child: Text("Escolher")
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
                              // This bool value toggles the switch.
                              value: desireDone,
                              overlayColor: doneColor,
                              trackColor: undoneColor,
                              thumbColor: const MaterialStatePropertyAll<Color>(Colors.black),
                              onChanged: (bool value) {
                                // This is called when the user toggles the switch.
                                setState(() {
                                  desireDone = value;
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
                          Desire desire = Desire(
                            title: titleController.text,
                            description: descriptionController.text,
                            desireNumber: int.parse(numberController.text),
                            desireColor: colorString,
                            accomplishedDesire: desireDone
                          );

                          DesireDAO().save(desire);

                          Provider.of<AppNavigationProvider>(context, listen: false).changeScreen(0);
                          Navigator.of(context).pushReplacementNamed("/home");
                      },
                      child: Text("Salvar")
                  )
                ],
              )
          ),
        ),

      bottomNavigationBar: AppBottomNavigationBar(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:registrador_de_desejos/pages/utils/form_desire_routed_arguments.dart';

// Bem, não é usado... Mas por que tirar é um código interessante ?:
class AppDrawer extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    return Drawer(
        child: ListView(
          children: [
            ListTile(
              leading: Icon(Icons.card_giftcard),
              title: Text("Desejo"),
              onTap: () {
                Navigator.pushNamed(context, "/home");
              }
            ),
            ListTile(
              leading: Icon(Icons.create),
              title: Text("Registrar desejo"),
              onTap: (){
                Navigator.pushNamed(
                    context,
                    "/form_desire",
                    arguments: FormDesireRoutedArguments(
                      isToEdit: false,
                      desire: null
                    )
                );
              },
            )
          ],
        )
    );
  }
}
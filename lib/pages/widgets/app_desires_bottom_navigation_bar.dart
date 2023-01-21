
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:registrador_de_desejos/pages/utils/form_desire_routed_arguments.dart';
import 'package:registrador_de_desejos/providers/app_navigation_provider.dart';
import "package:provider/provider.dart";

class AppDesiresBottomNavigationBar extends StatefulWidget {

  @override
  _AppDesiresBottomNavigationBar createState() => _AppDesiresBottomNavigationBar();
}

class _AppDesiresBottomNavigationBar extends State<AppDesiresBottomNavigationBar>{
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context){
    _selectedIndex =  Provider.of<AppNavigationProvider>(context, listen: false).currentPage;

    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "Desejos",
          backgroundColor: Colors.red,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.business),
          label: "Salvar desejo",
          backgroundColor: Colors.green,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.auto_graph),
          label:"Estatísticas",
          backgroundColor: Colors.cyan
        )
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.amber[800],
      onTap: (int index) {
        switch (index) {
          case 0:
            if(index != _selectedIndex){
              Navigator.of(context).pushReplacementNamed("/home");
            }

            break;
          case 1:

            if(index != _selectedIndex){
              Navigator.of(context).pushReplacementNamed("/form_desire",
                  arguments: FormDesireRoutedArguments(
                      isToEdit: false,
                      desire: null,
                  )
                 );
            }

            break;
          case 2:

            if(index != _selectedIndex){
                Navigator.of(context).pushReplacementNamed("/statistics");
            }

        }
        Provider.of<AppNavigationProvider>(context, listen: false).changeScreen(index);
      },
    );
  }
}
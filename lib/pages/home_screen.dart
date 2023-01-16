

import 'package:flutter/material.dart';
import 'package:registrador_de_desejos/pages/widgets/app_bottom_navigation_bar.dart';
import 'package:registrador_de_desejos/pages/widgets/app_drawer.dart';

class HomeScreen extends StatefulWidget{

  @override
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen>{

  @override
  Widget build(BuildContext context){
    return DefaultTabController(
      length: 4,
      child: Scaffold(
          appBar: AppBar(
            title: Text("Registrador de desejos"),
            bottom: TabBar(

                tabs:[
                  Tab(

                    text:"Todos",
                    icon: Icon(Icons.select_all),
                  ),
                  Tab(
                    text:"Hoje",
                    icon: Icon(Icons.today),
                  ),
                  Tab(
                    text:"Realizados",
                    icon: Icon(Icons.done),
                  ),
                  Tab(
                    text:"Não realizados",
                    icon: Icon(Icons.incomplete_circle),
                  ),

                ]
            ),
          ),
          body:TabBarView(
            children: [
              Text("TESTE"),
              Text("TESTE 1"),
              Text("TESTE 2"),
              Text("TESTE33 33"),
            ],
          ),

        bottomNavigationBar: AppBottomNavigationBar(),
      )

    );
  }
}
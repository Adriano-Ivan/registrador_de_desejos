

import 'package:flutter/material.dart';
import 'package:registrador_de_desejos/pages/widgets/app_desires_bottom_navigation_bar.dart';
import 'package:registrador_de_desejos/pages/widgets/app_drawer.dart';
import 'package:registrador_de_desejos/pages/widgets/desires/all_accomplished_desires.dart';
import 'package:registrador_de_desejos/pages/widgets/desires/all_desires.dart';
import 'package:registrador_de_desejos/pages/widgets/desires/all_not_accomplished_desires.dart';
import 'package:registrador_de_desejos/pages/widgets/desires/all_today_desires.dart';

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
                    text:"Pendentes",
                    icon: Icon(Icons.incomplete_circle),
                  ),

                ]
            ),
          ),
          body:TabBarView(
            children: [
              AllDesires(),
              AllTodayDesires(),
              AllAccomplishedDesires(),
              AllNotAccomplishedDesires(),
            ],
          ),

        bottomNavigationBar: AppDesiresBottomNavigationBar(),
      )

    );
  }
}
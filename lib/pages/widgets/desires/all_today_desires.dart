

import 'package:flutter/material.dart';
import 'package:registrador_de_desejos/pages/widgets/desires/desires_builder.dart';
import 'package:registrador_de_desejos/pages/widgets/desires/desires_screen_type.dart';

class AllTodayDesires extends StatefulWidget{

  @override
  _AllTodayDesires createState() => _AllTodayDesires();
}

class _AllTodayDesires extends State<AllTodayDesires>{

  void reconfigureList(){
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context){
    return DesiresBuilder(
        screenType: DesiresScreenType.todayDesires,
        reconfigureList: reconfigureList
    );
  }
}
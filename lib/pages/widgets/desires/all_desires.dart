
import 'package:flutter/material.dart';
import 'package:registrador_de_desejos/pages/widgets/desires/desires_builder.dart';
import 'package:registrador_de_desejos/pages/widgets/desires/desires_screen_type.dart';

class AllDesires extends StatefulWidget{

  @override
  _AllDesires createState() => _AllDesires();
}

class _AllDesires extends State<AllDesires>{

  void reconfigureList(){
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context){

    return DesiresBuilder(
        screenType: DesiresScreenType.allDesires,
        reconfigureList: reconfigureList
    );
  }
}
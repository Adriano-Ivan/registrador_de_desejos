

import 'package:flutter/material.dart';
import 'package:registrador_de_desejos/pages/widgets/desires/desires_builder.dart';
import 'package:registrador_de_desejos/pages/widgets/desires/desires_screen_type.dart';

class AllNotAccomplishedDesires extends StatefulWidget{

  @override
  _AllNotAccomplishedDesires createState() => _AllNotAccomplishedDesires();
}

class _AllNotAccomplishedDesires extends State<AllNotAccomplishedDesires>{

  void reconfigureList(){
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context){
    return DesiresBuilder(
        screenType: DesiresScreenType.allNotAccomplishedDesires,
        reconfigureList: reconfigureList
    );
  }
}


import 'package:flutter/cupertino.dart';
import 'package:registrador_de_desejos/pages/widgets/desires/desires_builder.dart';
import 'package:registrador_de_desejos/pages/widgets/desires/desires_screen_type.dart';

class AllAccomplishedDesires extends StatefulWidget{

  @override
  _AllAccomplishedDesires createState() => _AllAccomplishedDesires();
}

class _AllAccomplishedDesires extends State<AllAccomplishedDesires>{

  void reconfigureList(){
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context){
    return DesiresBuilder(
        screenType: DesiresScreenType.allAccomplishedDesires,
        reconfigureList: reconfigureList
    );
  }
}
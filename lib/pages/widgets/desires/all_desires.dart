
import 'package:flutter/material.dart';
import "package:provider/provider.dart";
import 'package:flutter/cupertino.dart';
import 'package:registrador_de_desejos/data/models/desire.dart';
import 'package:registrador_de_desejos/data/services/desire_dao.dart';
import 'package:registrador_de_desejos/pages/widgets/desires/desire_item.dart';
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
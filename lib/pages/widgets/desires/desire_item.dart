

import 'package:flutter/material.dart';

class DesireItem extends StatefulWidget{
  final String title;
  final bool accomplished;

  DesireItem({required this.title, required this.accomplished});

  @override
  _DesireItem createState() => _DesireItem();
}

class _DesireItem extends State<DesireItem>{

  @override
  Widget build(BuildContext context){
    return ListTile(
      leading:widget.accomplished ?  Icon(Icons.done,color: Colors.green,) : Icon(Icons.incomplete_circle, color:Colors.red),
      title: Text(widget.title),
      onTap: (){

      },
    );
  }
}
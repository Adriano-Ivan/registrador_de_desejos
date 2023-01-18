

import 'package:flutter/material.dart';

class ColorConverter{

  static Color convertStringToColor(String stringColor){
    var hexColor = stringColor.replaceAll("#", "");
    if(hexColor.length == 6){
      hexColor= "FF"+hexColor;
    }
    if(hexColor.length == 8){
      return Color(int.parse("0x$hexColor"));
    }
    return Colors.black45;
  }

  static String convertColorToString(Color color){
    return "#${color.value.toRadixString(16).substring(2,8)}";
  }
}
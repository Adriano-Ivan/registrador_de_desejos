

import 'package:flutter/cupertino.dart';

class AppNavigationProvider with ChangeNotifier{
  int currentPage = 0;
  bool isEditing = false;

  void changeScreen(int page){
    currentPage = page;
  }

  void changeIsEditing(bool isEditing){
    this.isEditing = isEditing;
  }
}
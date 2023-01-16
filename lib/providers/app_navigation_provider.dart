

import 'package:flutter/cupertino.dart';

class AppNavigationProvider with ChangeNotifier{
  int currentPage = 0;

  void changeScreen(int page){
    currentPage = page;
  }
}
import 'package:flutter/material.dart';

class HomeProvider with ChangeNotifier {
  int _pageindex = 0;
  set pageindex(int newpageindex) {
    _pageindex = newpageindex;
    notifyListeners();
  }

  int get pageindex => _pageindex;
}

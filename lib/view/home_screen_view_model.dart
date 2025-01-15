import 'dart:math';

import 'package:fyp2/provider/base_model.dart';
import 'package:flutter/cupertino.dart';

class HomeScreenViewModel extends BaseModel {
  //-------------VARIABLES-------------//
  int selectedIndex = 0;
  int randomNumber = 1;
  final PageController pageController = PageController();

  bool isACON = false;
  bool isFanON = false;
  bool isACFav = false;
  bool isFanFav = false;
  void generateRandomNumber() {
    randomNumber = Random().nextInt(8);
    notifyListeners();
  }

  void acFav() {
    isACFav = !isACFav;
    notifyListeners();
  }

  void fanFav() {
    isFanFav = !isFanFav;
    notifyListeners();
  }

  void acSwitch() {
    isACON = !isACON;
    notifyListeners();
  }

  void fanSwitch() {
    isFanON = !isFanON;
    notifyListeners();
  }

  ///On tapping bottom nav bar items
  void onItemTapped(int index) {
    selectedIndex = index;
    pageController.animateToPage(index,
        duration: const Duration(milliseconds: 500), curve: Curves.easeOut);
    notifyListeners();
  }
}

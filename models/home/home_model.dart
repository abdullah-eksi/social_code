import 'package:flutter/material.dart';

class HomeModel extends ChangeNotifier {
  HomeModel();

  static HomeModel instance() {
    return HomeModel();
  }
}

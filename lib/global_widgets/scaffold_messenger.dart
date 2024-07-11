
import 'package:flutter/material.dart';

import '../constants/fonts.dart';

class GlobalScaffoldMessenger {
  
  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  GlobalScaffoldMessenger._privateConstructor();
  static final GlobalScaffoldMessenger instance = GlobalScaffoldMessenger._privateConstructor();

  void showSnackBar(String message, [String type = 'info']) {
    Color bgColor = type == 'info' ? const Color(0xFFB9EBC8) : Colors.red;
    TextStyle textStyle = type == 'info' ? black(15) : white(15);
    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message, style: textStyle,),
        backgroundColor: bgColor,
      ),
    );
  }
}
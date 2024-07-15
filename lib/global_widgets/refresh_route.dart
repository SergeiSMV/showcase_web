
import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as html;

class RouterRefreshStream extends ChangeNotifier {
  RouterRefreshStream() {
    html.window.onPopState.listen((event) {
      // notifyListeners();
      // html.window.location.reload();
    });
  }
}
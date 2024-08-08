
// ignore_for_file: avoid_web_libraries_in_flutter

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:html' as html;

final screenWidthProvider = StateNotifierProvider<ScreenWidthNotifier, double>(
  (ref) {
    return ScreenWidthNotifier();
  },
);

class ScreenWidthNotifier extends StateNotifier<double> {
  ScreenWidthNotifier() : super(_loadState());

  static double _loadState() {
    final savedState = html.window.localStorage['screenWidth'];
    if (savedState != null) {
      return double.tryParse(savedState) ?? 0.0;
    }
    return 0.0;
  }

  void setWidth(double width) {
    if (width > state){
      state = width; 
      _saveState();
    }
  }

  void _saveState() {
    html.window.localStorage['screenWidth'] = state.toString();
  }
}
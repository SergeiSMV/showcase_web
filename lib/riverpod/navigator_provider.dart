
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedIndexProvider = StateProvider<int>((ref) => 0);
final lastIndexProvider = StateProvider<int>((ref) => 0);
final lastPathProvider = StateProvider<String>((ref) => '/');


final selectedSubCategoryProvider = StateProvider<int>((ref) => -1);


/*
final subCategoryDataProvider = StateNotifierProvider<CounterNotifier, List>((ref) {
  return CounterNotifier();
});


class CounterNotifier extends StateNotifier<List> {
  CounterNotifier() : super(_loadState());

  static List _loadState() {
    final savedState = html.window.localStorage['listState'];
    if (savedState != null) {
      return List.from(jsonDecode(savedState));
    }
    return [];
  }

  void addItem(Map item) {
    state = [...state, item];
    _saveState();
  }

  void removeItem() {
   if (state.isNotEmpty) {
      state = List.from(state)..removeAt(state.length - 1);
      _saveState();
    }
  }

  void clear() {
   if (state.isNotEmpty) {
      state = [];
      _saveState();
    }
  }

  void _saveState() {
    html.window.localStorage['listState'] = jsonEncode(state);
  }
}
*/
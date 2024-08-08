
// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:html';



// isExpanded для меню категорий
final categoryExpandedProvider = StateNotifierProvider<CategoryExpandedNotifier, bool>((ref) {
  return CategoryExpandedNotifier(ref);
});

class CategoryExpandedNotifier extends StateNotifier<bool> {
  final StateNotifierProviderRef _ref;
  CategoryExpandedNotifier(this._ref) : super(false) { _init(); }

  void _init(){
    bool result;
    int mainCategoryID = _ref.read(selectedMainCategoryProvider);
    mainCategoryID == -1 ? result = false : result = true;
    state = result;
  }

  void toggle() {
    state = !state;
  }

  void close() {
    state = false;
  }

  void open(){
    state = true;
  }

}

// isExpanded для меню подкатегорий
final subCategoryExpandedProvider = StateNotifierProvider<SubCategoryExpandedNotifier, bool>((ref) {
  return SubCategoryExpandedNotifier(ref);
});

class SubCategoryExpandedNotifier extends StateNotifier<bool> {
  final StateNotifierProviderRef _ref;
  SubCategoryExpandedNotifier(this._ref) : super(false) { _init(); }

  void _init(){
    bool result;
    int subCategoryID = _ref.read(selectedSubCategoryProvider);
    subCategoryID == -1 ? result = false : result = true;
    state = result;
  }

  void toggle() {
    state = !state;
  }

  void close() {
    state = false;
  }

  void open(){
    state = true;
  }
}


// id выбранной материнской категории
final selectedMainCategoryProvider = StateNotifierProvider<SelectedMainCategoryNotifier, int>((ref) {
  return SelectedMainCategoryNotifier();
});

class SelectedMainCategoryNotifier extends StateNotifier<int> {
  static const storageKey = 'mainCategoryID';
  SelectedMainCategoryNotifier() : super(-1) { _loadFromSessionStorage(); }

  // Загрузка состояния из sessionStorage
  void _loadFromSessionStorage() {
    final jsonString = window.sessionStorage[storageKey];
    if (jsonString != null) {
      int id = int.parse(jsonString);
      state = id;
    }
  }

  void toggle(int categoryID) {
    state = categoryID;
    _saveToSessionStorage();
  }

  void reset() {
    state = -1;
    _saveToSessionStorage();
  }

  // Сохранение состояния в sessionStorage
  void _saveToSessionStorage() {
    final jsonString = json.encode(state);
    window.sessionStorage[storageKey] = jsonString;
  }

}

// id выбранной подкатегории
final selectedSubCategoryProvider = StateNotifierProvider<SelectedSubCategoryNotifier, int>((ref) {
  return SelectedSubCategoryNotifier();
});

class SelectedSubCategoryNotifier extends StateNotifier<int> {
  static const storageKey = 'subCategoryID';
  SelectedSubCategoryNotifier() : super(-1) { _loadFromSessionStorage(); }

  // Загрузка состояния из sessionStorage
  void _loadFromSessionStorage() {
    final jsonString = window.sessionStorage[storageKey];
    if (jsonString != null) {
      int id = int.parse(jsonString);
      state = id;
    }
  }

  void toggle(int subCategoryID) {
    state = subCategoryID;
    _saveToSessionStorage();
  }

  void reset() {
    state = -1;
    _saveToSessionStorage();
  }

  // Сохранение состояния в sessionStorage
  void _saveToSessionStorage() {
    final jsonString = json.encode(state);
    window.sessionStorage[storageKey] = jsonString;
  }

}


/*
// навигация для подкатегорий ()
final categoriesIdPathProvider = StateNotifierProvider<CategoriesIdPathNotifier, List>((ref){
  return CategoriesIdPathNotifier();
});

class CategoriesIdPathNotifier extends StateNotifier<List> {
  CategoriesIdPathNotifier() : super([]);

  void addPath(int categoryID) {
    state = [...state, categoryID];
  }

  void clear() {
    state = [];
  }

  void removeLastPath() {
    if (state.isNotEmpty) {
      state = List.from(state)..removeLast();
    }
  }
}
*/


// справочник категорий id и наименование
final categoriesDirectoryProvider = StateNotifierProvider<CategoriesDirectoryNotifier, List>((ref){
  return CategoriesDirectoryNotifier();
});


class CategoriesDirectoryNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  static const storageKey = 'categoriesData';
  CategoriesDirectoryNotifier() : super([]) { _loadFromSessionStorage(); }


  // Загрузка состояния из sessionStorage
  void _loadFromSessionStorage() {
    final jsonString = window.sessionStorage[storageKey];
    if (jsonString != null) {
      try {
        final List<dynamic> jsonList = json.decode(jsonString);
        state = jsonList.map((category) => category as Map<String, dynamic>).toList();
      } catch (e) {
        // В случае ошибки при разборе JSON удаляем сохраненное значение
        window.sessionStorage.remove(storageKey);
      }
    }
  }

  // добавляем информацию о категории
  void addCategoryData(Map<String, dynamic> categoryData) {
    state = [...state, categoryData];
    _saveToSessionStorage();
  }
  
  // очистка хранилища браузера
  void clear() {
    state = [];
    window.sessionStorage.remove(storageKey);
  }

  // получаем информацию о категории
  Map selectedCategoryData(int categoryID){
    Map selectedCategory;
    try {
      selectedCategory = state.firstWhere((category) => category['id'] == categoryID);
    } catch (e) {
      selectedCategory = {};
    }
    return selectedCategory;
  }

  // Сохранение состояния в sessionStorage
  void _saveToSessionStorage() {
    final jsonString = json.encode(state);
    window.sessionStorage[storageKey] = jsonString;
  }

}

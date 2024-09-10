
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

import 'categories_provider.dart';



// isExpanded для меню категорий
final categoryExpandedProvider = StateNotifierProvider<CategoryExpandedNotifier, bool>((ref) {
  return CategoryExpandedNotifier();
});

class CategoryExpandedNotifier extends StateNotifier<bool> {
  CategoryExpandedNotifier() : super(true);

  void toggle() {
    state = !state;
  }

  void open() {
    state = true;
  }

  void close() {
    state = false;
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



// id выбранной метринской категории
final selectedMainCategoryProvider = StateNotifierProvider<SelectedMainCategoryNotifier, int>((ref) {
  return SelectedMainCategoryNotifier(ref);
});

class SelectedMainCategoryNotifier extends StateNotifier<int> {
  final StateNotifierProviderRef _ref;
  static const storageKey = 'mainCategoryID';
  SelectedMainCategoryNotifier(this._ref) : super(0) {_loadFromSessionStorage();}

  // Загрузка состояния из sessionStorage
  void _loadFromSessionStorage() {
    final jsonString = window.sessionStorage[storageKey];
    if (jsonString != null) {
      int id = int.parse(jsonString);
      state = id;
    }
  }


  void toggle(int categoryID) {
    final mainCategories = _ref.read(categoriesProvider);
    for (var category in mainCategories) {
      if (category['category_id'] == categoryID) {
        category['children'] == null ? 
          _ref.read(subCategoryExpandedProvider.notifier).close() 
          : 
          {
            _ref.read(selectedSubCategoryProvider.notifier).toggle(categoryID),
            _ref.read(subCategoryExpandedProvider.notifier).open()
          };
        state = categoryID;
        _saveToSessionStorage();
        break;
      }
    }
  }

  // Сохранение состояния в sessionStorage
  void _saveToSessionStorage() {
    final jsonString = json.encode(state);
    window.sessionStorage[storageKey] = jsonString;
  }

}



// id выбранной ПОДкатегории
final selectedSubCategoryProvider = StateNotifierProvider<SelectedSubCategoryNotifier, int>((ref) {
  return SelectedSubCategoryNotifier();
});

class SelectedSubCategoryNotifier extends StateNotifier<int> {
  SelectedSubCategoryNotifier() : super(-1);

  void toggle(int subCategoryID) {
    state = subCategoryID;
  }

}



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


import 'package:flutter_riverpod/flutter_riverpod.dart';

// final categoriesMenuProvider = StateProvider<bool>((ref) => true);

// состояние isExpanded для меню категорий
final categoriesMenuProvider = StateNotifierProvider<CategoriesMenuNotifier, bool>((ref) {
  return CategoriesMenuNotifier();
});

class CategoriesMenuNotifier extends StateNotifier<bool> {
  CategoriesMenuNotifier() : super(false);

  void toggle() {
    state = !state;
  }
}

// состояние isExpanded для меню подкатегорий
final subCategoryMenuProvider = StateNotifierProvider<SubCategoryMenuNotifier, bool>((ref) {
  return SubCategoryMenuNotifier();
});

class SubCategoryMenuNotifier extends StateNotifier<bool> {
  SubCategoryMenuNotifier() : super(false);

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


final selectedCategoryProvider = StateNotifierProvider<SelectedCategoryNotifier, int>((ref) {
  return SelectedCategoryNotifier();
});

class SelectedCategoryNotifier extends StateNotifier<int> {
  SelectedCategoryNotifier() : super(-1);

  void toggle(int categyID) {
    state = categyID;
  }
}


final selectedIndexCategoryProvider = StateNotifierProvider<SelectedIndexCategoryNotifier, int>((ref) {
  return SelectedIndexCategoryNotifier();
});

class SelectedIndexCategoryNotifier extends StateNotifier<int> {
  SelectedIndexCategoryNotifier() : super(-1);

  void toggle(int selectedIndex) {
    state = selectedIndex;
  }
}


final categoryPathProvider = StateNotifierProvider<CategoryPathNotifier, List>((ref){
  return CategoryPathNotifier();
});

class CategoryPathNotifier extends StateNotifier<List> {
  CategoryPathNotifier() : super([]);

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
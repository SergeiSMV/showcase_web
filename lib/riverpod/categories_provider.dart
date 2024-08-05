
// провайдер категорий
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/goods_implements.dart';


// состояние всех категорий
final categoriesProvider = StateProvider<List>((ref) => []);

final baseCategoriesProvider = FutureProvider.autoDispose((ref) async {
  final result = await GoodsImplements().backendCategories();
  ref.read(categoriesProvider.notifier).state = result;
});

// состояние категории по id
final categoryProvider = StateProvider<Map<String, dynamic>>((ref) => {});

final baseCategoryProvider = FutureProvider.family.autoDispose((ref, int categoryID) async {
  final result = await GoodsImplements().backendCategory(categoryID);
  result.isEmpty ? ref.read(categoryProvider.notifier).state = {} : ref.read(categoryProvider.notifier).state = result[0];
});
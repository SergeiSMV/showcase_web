
// провайдер категорий
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/goods_implements.dart';

final categoriesProvider = StateProvider<List>((ref) => []);

final baseCategoriesProvider = FutureProvider.autoDispose((ref) async {
  final result = await GoodsImplements().backendCategories();
  ref.read(categoriesProvider.notifier).state = result;
});
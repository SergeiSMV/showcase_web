
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:showcase_web/data/repositories/goods_implements.dart';



final productSearchHintProvider = StateProvider<String>((ref) => '');


// состояние товаров по указанному id
final productsProvider = StateProvider<List>((ref) => []);

final baseProductsProvider = FutureProvider.autoDispose.family<List, int>((ref, categoryID) async {
  final List result = await GoodsImplements().backendProducts(categoryID, ref);
  ref.read(productsProvider.notifier).state = result;
  return result;
});
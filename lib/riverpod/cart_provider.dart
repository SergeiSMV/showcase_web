
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';

import '../data/repositories/cart_implements.dart';


// провайдер корзины
final cartProvider = StateProvider<List>((ref) => []);

// провайдер бэйджика корзины
final cartBadgesProvider = StateProvider<int>((ref) => 0);

final baseCartsProvider = FutureProvider.autoDispose((ref) async {
  final listEquality = const DeepCollectionEquality().equals;
  final List<dynamic> currentResult = ref.read(cartProvider);
  final result = await CartImplements().backendGetCart(ref);
  if (listEquality(result, currentResult)) {
    null;
  } else {
    ref.read(cartBadgesProvider.notifier).state = result.length;
    ref.read(cartProvider.notifier).state = result;
  }
  return result;
});
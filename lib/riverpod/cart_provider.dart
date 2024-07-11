
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/cart_implements.dart';


// провайдер корзины
final cartProvider = StateProvider<List>((ref) => []);

// провайдер бэйджика корзины
final cartBadgesProvider = StateProvider<int>((ref) => 0);

final baseCartsProvider = FutureProvider.autoDispose((ref) async {
  final result = await CartImplements().backendGetCart(ref);
  ref.read(cartBadgesProvider.notifier).state = result.length;
  ref.read(cartProvider.notifier).state = result;
  return result;
});
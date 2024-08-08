



import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class CartRepository {

  Future<List> backendGetCart(AutoDisposeFutureProviderRef ref);

  Future<List> putIncrement(int productID, WidgetRef ref);

  Future<List> putDecrement(int productID, int cartQuantity, WidgetRef ref);

  Future<List> putExact(int productID, int exact, WidgetRef ref);

}
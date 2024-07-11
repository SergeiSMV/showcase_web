



import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class CartRepository {

  Future<List> backendGetCart(AutoDisposeFutureProviderRef ref);

}
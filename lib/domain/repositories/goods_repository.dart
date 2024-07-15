



import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class GoodsRepository{

  Future<List> backendCategories();

  Future<List> backendProducts(int categoryID, AutoDisposeFutureProviderRef ref);

}
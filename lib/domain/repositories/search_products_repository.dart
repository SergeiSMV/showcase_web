
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class SerachProductsRepository {

  Future<List> searchProduct(String keywords, WidgetRef ref);

  Future<List> searchProductByCategory(int categoryID, String keywords, WidgetRef ref);

}
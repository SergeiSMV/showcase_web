


import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/api_config.dart';
import '../../domain/repositories/search_products_repository.dart';
import '../../global_widgets/scaffold_messenger.dart';
import '../dio.dart';
import 'usecase_implements.dart';

class SearchProductsImplements extends SerachProductsRepository {
  
  
  @override
  Future<List> searchProduct(String keywords, WidgetRef ref) async {
    final dioClient = DioClient();
    final dio = dioClient.dio;
    try {
      Response result = await dio.get('$apiURL$getBackSearchProduct/$keywords');
      return List.from(result.data);
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response!.statusCode == 403 || e.response!.statusCode == 401){
          GlobalScaffoldMessenger.instance.showSnackBar("Необходимо повторно авторизоваться!", 'error');
          UseCaseImplements().unloginWidgetRef(ref);
        }
      }
      return [];
    }
  }
  
  @override
  Future<List> searchProductByCategory(int categoryID, String keywords, WidgetRef ref) async {
    final dioClient = DioClient();
    final dio = dioClient.dio;
    try {
      Response result = await dio.get('$apiURL$getBackSearchByCategory/$categoryID/$keywords');
      return List.from(result.data);
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response!.statusCode == 403 || e.response!.statusCode == 401){
          GlobalScaffoldMessenger.instance.showSnackBar("Необходимо повторно авторизоваться!", 'error');
          UseCaseImplements().unloginWidgetRef(ref);
        } else {
          GlobalScaffoldMessenger.instance.showSnackBar("Ошибка: $e", 'error');
        }
      }
      return [];
    }
  }



}
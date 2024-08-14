
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/api_config.dart';
import '../../domain/repositories/goods_repository.dart';
import '../../global_widgets/scaffold_messenger.dart';
import '../dio.dart';
import 'hive_implements.dart';

class GoodsImplements extends GoodsRepository{
  
  
  @override
  Future<List> backendCategories() async {
    final dioClient = DioClient();
    final dio = dioClient.dio;
    try {
      Response response = await dio.get(getBackCategories);
      return response.data ?? [];
    } on DioException catch (e) {
      log(e.toString(), name: 'ERROR');
      GlobalScaffoldMessenger.instance.showSnackBar("Ошибка: ${e.message}", 'error');
      return [];
    }
  }


  @override
  Future<List> backendCategory(int categoryID) async {
    final dioClient = DioClient();
    final dio = dioClient.dio;
    try {
      Response response = await dio.get('$getBackCategories/$categoryID');
      return response.data ?? [];
    } on DioException catch (e) {
      log(e.toString(), name: 'ERROR');
      GlobalScaffoldMessenger.instance.showSnackBar("Ошибка: ${e.message}", 'error');
      return [];
    }
  }


  @override
  Future<List> backendProducts(int categoryID, AutoDisposeFutureProviderRef ref) async {
    String token = await HiveImplements().getToken();
    final dioClient = DioClient();
    final dio = dioClient.dio;
    try {
      Response response = token.isEmpty ? await dio.get('$getBackProducts/$categoryID') :
      await dio.get('$apiURL$getBackProducts/$categoryID', options: Options(headers: {'Authorization': 'Bearer $token',}));
      return response.data ?? [];
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response!.statusCode == 403 || e.response!.statusCode == 401){
          GlobalScaffoldMessenger.instance.showSnackBar("Необходимо повторно авторизоваться!", 'error');
          // UseCaseImplements().unloginProviderRef(ref);
        }
        if (e.response!.statusCode == 422){
          GlobalScaffoldMessenger.instance.showSnackBar("Ошибка валидации!", 'error');
        }
        return [];
      } else {
        GlobalScaffoldMessenger.instance.showSnackBar("Ошибка: ${e.message}", 'error');
        return [];
      }
    }
  }

}
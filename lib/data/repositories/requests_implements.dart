


import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/api_config.dart';
import '../../domain/repositories/requests_repository.dart';
import '../../widgets/scaffold_messenger.dart';
import '../dio.dart';
import 'hive_implements.dart';

class RequestsImplements extends RequestsRepository{

  @override
  Future<List> backendGetRequests(AutoDisposeFutureProviderRef ref) async {
    final dioClient = DioClient();
    final dio = dioClient.dio;
    String token = await HiveImplements().getToken();
    try {
      Response response = await dio.get(getBackRequests, options: Options(headers: {'Authorization': 'Bearer $token',}));
      return List.from(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response!.statusCode == 403 || e.response!.statusCode == 401){
          GlobalScaffoldMessenger.instance.showSnackBar("Необходимо повторно авторизоваться!", 'error');
          // UseCaseImplements().unloginProviderRef(ref);
        } else {
          GlobalScaffoldMessenger.instance.showSnackBar("Ошибка: $e", 'error');
        }
      }
      return [];
    }
  }

  @override
  Future<void> newRequests(int shipID, String comment, WidgetRef ref) async {
    final dioClient = DioClient();
    final dio = dioClient.dio;
    String token = await HiveImplements().getToken();
    Map putData = {
      "ship_to_id": shipID,
      "comment": comment,
    };
    try {
      await dio.put('$apiURL$putBackNewRequests', data: putData, options: Options(headers: {'Authorization': 'Bearer $token',}));
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response!.statusCode == 403 || e.response!.statusCode == 401){
          GlobalScaffoldMessenger.instance.showSnackBar("Необходимо повторно авторизоваться!", 'error');
          // UseCaseImplements().unloginWidgetRef(ref);
        }
        if (e.response!.statusCode == 404) {
          GlobalScaffoldMessenger.instance.showSnackBar("Ошибка: Заявка не может быть обработана! Недостаточно товара на складе!", 'error');
        } else {
          GlobalScaffoldMessenger.instance.showSnackBar("Ошибка: ${e.message}", 'error');
        }
      } else {
        GlobalScaffoldMessenger.instance.showSnackBar("Ошибка: ${e.message}", 'error');
      }
    }

  }

}
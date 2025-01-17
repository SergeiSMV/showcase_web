
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/api_config.dart';
import '../../domain/repositories/response_repository.dart';
import '../../widgets/scaffold_messenger.dart';
import '../dio.dart';
import 'hive_implements.dart';

class ResposeImplements extends ResponseRepository{

  @override
  Future<List> backendGetResponses(AutoDisposeFutureProviderRef ref) async {
    final dioClient = DioClient();
    final dio = dioClient.dio;
    String token = await HiveImplements().getToken();
    try {
      Response response = await dio.get(getBackResponses, options: Options(headers: {'Authorization': 'Bearer $token',}));
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

  

}
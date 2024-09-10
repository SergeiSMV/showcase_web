
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/api_config.dart';
import '../../domain/repositories/address_repository.dart';
import '../../widgets/scaffold_messenger.dart';
import '../dio.dart';
import 'hive_implements.dart';

class AddressImplements extends AddressRepository {

  @override
  Future<List> getClientAddress(AutoDisposeFutureProviderRef ref) async {
    final dioClient = DioClient();
    final dio = dioClient.dio;
    String token = await HiveImplements().getToken();
    try {
      Response response = await dio.get('$apiURL$backClientAddress', options: Options(headers: {'Authorization': 'Bearer $token',}));
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
  Future<List> patchClientAddress(int shipID, bool isDelete, bool isDefault, WidgetRef ref) async {
    final dioClient = DioClient();
    final dio = dioClient.dio;
    String token = await HiveImplements().getToken();
    Map putData = {
      "ship_to_id": shipID,
      "delete": isDelete,
      "default": isDefault
    };
    try {
      Response response = await dio.patch('$apiURL$backClientAddress', data: putData, options: Options(headers: {'Authorization': 'Bearer $token',}));
      return List.from(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response!.statusCode == 403 || e.response!.statusCode == 401){
          GlobalScaffoldMessenger.instance.showSnackBar("Необходимо повторно авторизоваться!", 'error');
          // UseCaseImplements().unloginWidgetRef(ref);
        } else {
          GlobalScaffoldMessenger.instance.showSnackBar("Ошибка: $e", 'error');
        }
      }
      return [];
    }
  }


  @override
  Future<List> addClientAddress(String address, WidgetRef ref) async {
    final dioClient = DioClient();
    final dio = dioClient.dio;
    String token = await HiveImplements().getToken();
    Map putData = {
      "address": address
    };
    try {
      Response response = await dio.put('$apiURL$backClientAddress', data: putData, options: Options(headers: {'Authorization': 'Bearer $token',}));
      return List.from(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response!.statusCode == 403 || e.response!.statusCode == 401){
          GlobalScaffoldMessenger.instance.showSnackBar("Необходимо повторно авторизоваться!", 'error');
          // UseCaseImplements().unloginWidgetRef(ref);
        } else {
          GlobalScaffoldMessenger.instance.showSnackBar("Ошибка: $e", 'error');
        }
      }
      return [];
    }
  }

}
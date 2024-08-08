
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/api_config.dart';
import '../../domain/repositories/cart_repository.dart';
import '../../global_widgets/scaffold_messenger.dart';
import '../dio.dart';
import 'hive_implements.dart';

class CartImplements extends CartRepository{

  @override
  Future<List> backendGetCart(AutoDisposeFutureProviderRef ref) async {
    final dioClient = DioClient();
    final dio = dioClient.dio;
    String token = await HiveImplements().getToken();
    try {
      Response response = await dio.get(
        cart, options: Options(headers: {'Authorization': 'Bearer $token',})
      );
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


  @override
  Future<List> putIncrement(int productID, WidgetRef ref) async {
    final dioClient = DioClient();
    final dio = dioClient.dio;
    String token = await HiveImplements().getToken();
    Map putData = {
      "product_id": productID,
      "quantity_incr": 1,
      "quantity_exact": null
    };
    try {
      Response response = await dio.put(
        cart, 
        data: putData,
        options: Options(headers: {'Authorization': 'Bearer $token',})
      );
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

  @override
  Future<List> putDecrement(int productID, int cartQuantity, WidgetRef ref) async {
    final dioClient = DioClient();
    final dio = dioClient.dio;
    String token = await HiveImplements().getToken();
    int? quantityExact = cartQuantity == 1 ? 0 : null;
    int? quantityIncr = cartQuantity == 1 ? null : -1;
    Map putData = {
      "product_id": productID,
      "quantity_incr": quantityIncr,
      "quantity_exact": quantityExact
    };
    try {
      Response response = await dio.put(
        cart, 
        data: putData,
        options: Options(headers: {'Authorization': 'Bearer $token',})
      );
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

  @override
  Future<List> putExact(int productID, int exact, WidgetRef ref) async {
    final dioClient = DioClient();
    final dio = dioClient.dio;
    String token = await HiveImplements().getToken();
    int? quantityExact = exact;
    int? quantityIncr;
    Map putData = {
      "product_id": productID,
      "quantity_incr": quantityIncr,
      "quantity_exact": quantityExact
    };
    try {
      Response response = await dio.put('$apiURL$cart', data: putData, options: Options(headers: {'Authorization': 'Bearer $token',}));
      return response.data ?? [];
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response!.statusCode == 403 || e.response!.statusCode == 401){
          GlobalScaffoldMessenger.instance.showSnackBar("Необходимо повторно авторизоваться!", 'error');
          // UseCaseImplements().unloginWidgetRef(ref);
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
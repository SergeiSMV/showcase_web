
import 'package:dio/dio.dart';

import '../../constants/api_config.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../widgets/scaffold_messenger.dart';
import '../dio.dart';

class AuthImplements extends AuthRepository{

  @override
  Future<String> authorization(String login, String pass) async {
    final dioClient = DioClient();
    final dio = dioClient.dio;
    final Map data = {
      "login": login,
      "password": pass
    };
    try {
      Response response = await dio.post(auth, data: data);
      return response.data.toString();
    } on DioException catch (e) {

      if (e.response != null) {
        if (e.response!.statusCode == 403 || e.response!.statusCode == 401){
          GlobalScaffoldMessenger.instance.showSnackBar("Не верный логин или пароль!", 'error');
        }
        if (e.response!.statusCode == 422){
          GlobalScaffoldMessenger.instance.showSnackBar("Ошибка валидации!", 'error');
        }
        return '';
      } else {
        GlobalScaffoldMessenger.instance.showSnackBar("Ошибка: ${e.message}", 'error');
        return '';
      }
    }
  }

}
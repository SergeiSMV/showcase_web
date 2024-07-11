
import 'package:dio/dio.dart';

import '../constants/api_config.dart';

class DioClient {

  // приватное статическое поле для хранения экземпляра класса
  static DioClient? _instance;
  late Dio _dio;

  // приватный конструктор
  DioClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: apiURL,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
        },
      )
    );
  }

  // публичный фабричный конструктор
  factory DioClient() {
    // если экземпляра еще нет, создаем его
    _instance ??= DioClient._internal();
    return _instance!;
  }

  // метод для получения Dio
  Dio get dio => _dio;

}
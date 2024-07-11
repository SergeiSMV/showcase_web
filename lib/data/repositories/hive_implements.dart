import 'package:hive_flutter/hive_flutter.dart';

import '../../domain/repositories/hive_repository.dart';



class HiveImplements extends HiveRepository{

  final Box hive = Hive.box('mainStorage');

  @override
  Future<void> saveToken(String token) async {
    await hive.put('token', token);
  }

  @override
  Future<String> getToken() async {
    String token = await hive.get('token', defaultValue: '');
    return token;
  }
  
}
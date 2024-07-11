

abstract class HiveRepository{

  Future<void> saveToken(String token);

  Future<String> getToken();

}


abstract class AuthRepository{
  
  Future<String> authorization(String login, String pass);
  
}
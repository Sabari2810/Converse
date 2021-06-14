import 'package:flutter_chat/models/UserModel.dart';
import 'package:flutter_chat/services/Auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegistrationViewModel{


  Future<dynamic> registerUsingEmail(String username,String email,String password) async{
    var res = await AuthUser().registerUsingEmail(username,email, password);
    return res;
  }

  Future<dynamic> signInUsingEmail(String email,String password) async{
    return await AuthUser().sigInUsingEmail(email, password);
  }

  Future<void> signOut() async{
    await AuthUser().signOut();
  }

  Future<void> setUserIdInLocalStorage(String uid) async{
    var prefs = await SharedPreferences.getInstance();
    String key = "flutter_chat_user_id";
    prefs.setString(key, uid);
  }

}
import 'package:shared_preferences/shared_preferences.dart';

class KeyStore {
  static const tokenKey = "tokenKey";
    static const usernameKey = "usernameKey";
      static const passwordKey = "passwordKey";
  static const isLoggedInKey = "isLoggedInKey";

  static Future<SharedPreferences> initPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    return pref;
  }

  static Future storeString(key, data) async {
    var pref = await initPref();
    pref.setString("$key", "$data");
  }
   static Future storeBool(key, data) async {
    var pref = await initPref();
    pref.setBool(key, data);
  }
    static Future<bool> checkToken() async {
  
    var pref = await initPref();
   if(pref.containsKey(isLoggedInKey)){
    return true;
   }else{
    return false;
   }
  }

   static Future<String?> getToken() async {
  
    var pref = await initPref();
   if(pref.containsKey(tokenKey)){
    return pref.getString(tokenKey);
   }else{
    return "";
   }
  }
     static Future remove(key) async {
    var pref = await initPref();
    pref.remove(key);
  }
}

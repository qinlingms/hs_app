import 'package:shared_preferences/shared_preferences.dart';

class LoginStorage{
    static const sessionId = 'sessionId';
    static const uid = "uid";
    static const authToken = "authToken";
    static const ttl = "ttl";

    static void saveLoginInfo({
        required String sessionId,
        required String uid,
        required String authToken,
        required int ttl,
    }) async{
      final prefs = await SharedPreferences.getInstance();
      prefs.setString(LoginStorage.sessionId, sessionId);
      prefs.setString(LoginStorage.uid, uid);
      prefs.setString(LoginStorage.authToken, authToken);
      prefs.setInt(LoginStorage.ttl, ttl);
    }

    static Future<void> clearLoginInfo() async{
      final prefs = await SharedPreferences.getInstance();
      prefs.remove(LoginStorage.sessionId);
      prefs.remove(LoginStorage.uid);
      prefs.remove(LoginStorage.authToken);
      prefs.remove(LoginStorage.ttl);
    }

    static Future<String?> getSessionId() async{
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(LoginStorage.sessionId);
    }

    static Future<String?> getUid() async{
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(LoginStorage.uid);
    }

    static Future<String?> getAuthToken() async{
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(LoginStorage.authToken);
    }

    static Future<int?> getTtl() async{
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(LoginStorage.ttl);
    }

    static Future<bool> isLogin() async{
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey(LoginStorage.sessionId);
    }
}
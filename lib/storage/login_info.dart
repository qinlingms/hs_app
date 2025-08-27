import 'package:shared_preferences/shared_preferences.dart';

class LoginInfo{
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
      prefs.setString(LoginInfo.sessionId, sessionId);
      prefs.setString(LoginInfo.uid, uid);
      prefs.setString(LoginInfo.authToken, authToken);
      prefs.setInt(LoginInfo.ttl, ttl);
    }

    static Future<void> clearLoginInfo() async{
      final prefs = await SharedPreferences.getInstance();
      prefs.remove(LoginInfo.sessionId);
      prefs.remove(LoginInfo.uid);
      prefs.remove(LoginInfo.authToken);
      prefs.remove(LoginInfo.ttl);
    }

    static Future<String?> getSessionId() async{
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(LoginInfo.sessionId);
    }

    static Future<String?> getUid() async{
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(LoginInfo.uid);
    }

    static Future<String?> getAuthToken() async{
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(LoginInfo.authToken);
    }

    static Future<int?> getTtl() async{
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(LoginInfo.ttl);
    }

    static Future<bool> isLogin() async{
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey(LoginInfo.sessionId);
    }
}
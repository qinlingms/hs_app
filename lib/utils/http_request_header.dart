import 'dart:convert';
import 'dart:ffi';

import 'package:app_hs/log/logger.dart';
import 'package:app_hs/storage/login_storage.dart';
import 'package:app_hs/utils/device.dart';
import 'package:crypto/crypto.dart';

class HttpRequestHeader {
  static Map<String, dynamic> getNormalHeader() {
    return {
      "X-UUID": Device.deviceUUid(),
      'User-Agent': userAgent(),
      'Referer': reffer(),
    };
  }

  static Future<Map<String, dynamic>> getSignHeader(String data) async {
    String authToken = await LoginStorage.getAuthToken() ?? "";
    String sessionId = await LoginStorage.getSessionId() ?? "";
    final salt =
        md5
            .convert(utf8.encoder.convert(authToken));/*注意此处不转hex字符串*/

    final dataBytes = utf8.encoder.convert(data);
    List<int> saltAndDataBytes = [];
    saltAndDataBytes.addAll(salt.bytes);
    saltAndDataBytes.addAll(dataBytes);
    Digest sign = sha256.convert(saltAndDataBytes);
    String base64Sign = base64Encode(sign.bytes);

    logger.d("authToken: $authToken; sessionId: $sessionId; base64Sign: $base64Sign");
    return {
      "X-UUID": Device.deviceUUid(),
      'User-Agent': userAgent(),
      'Referer': reffer(),
      'X-SESSIONID': sessionId,
      "X-SIGN": base64Sign,
    };
  }

  static String userAgent() {
    return "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, likeGecko) Chrome/129.0.0.0 Safari/537.36";
  }

  static String reffer() {
    return "http://c1.ysepan.com";
  }
}

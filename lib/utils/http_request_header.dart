import 'dart:convert';

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
            .convert(utf8.encoder.convert(authToken))
            .toString(); /*注意此处不转hex字符串*/
    String signStr = salt + data;
    String sign = sha256.convert(utf8.encoder.convert(signStr)).toString();
    String base64Sign = base64Encode(utf8.encode(sign));

    logger.d("authToken: $authToken; sessionId: $sessionId; salt: $salt; data:$data salt+data: $signStr sign: $sign base64Sign: $base64Sign");
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

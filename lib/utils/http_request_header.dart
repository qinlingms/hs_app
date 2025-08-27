import 'package:app_hs/utils/device.dart';

class HttpRequestHeader {
  static Map<String, dynamic> getNormalHeader() {
    return {
      "X-UUID": Device.deviceUUid(),
      'User-Agent':userAgent(),
      'Referer': reffer(),
    };
  }

  // static Map<String, dynamic> getSignHeader() {
  //   return {
  //     "X-UUID": Device.deviceUUid(),
  //     'User-Agent':userAgent(),
  //     'Referer': reffer(),
  //   };
  // }
  static String userAgent(){
    return "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, likeGecko) Chrome/129.0.0.0 Safari/537.36";
  }
  static String reffer(){
    return "http://c1.ysepan.com";
  }
}

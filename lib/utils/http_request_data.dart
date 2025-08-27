import 'package:app_hs/utils/device.dart';

class HttpRequestData {
  static Map<String, dynamic> build({dynamic data}) {
    Map<String, dynamic> dataObj = {
      "appVer": Device.appVersion(),
      "resId": Device.resId(),
      "timeStamp": DateTime.now().millisecondsSinceEpoch ~/ 1000,
      "data": data,
    };
    return dataObj;
  }
}

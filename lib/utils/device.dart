import 'package:app_hs/log/logger.dart';
import 'package:app_hs/service/device_identifier_service.dart';
import 'package:app_hs/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Device {

  // 设备唯一标识
  static String deviceUUid(){
    logger.d("deviceUUid: ",getIt<DeviceIdentifierService>().getUniqueDeviceId());
    return "SDFFCXSFFFC1C8dF";
  }

  // app 版本
  static String appVersion(){
    return "v1.1.2";
  }
  // 渠道id
  static String resId(){
    return "6522";
  }


  // 检查并设置为首次启动
  static Future<bool> checkFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    // 检查是否存在首次启动标记
    bool isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;
    return isFirstLaunch;
  }

  // 重置首次启动标记
  static Future<void> setFirstLaunch(bool isFirst) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstLaunch', isFirst);
  }


}

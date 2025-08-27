import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

class DeviceIdentifierService {
  final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();

  // 获取设备唯一标识
  Future<String?> getUniqueDeviceId() async {
    if (kIsWeb) {
      // Web平台没有真正的唯一标识，可使用浏览器相关信息组合
      final webInfo = await _deviceInfoPlugin.webBrowserInfo;
      return '${webInfo.userAgent}-${webInfo.platform}';
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      // Android平台使用AndroidId
      final androidInfo = await _deviceInfoPlugin.androidInfo;
      return androidInfo.id; // 设备恢复出厂设置后会改变
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      // iOS平台使用identifierForVendor
      final iosInfo = await _deviceInfoPlugin.iosInfo;
      return iosInfo.identifierForVendor; // 卸载所有同一开发者的App后会改变
    } else if (defaultTargetPlatform == TargetPlatform.macOS) {
      final macInfo = await _deviceInfoPlugin.macOsInfo;
      return macInfo.systemGUID;
    } else if (defaultTargetPlatform == TargetPlatform.windows) {
      final windowsInfo = await _deviceInfoPlugin.windowsInfo;
      return windowsInfo.deviceId;
    } else if (defaultTargetPlatform == TargetPlatform.linux) {
      final linuxInfo = await _deviceInfoPlugin.linuxInfo;
      return linuxInfo.machineId;
    }
    return null;
  }
}
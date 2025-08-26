// Base64工具类
import 'dart:convert';

class Base64Utils {
  // 解密为字符串
  static String? decodeToString(String base64Str) {
    try {
      List<int> bytes = base64.decode(base64Str);
      return utf8.decode(bytes);
    } catch (e) {
      print("解密失败：$e");
      return null;
    }
  }

  // 解密为字节数组（用于二进制数据）
  static List<int>? decodeToBytes(String base64Str) {
    try {
      return base64.decode(base64Str);
    } catch (e) {
      print("解密失败：$e");
      return null;
    }
  }
}
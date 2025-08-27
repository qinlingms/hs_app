// Hex 解码工具类
import 'dart:convert';

import '../log/logger.dart';

class HexDecoder {
  // 1. 将 Hex 字符串解码为字节数组（List<int>）
  static List<int>? decodeToBytes(String hexString) {
    // 预处理：去除空格、空字符，转为小写
    String cleaned = hexString.replaceAll(RegExp(r'\s+'), '').toLowerCase();
    
    // 校验长度是否为偶数
    if (cleaned.length % 2 != 0) {
      print("Hex 字符串长度必须为偶数");
      return null;
    }
    
    // 校验是否包含非法字符
    if (!RegExp(r'^[0-9a-f]+$').hasMatch(cleaned)) {
      print("Hex 字符串包含非法字符（仅允许 0-9、a-f、A-F）");
      return null;
    }
    
    // 转换为字节数组
    List<int> bytes = [];
    for (int i = 0; i < cleaned.length; i += 2) {
      String pair = cleaned.substring(i, i + 2); // 取两个字符
      int byteValue = int.parse(pair, radix: 16); // 十六进制转整数
      bytes.add(byteValue);
    }
    
    return bytes;
  }

  // 2. 将 Hex 字符串解码为 UTF-8 字符串（适用于文本内容）
  static String? decodeToString(String hexString) {
    List<int>? bytes = decodeToBytes(hexString);
    if (bytes == null) return null;
    
    try {
      return utf8.decode(bytes); // 字节数组转 UTF-8 字符串
    } catch (e) {
      logger.e("Hex 解码为字符串失败（非 UTF-8 编码）：$e");
      return null;
    }
  }
}
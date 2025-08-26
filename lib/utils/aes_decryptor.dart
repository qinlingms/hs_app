import 'dart:typed_data';

import 'package:encrypt/encrypt.dart';

class AesDecryptor {
  /// AES解密方法
  /// [encryptedData] 加密后的数据（Base64编码）
  /// [keyString] 密钥字符串（需与加密时一致）
  /// [ivString] 初始化向量字符串（需与加密时一致）
  static String decrypt(List<int> encryptedData, List<int> key, List<int> iv) {
    try {
      // 创建密钥（AES支持128/192/256位密钥）
      final keyObj = Key(Uint8List.fromList(key));
      // 创建初始化向量（IV长度必须为16字节）
      final ivObj = IV(Uint8List.fromList(iv));
      
      // 初始化AES加密器（使用CBC模式，PKCS7填充）
      final encrypter = Encrypter(AES(keyObj, mode: AESMode.cbc));
      
      // 将Base64编码的加密数据转换为Encrypted对象
      final encrypted = Encrypted(Uint8List.fromList(encryptedData));
      
      // 解密
      final decrypted = encrypter.decrypt(encrypted, iv: ivObj);
      
      return decrypted;
    } catch (e) {
      print('AES解密失败: $e');
      throw Exception('解密失败，请检查密钥、IV和加密数据是否正确');
    }
  }
}
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MtlsSeparateCertsClient {
  final String baseUrl;
  final String rootCertPath;       // 根证书路径
  final String clientCertPath;     // 客户端证书路径
  final String clientKeyPath;      // 客户端私钥路径
  final String keyPasswordKey;     // 私钥密码存储键名（如果私钥有密码）
  final Dio _dio = Dio();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  MtlsSeparateCertsClient({
    required this.baseUrl,
    required this.rootCertPath,
    required this.clientCertPath,
    required this.clientKeyPath,
    required this.keyPasswordKey,
  }) {
    _dio.options.baseUrl = baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
  }

  // 初始化私钥密码（如果私钥有密码保护）
  Future<void> initializeKeyPassword(String password) async {
    await _secureStorage.write(key: keyPasswordKey, value: password);
  }

  // 加载证书文件内容
  Future<List<int>> _loadCertificate(String assetPath) async {
    final byteData = await rootBundle.load(assetPath);
    return byteData.buffer.asUint8List();
  }

  // 配置双向SSL并获取Dio实例
  Future<Dio> _getSecureDio() async {
    // 1. 加载所有证书
    final rootCertBytes = await _loadCertificate(rootCertPath);
    final clientCertBytes = await _loadCertificate(clientCertPath);
    final clientKeyBytes = await _loadCertificate(clientKeyPath);
    
    // 获取私钥密码（如果有）
    final keyPassword = await _secureStorage.read(key: keyPasswordKey);

    // 2. 创建安全上下文
    final securityContext = SecurityContext(withTrustedRoots: false);
    
    // 3. 添加根证书（用于验证服务器证书）
    securityContext.setTrustedCertificatesBytes(rootCertBytes);
    
    // 4. 添加客户端证书和私钥（供服务器验证）
    securityContext.useCertificateChainBytes(clientCertBytes);
    securityContext.usePrivateKeyBytes(
      clientKeyBytes,
      password: keyPassword, // 如果私钥没有密码，可以传null
    );

    // 5. 配置Dio的HTTP客户端适配器
    (_dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient(context: securityContext);
      // 生产环境必须保持false，确保严格验证证书
      client.badCertificateCallback = (cert, host, port) => false;
      return client;
    };

    return _dio;
  }

  // 发送GET请求
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    final dio = await _getSecureDio();
    return dio.get(path, queryParameters: queryParameters);
  }

  // 发送POST请求
  Future<Response> post(String path, {dynamic data}) async {
    final dio = await _getSecureDio();
    return dio.post(path, data: data);
  }

  // 清理私钥密码
  Future<void> clearKeyPassword() async {
    await _secureStorage.delete(key: keyPasswordKey);
  }
}
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/services.dart';

class MtlsHttpClient {
  final String rootCertPath;
  final String clientCertPath;
  final String clientKeyPath;
  final String baseUrl;
  MtlsHttpClient({
    required this.rootCertPath,
    required this.clientCertPath,
    required this.clientKeyPath,
    required this.baseUrl,
  });
  // 加载证书文件（从assets中读取）
  Future<SecurityContext> createSecurityContext() async {
    final context = SecurityContext(withTrustedRoots: false);

    // 1. 加载服务器CA证书（用于验证服务器）
    final serverCaBytes = await _loadAsset(rootCertPath);
    context.setTrustedCertificatesBytes(serverCaBytes);
    print('服务器CA证书加载成功，长度: ${serverCaBytes.length}');
    if (serverCaBytes.isEmpty) {
      throw Exception('服务器CA证书为空，请检查文件');
    }
    // 2. 加载客户端证书和私钥（用于服务器验证客户端）
    // 方式一：分别加载PEM格式的证书和私钥
    final clientCertBytes = await _loadAsset(clientCertPath);
    if (clientCertBytes.isEmpty) {
      throw Exception('客户端证书为空，请检查文件');
    }
    final clientKeyBytes = await _loadAsset(clientKeyPath);
    if (clientKeyBytes.isEmpty) {
      throw Exception('客户端私钥为空，请检查文件');
    }
    context.useCertificateChainBytes(clientCertBytes);
    context.usePrivateKeyBytes(clientKeyBytes);

    // 方式二：加载PKCS12格式的证书（如果是.p12/.pfx文件）
    // final p12Bytes = await _loadAsset('assets/cert/client.p12');
    // context.useCertificateChainBytes(p12Bytes, password: '证书密码');
    // context.usePrivateKeyBytes(p12Bytes, password: '证书密码');

    return context;
  }

  // 从assets加载证书字节
  Future<Uint8List> _loadAsset(String path) async {
    // 确保在pubspec.yaml中配置了assets
    // assets:
    //   - assets/cert/
    final byteData = await rootBundle.load(path);
    return byteData.buffer.asUint8List();
  }

  // 创建支持mTLS的Dio客户端
  Future<Dio> createDioClient() async {
    final context = await createSecurityContext();
    final httpClient = HttpClient(context: context);
    // 可选：禁用证书主机名验证（仅开发环境使用！）
    // httpClient.badCertificateCallback = (cert, host, port) => true;
    final dio = Dio()
    ..httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () => httpClient,
    )
    ..options.headers = {
      'Content-Type': 'application/json',
    };
    return dio;
  }

  // 示例请求
  Future<void> get() async {
    try {
      final dio = await createDioClient();
      final response = await dio.get('https://你的服务器地址/api');
      print('请求成功: ${response.data}');
    } on HandshakeException catch (e) {
      print('握手失败: $e');
      // 常见原因：证书不匹配、CA未信任、客户端证书未正确配置
    } on DioException catch (e) {
      print('请求错误: ${e.message}');
    }
  }

  Future<Response?> post(
    String uri, {
    Map<String, String> headers = const {},
    Map<String, dynamic> data = const {},
  }) async {
    try {
      final dio = await createDioClient();
      print("url: $baseUrl$uri");
      final response = await dio.post(
        baseUrl + uri,
        options: Options(headers: headers),
        data: data,
      );
      return response;
    } on HandshakeException catch (e) {
      print('握手失败: $e');
      // 常见原因：证书不匹配、CA未信任、客户端证书未正确配置
    } on DioException catch (e) {
      print('请求错误: $e');
    }
    return null;
  }
}

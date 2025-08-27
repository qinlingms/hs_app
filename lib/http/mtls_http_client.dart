import 'dart:io';
import 'package:app_hs/log/logger.dart';
import 'package:app_hs/http/resp.dart';
import 'package:app_hs/utils/http_request_data.dart';
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

  Dio? _dioInstance;
  // 加载证书文件（从assets中读取）
  Future<SecurityContext> createSecurityContext() async {
    final context = SecurityContext(withTrustedRoots: false);

    // 1. 加载服务器CA证书（用于验证服务器）
    final serverCaBytes = await _loadAsset(rootCertPath);
    context.setTrustedCertificatesBytes(serverCaBytes);
    logger.d('服务器CA证书加载成功，长度: ${serverCaBytes.length}');
    if (serverCaBytes.isEmpty) {
      throw Exception('服务器CA证书为空，请检查文件');
    }
    // 2. 加载客户端证书和私钥（用于服务器验证客户端）
    // 方式一：分别加载PEM格式的证书和私钥
    final clientCertBytes = await _loadAsset(clientCertPath);
    if (clientCertBytes.isEmpty) {
      throw Exception('客户端证书为空，请检查文件');
    }
    logger.d('客户端证书加载成功，长度: ${clientCertBytes.length}');
    context.useCertificateChainBytes(clientCertBytes);
    final clientKeyBytes = await _loadAsset(clientKeyPath);
    if (clientKeyBytes.isEmpty) {
      throw Exception('客户端私钥为空，请检查文件');
    }
    logger.d('客户端私钥加载成功，长度: ${clientKeyBytes.length}');
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

    // 获取或创建 Dio 实例（单例模式）
  Future<Dio> _getDioInstance() async {
    if (_dioInstance == null) {
      _dioInstance = await createDioClient();
    }
    return _dioInstance!;
  }

  // 创建支持mTLS的Dio客户端
  Future<Dio> createDioClient() async {
    final context = await createSecurityContext();
    final httpClient = HttpClient(context: context);
    // 可选：禁用证书主机名验证（仅开发环境使用！）
    // 开发环境下直接返回true跳过验证
    // 生产环境绝对禁止！
    httpClient.badCertificateCallback = (cert, host, port) => true;
    final dio =
        Dio()
          ..httpClientAdapter = IOHttpClientAdapter(
            createHttpClient: () => httpClient,
          )
          ..options.headers = {'Content-Type': 'application/json'};
    return dio;
  }

  // 修改get方法返回ApiResponse
  Future<ApiResponse<Map<String, dynamic>>?> get(String uri) async {
    try {
      final dio = await _getDioInstance();
      logger.d("get request url: $baseUrl$uri");
      final response = await dio.get(baseUrl + uri);
      logger.d('请求成功: ${response.data}');

      // 解析响应为ApiResponse对象
      if (response.data is Map<String, dynamic>) {
        return ApiResponseHelper.fromJsonMap(response.data);
      }
      return null;
    } on HandshakeException catch (e) {
      logger.e('握手失败: $e');
    } on DioException catch (e) {
      logger.e('请求错误: ${e.message}');
    }
    return null;
  }

  // 修改post方法返回ApiResponse
  Future<ApiResponse<Map<String, dynamic>>?> post(
    String uri, {
    Map<String, dynamic> headers = const {},
    Map<String, dynamic> data = const {},
  }) async {
    try {
      final dio = await _getDioInstance();
      logger.d("post request url: $baseUrl$uri");
      logger.d("post request headers: $headers");
      logger.d("post request data: $data");
      Map<String, dynamic> requestData = HttpRequestData.build(data: data);
      final response = await dio.post(
        baseUrl + uri,
        options: Options(headers: headers),
        data: requestData,
      );
      logger.d("post request response: ${response.data}");
      // 解析响应为ApiResponse对象
      if (response.data is Map<String, dynamic>) {
        return ApiResponseHelper.fromJsonMap(response.data);
      }
      return null;
    } on HandshakeException catch (e) {
      logger.e('握手失败: $e');
    } on DioException catch (e) {
      logger.e('请求错误: ${e.message}');
    }
    return null;
  }
}

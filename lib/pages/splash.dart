import 'dart:async';
import 'package:app_hs/http/api.dart';
import 'package:app_hs/http/mtls_http_client.dart';
import 'package:app_hs/http/resp.dart';
import 'package:app_hs/pages/video_platform_page.dart';
import 'package:app_hs/pages/widgets/encrypted_image_widget.dart';
import 'package:app_hs/pages/widgets/custom_video_player_widget.dart';
import 'package:app_hs/service/device_identifier_service.dart';
import 'package:app_hs/service_locator.dart';
import 'package:app_hs/utils/aes_decryptor.dart';
import 'package:app_hs/utils/base64.dart';
import 'package:app_hs/utils/device.dart';
import 'package:app_hs/utils/hex_decoder.dart';
import 'package:app_hs/utils/html_first_href_extractor.dart';
import 'package:app_hs/utils/http_request_header.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../log/logger.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int _countdownSeconds = 5;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    // 初始化基础服务
    setupService();
    // 启动双向SSL初始化
    Future<bool> ok = _initMutualSSL();
    // 初始化倒计时
    ok.then((onValue) {
      if (onValue) {
        // 检查是否是首次安装
        Device.checkFirstLaunch().then((res) {
          if (res) {
            // 首次安装，调用安装接口
            _callInstallApi();
          } else {
            _startCountdown();
          }
        });
      } else {
        // 初始化失败，跳转首页
        logger.e("初始化失败，跳转首页");
      }
    });
  }

  // 双向SSL初始化逻辑
  Future<bool> _initMutualSSL() async {
    // 获取接口地址
    try {
      // 发起请求时通过 options 设置头
      final response = await Dio().get(
        "http://c1.ysepan.com/f_ht/ajcx/wj.aspx?cz=dq&jsq=0&mlbh=1821707&wjpx=1&_dlmc=lplkkdiee&_dlmm=e10adc3949",
        options: Options(headers: HttpRequestHeader.getNormalHeader()),
      );
      String input = response.data;
      int bracketIndex = input.indexOf(']');
      String base64Str = input.substring(bracketIndex + 1);
      String? txt = Base64Utils.decodeToString(base64Str);
      //print("请求成功：$base64Str");
      //print("请求成功：$txt");
      // 提取第一个 href
      String? href = HtmlFirstHrefExtractor.extractFirstHref(txt!);
      //print("提取到的 href: $href");
      final responseFile = await Dio().get(
        href!,
        options: Options(headers: HttpRequestHeader.getNormalHeader()),
      );
      //print("请求下载配置文件成功：${responseFile.data}");
      // 先尝试解码为字符串（适用于文本）
      List<int>? bytes = HexDecoder.decodeToBytes(responseFile.data);
      //print("strResult: ${bytes!.length}");
      // 从字节的前32字节中提取key和iv
      // 情况1: 前16字节为key，后16字节为iv (适用于AES-128)
      List<int> keyBytes = bytes!.sublist(0, 32);
      List<int> dataBytes = bytes.sublist(32, 64);
      List<int> key128 = [];
      List<int> iv128 = [];
      for (int i = 0; i < 16; i++) {
        key128.add(keyBytes[i * 2]);
        iv128.add(keyBytes[i * 2 + 1]);
      }
      //print("key128: $key128");
      //print("iv128: $iv128");
      //print("dataBytes: $dataBytes");
      // 解密
      final decryptedData = AesDecryptor.decrypt(dataBytes, key128, iv128);
      //print('解密结果: $decryptedData');
      setupMtlsService(decryptedData);
      return true;
      // 初始化服务定位器
    } on Exception catch (e) {
      logger.e("请求出错：$e");
    }
    return false;
  }

  void setupMtlsService(baseUrl) {
    // 注册MtlsSeparateCertsClient为单例
    getIt.registerLazySingleton<MtlsHttpClient>(
      () => MtlsHttpClient(
        baseUrl: baseUrl,
        rootCertPath: "assets/certificates/root-crt.pem",
        clientCertPath: "assets/certificates/client1-crt.pem",
        clientKeyPath: "assets/certificates/client1-key.pem",
      ),
    );
  }

  void setupService() {
    getIt.registerLazySingleton<DeviceIdentifierService>(
      () => DeviceIdentifierService(),
    );
  }

  // 首次安装调用接口
  void _callInstallApi() {
    MtlsHttpClient client = getIt<MtlsHttpClient>();
    Future<ApiResponse?> resp = client.post(
      Api.firstLaunch,
      data: {"os": "ios", "brand": "Iphone"},
    );
    resp.then((value) {
      if (value == null || (value.code != 200 && value.code != 30021)) {
        // 调用失败，重置首次启动标记
        _startCountdown();
      } else {
        Device.setFirstLaunch(false);
        _startCountdown();
      }
    });
  }

  // 倒计时逻辑
  void _startCountdown() {
    // 初始化定时器，每秒更新一次倒计时
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _countdownSeconds--;
      });
      logger.d("倒计时: $_countdownSeconds");
      // 当倒计时结束时，跳转到主页
      if (_countdownSeconds <= 0) {
        _timer.cancel();
        _navigateToHome();
      }
    });
  }

  // 跳转到主页的方法
  void _navigateToHome() {
    Navigator.pushReplacement(
      context,
      //MaterialPageRoute(builder: (context) => const VideoPlatformPage()),
      //MaterialPageRoute(builder: (context) => EncryptedImageExample(url: "http://192.168.3.84:9010/encrypted/2025/08/29/4e479718244d969dcf7805604d76b0cf742646def8a3c8d5c929067b8f212bc2/1961099978506514432.png")),
      MaterialPageRoute(builder: (context) => EncryptedCustomVideoPlayer.createAESPlayer(
        videoUrl: "https://192.168.3.84:9010/encrypted/2025/08/29/4e479718244d969dcf7805604d76b0cf742646def8a3c8d5c929067b8f212bc2/1961099978506514432.m3u8",
      )),
    );
  }

  @override
  void dispose() {
    _timer.cancel(); // 页面销毁时取消定时器，防止内存泄漏
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 启动页主体内容
          Container(
            color: Colors.white,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 应用Logo
                  const Icon(Icons.apps, size: 100, color: Colors.blue),
                  const SizedBox(height: 20),
                  // 应用名称
                  const Text(
                    '我的应用',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),

          // 右上角的倒计时显示（仅显示倒计时，无跳过功能）
          Positioned(
            top: 40, // 距离顶部的距离
            right: 20, // 距离右侧的距离
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${_countdownSeconds}s', // 仅显示倒计时秒数
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:async';
import 'dart:typed_data';
import 'package:app_hs/utils/aes_decryptor.dart';
import 'package:app_hs/utils/hex_decoder.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class GenericEncryptedImageViewer extends StatefulWidget {
  // 加密图片的网络地址
  final String encryptedImageUrl;

  // 解密函数（根据实际加密方式自定义）
  final Uint8List Function(Uint8List, String) decryptFunction;

  const GenericEncryptedImageViewer({
    super.key,
    required this.encryptedImageUrl,
    this.decryptFunction = _customDecrypt,
  });

  // 示例：自定义解密函数（根据你的实际加密方式实现）
  static Uint8List _customDecrypt(Uint8List encryptedData, String key) {
    // 这里是解密逻辑，根据你的加密方式实现
    // 例如：
    // 1. 如果是AES加密，实现AES解密
    List<int>? bytes = HexDecoder.decodeToBytes(key);
    List<int> keyBytes = bytes!.sublist(0, 32);
    List<int> key128 = [];
    List<int> iv128 = [];
    for (int i = 0; i < 16; i++) {
      key128.add(keyBytes[i * 2]);
      iv128.add(keyBytes[i * 2 + 1]);
    }
    // 以下是一个简单的XOR解密示例（仅作演示）
    final decrypted = AesDecryptor.decryptBytes(
      encryptedData,
      key128,
      iv128,
    );
    return Uint8List.fromList(decrypted);
  }

  @override
  State<GenericEncryptedImageViewer> createState() =>
      _GenericEncryptedImageViewerState();
}

class _GenericEncryptedImageViewerState
    extends State<GenericEncryptedImageViewer> {
  Uint8List? _decryptedImageBytes;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadEncryptedImage();
  }

  // 加载并处理加密图片
  Future<void> _loadEncryptedImage() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // 1. 从网络获取加密的图片数据
      final encryptedData = await _fetchEncryptedData();

      if (encryptedData.isEmpty) {
        throw Exception("获取的加密数据为空");
      }

      // 2. 使用自定义解密函数解密
      final decryptedData = widget.decryptFunction(
        encryptedData,
        "4e479718244d969dcf7805604d76b0cf742646def8a3c8d5c929067b8f212bc2",
      );

      if (decryptedData.isEmpty) {
        throw Exception("解密后的数据为空");
      }

      // 3. 显示解密后的图片
      setState(() {
        _decryptedImageBytes = decryptedData;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  // 从网络获取加密数据
  Future<Uint8List> _fetchEncryptedData() async {
    // 初始化Dio实例
    final Dio dio =
        Dio()
          ..options.connectTimeout = const Duration(seconds: 15)
          ..options.receiveTimeout = const Duration(seconds: 15);

    // 发起GET请求，指定返回类型为字节
    final response = await dio.get(
      widget.encryptedImageUrl,
      options: Options(
        responseType: ResponseType.bytes, // 关键配置：获取字节数据
        headers: {
          "Accept": "image/*", // 声明只接受图片类型
        },
      ),
    );

    if (response.statusCode != 200) {
      throw Exception("网络请求失败，状态码: ${response.statusCode}");
    }

    return response.data as Uint8List;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('加密图片查看器')),
      body: Center(child: _buildContent()),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('加载并处理图片中...'),
        ],
      );
    }

    if (_errorMessage != null) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(
              '处理失败: $_errorMessage',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red, fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loadEncryptedImage,
              child: const Text('重试'),
            ),
          ],
        ),
      );
    }

    return _decryptedImageBytes != null
        ? InteractiveViewer(
          child: Image.memory(
            _decryptedImageBytes!,
            fit: BoxFit.contain,
            errorBuilder:
                (context, error, stackTrace) => const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.broken_image, size: 48, color: Colors.grey),
                    SizedBox(height: 16),
                    Text('图片解析失败，可能是解密错误'),
                  ],
                ),
          ),
        )
        : const Text('没有图片数据');
  }
}

// 使用示例 - 根据你的实际加密方式修改
class EncryptedImageExample extends StatelessWidget {
  final String url;
  const EncryptedImageExample({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return GenericEncryptedImageViewer(
      encryptedImageUrl:
          url,
    );
  }
}

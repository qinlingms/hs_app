import 'package:app_hs/utils/aes_decryptor.dart';
import 'package:app_hs/utils/hex_decoder.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:typed_data';
import 'dart:io';
import 'package:dio/dio.dart';

// 自定义解密器接口
abstract class VideoDecryptor {
  Future<Uint8List> decrypt(Uint8List encryptedData);
}

// AES解密器实现
class AESVideoDecryptor implements VideoDecryptor {
  final String key;
  
  AESVideoDecryptor({required this.key});
  
  @override
  Future<Uint8List> decrypt(Uint8List encryptedData) async {
    try {
      List<int>? bytes = HexDecoder.decodeToBytes(key);
    List<int> keyBytes = bytes!.sublist(0, 32);
    List<int> key128 = [];
    List<int> iv128 = [];
    for (int i = 0; i < 16; i++) {
      key128.add(keyBytes[i * 2]);
      iv128.add(keyBytes[i * 2 + 1]);
    }
      final decryptedData = AesDecryptor.decryptBytes(encryptedData, key128, iv128);
      return Uint8List.fromList(decryptedData);
    } catch (e) {
      throw Exception('AES解密失败: $e');
    }
  }
}

class CustomVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final VideoDecryptor? decryptor;
  final Map<String, String>? headers;
  final Map<String, dynamic>? decryptionMetadata;
  final bool isEncrypted;
  final VideoFormat? formatHint;

  const CustomVideoPlayer({
    super.key,
    required this.videoUrl,
    this.decryptor,
    this.headers,
    this.decryptionMetadata,
    this.isEncrypted = false,
    this.formatHint,
  });

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  bool _isLoading = true;
  String? _errorMessage;
  String? _tempVideoPath;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      if (widget.isEncrypted && widget.decryptor != null) {
        // 处理加密视频
        await _handleEncryptedVideo();
      } else {
        // 处理普通视频
        await _handleNormalVideo();
      }

      // 配置Chewie控制器
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: true,
        looping: false,
        allowFullScreen: true,
        allowMuting: true,
        showControlsOnInitialize: false,
        materialProgressColors: ChewieProgressColors(
          playedColor: Colors.blue,
          handleColor: Colors.blue,
          backgroundColor: Colors.grey,
          bufferedColor: Colors.lightBlueAccent,
        ),
        placeholder: const Center(
          child: CircularProgressIndicator(),
        ),
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                Text(
                  '播放错误: $errorMessage',
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _initializePlayer,
                  child: const Text('重试'),
                ),
              ],
            ),
          );
        },
      );

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  Future<void> _handleNormalVideo() async {
    // 处理普通视频（包括普通的HLS和MP4）
    final uri = Uri.parse(widget.videoUrl);
    
    _videoPlayerController = VideoPlayerController.networkUrl(
      uri,
      formatHint: widget.formatHint ?? _detectVideoFormat(widget.videoUrl),
      httpHeaders: widget.headers ?? {},
    );

    await _videoPlayerController.initialize();
  }

  Future<void> _handleEncryptedVideo() async {
    // 下载加密视频数据
    final encryptedData = await _downloadEncryptedVideo();
    
    // 解密视频数据
    final decryptedData = await widget.decryptor!.decrypt(
      encryptedData
    );
    
    // 保存解密后的视频到临时文件
    _tempVideoPath = await _saveDecryptedVideoToTemp(decryptedData);
    
    // 使用临时文件创建视频控制器
    _videoPlayerController = VideoPlayerController.file(
      File(_tempVideoPath!),
    );

    await _videoPlayerController.initialize();
  }

  Future<Uint8List> _downloadEncryptedVideo() async {
    try {
      final dio = Dio();
      
      // 设置请求头
      if (widget.headers != null) {
        dio.options.headers.addAll(widget.headers!);
      }
      
      final response = await dio.get(
        widget.videoUrl,
        options: Options(
          responseType: ResponseType.bytes,
          receiveTimeout: const Duration(minutes: 10),
        ),
      );
      
      if (response.statusCode == 200) {
        return Uint8List.fromList(response.data);
      } else {
        throw Exception('下载失败: HTTP ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('下载加密视频失败: $e');
    }
  }

  Future<String> _saveDecryptedVideoToTemp(Uint8List data) async {
    try {
      final tempDir = Directory.systemTemp;
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final extension = _getFileExtension(widget.videoUrl);
      final tempFile = File('${tempDir.path}/decrypted_video_$timestamp.$extension');
      
      await tempFile.writeAsBytes(data);
      return tempFile.path;
    } catch (e) {
      throw Exception('保存解密视频失败: $e');
    }
  }

  VideoFormat _detectVideoFormat(String url) {
    final uri = Uri.parse(url.toLowerCase());
    final path = uri.path.toLowerCase();
    
    if (path.contains('.m3u8') || path.contains('hls')) {
      return VideoFormat.hls;
    } else if (path.contains('.mp4')) {
      return VideoFormat.other;
    } else if (path.contains('.dash') || path.contains('mpd')) {
      return VideoFormat.dash;
    }
    
    return VideoFormat.other;
  }

  String _getFileExtension(String url) {
    final uri = Uri.parse(url.toLowerCase());
    final path = uri.path.toLowerCase();
    
    if (path.contains('.m3u8')) {
      return 'm3u8';
    } else if (path.contains('.mp4')) {
      return 'mp4';
    } else if (path.contains('.mkv')) {
      return 'mkv';
    } else if (path.contains('.avi')) {
      return 'avi';
    }
    
    return 'mp4'; // 默认
  }

  Future<void> _cleanupTempFile() async {
    if (_tempVideoPath != null) {
      try {
        final file = File(_tempVideoPath!);
        if (await file.exists()) {
          await file.delete();
        }
      } catch (e) {
        // 忽略清理错误
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    // 释放资源
    _videoPlayerController.dispose();
    _chewieController.dispose();
    // 清理临时文件
    _cleanupTempFile();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: _videoPlayerController.value.isInitialized 
          ? _videoPlayerController.value.aspectRatio 
          : 16 / 9,
      child: _buildPlayerContent(),
    );
  }

  Widget _buildPlayerContent() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('正在加载视频...', style: TextStyle(color: Colors.white)),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(
              '加载失败: $_errorMessage',
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _initializePlayer,
              child: const Text('重试'),
            ),
          ],
        ),
      );
    }

    return Chewie(controller: _chewieController);
  }
}

// 使用示例扩展类
class EncryptedCustomVideoPlayer {
  // 创建AES加密的播放器
  static Widget createAESPlayer({
    required String videoUrl,
    String? iv,
    Map<String, String>? headers,
    Map<String, dynamic>? metadata,
  }) {
    String key ="4e479718244d969dcf7805604d76b0cf742646def8a3c8d5c929067b8f212bc2";
    return CustomVideoPlayer(
      videoUrl: videoUrl,
      isEncrypted: true,
      decryptor: AESVideoDecryptor(key: key),
      headers: headers,
      decryptionMetadata: metadata,
    );
  }
}
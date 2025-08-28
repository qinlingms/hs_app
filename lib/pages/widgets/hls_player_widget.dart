import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class HlsPlayer extends StatefulWidget {
  final String hlsUrl;

  const HlsPlayer({
    super.key,
    required this.hlsUrl,
  });

  @override
  State<HlsPlayer> createState() => _HlsPlayerState();
}

class _HlsPlayerState extends State<HlsPlayer> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      // 初始化视频控制器，支持HLS格式
      _videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(widget.hlsUrl),
        formatHint: VideoFormat.hls, // 明确指定HLS格式
      );

      // 初始化控制器
      await _videoPlayerController.initialize();
      
      // 配置Chewie控制器
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: true,
        looping: false,
        allowFullScreen: true,
        allowMuting: true,
        // 自定义控制UI
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
            child: Text(
              '播放错误: $errorMessage',
              style: const TextStyle(color: Colors.white),
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

  @override
  void dispose() {
    super.dispose();
    // 释放资源
    _videoPlayerController.dispose();
    _chewieController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: _videoPlayerController.value.aspectRatio ?? 16 / 9,
      child: _buildPlayerContent(),
    );
  }

  Widget _buildPlayerContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('加载失败: $_errorMessage'),
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
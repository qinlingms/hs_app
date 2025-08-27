import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VideoDetailPage extends StatefulWidget {
  final Map<String, dynamic> videoData;
  
  const VideoDetailPage({super.key, required this.videoData});

  @override
  State<VideoDetailPage> createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage> {
  bool _isFullScreen = false;
  bool _isPlaying = false;
  double _currentPosition = 0.0;
  final double _totalDuration = 100.0; // 模拟视频总时长
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _isFullScreen ? null : AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.videoData['title'] ?? '视频详情',
          style: const TextStyle(color: Colors.white, fontSize: 16),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: () {
              // 分享功能
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('分享功能')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.white),
            onPressed: () {
              // 收藏功能
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('已收藏')),
              );
            },
          ),
        ],
      ),
      body: _isFullScreen ? _buildFullScreenPlayer() : _buildScrollableContent(),
    );
  }
  
  Widget _buildFullScreenPlayer() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black,
      child: Stack(
        children: [
          // 视频播放区域（模拟）
          Center(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[900],
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.grey[800]!,
                    Colors.grey[900]!,
                  ],
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.play_circle_outline,
                  size: 80,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          // 播放控制层
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isPlaying = !_isPlaying;
                });
              },
              child: Container(
                color: Colors.transparent,
                child: Center(
                  child: AnimatedOpacity(
                    opacity: _isPlaying ? 0.0 : 1.0,
                    duration: const Duration(milliseconds: 300),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isPlaying ? Icons.pause : Icons.play_arrow,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // 全屏按钮
          Positioned(
            bottom: 16,
            right: 16,
            child: GestureDetector(
              onTap: _toggleFullScreen,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Icon(
                  _isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
          _buildProgressBar(),
        ],
      ),
    );
  }
  
  Widget _buildScrollableContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // 视频播放器区域
          Container(
            width: double.infinity,
            height: 250, // 固定高度，但整个页面可滚动
            color: Colors.black,
            child: Stack(
              children: [
                // 视频播放区域（模拟）
                Center(
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.grey[800]!,
                          Colors.grey[900]!,
                        ],
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.play_circle_outline,
                        size: 80,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                // 播放控制层
                Positioned.fill(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isPlaying = !_isPlaying;
                      });
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: Center(
                        child: AnimatedOpacity(
                          opacity: _isPlaying ? 0.0 : 1.0,
                          duration: const Duration(milliseconds: 300),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _isPlaying ? Icons.pause : Icons.play_arrow,
                              size: 50,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // 全屏按钮
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: GestureDetector(
                    onTap: _toggleFullScreen,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Icon(
                        _isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
                _buildProgressBar(),
              ],
            ),
          ),
          // 视频信息区域
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 视频标题
                Text(
                  widget.videoData['title'] ?? '视频标题',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                // 视频信息
                Row(
                  children: [
                    Icon(Icons.play_arrow, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      '${widget.videoData['views'] ?? '0'} 次播放',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      widget.videoData['duration'] ?? '00:00',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // 操作按钮
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildActionButton(Icons.thumb_up, '点赞', () {}),
                    _buildActionButton(Icons.thumb_down, '不喜欢', () {}),
                    _buildActionButton(Icons.share, '分享', () {}),
                    _buildActionButton(Icons.download, '下载', () {}),
                  ],
                ),
                const SizedBox(height: 24),
                // 相关视频推荐
                const Text(
                  '相关推荐',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                // 推荐视频列表
                ...List.generate(5, (index) => _buildRecommendedVideo(index)),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildProgressBar() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.7),
            ],
          ),
        ),
        child: Row(
          children: [
            Text(
              _formatDuration(_currentPosition),
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Colors.red,
                  inactiveTrackColor: Colors.white.withOpacity(0.3),
                  thumbColor: Colors.red,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
                ),
                child: Slider(
                  value: _currentPosition,
                  max: _totalDuration,
                  onChanged: (value) {
                    setState(() {
                      _currentPosition = value;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              _formatDuration(_totalDuration),
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildActionButton(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 24, color: Colors.grey[700]),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }
  
  Widget _buildRecommendedVideo(int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 120,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Icon(Icons.play_circle_outline, size: 30, color: Colors.white),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '推荐视频标题 ${index + 1}',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '1.2万 次播放 • 2天前',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  String _formatDuration(double seconds) {
    int minutes = (seconds / 60).floor();
    int remainingSeconds = (seconds % 60).floor();
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
  
  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
    });
    
    if (_isFullScreen) {
      // 进入全屏模式
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      // 退出全屏模式
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    }
  }
  
  @override
  void dispose() {
    // 确保退出时恢复系统UI
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }
}
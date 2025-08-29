import 'package:app_hs/models/movie.dart';
import 'package:app_hs/pages/widgets/encrypted_image_widget.dart';
import 'package:flutter/material.dart';

class VideoWidget extends StatefulWidget {
  final Movie video;
  const VideoWidget({super.key, required this.video});
  @override
  State<VideoWidget> createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  @override
  Widget build(BuildContext context) {
    return _buildVideoCard(widget.video);
  }

  Widget _buildVideoCard(Movie video) {
    return Container(
      height: 200, // 给整个卡片一个固定高度
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 视频缩略图
          Container(
            height: 140, // 固定缩略图高度
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
              child: Stack(
                children: [
                  // 使用 EncryptedImageExample 作为背景
                  Positioned.fill(
                    child: EncryptedImageExample(url: video.previewUrl),
                  ),
                  // 播放按钮覆盖层
                  Center(
                    child: Icon(
                      Icons.play_circle_outline,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  // 时长标签
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        video.duration,
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ),
                  // 观看次数
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Row(
                      children: [
                        Icon(Icons.play_arrow, color: Colors.white, size: 16),
                        SizedBox(width: 4),
                        Text(
                          video.playCnt.toString(),
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // 视频标题
          Container(
            height: 60, // 固定标题区域高度
            padding: EdgeInsets.all(8),
            child: Text(
              video.title,
              style: TextStyle(color: Colors.white, fontSize: 12),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

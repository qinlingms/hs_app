import 'package:app_hs/model/movie.dart';
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
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 视频缩略图
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
              ),
              child: Stack(
                children: [
                  // 这里可以放置实际的图片
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
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                video.title,
                style: TextStyle(color: Colors.white, fontSize: 12),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
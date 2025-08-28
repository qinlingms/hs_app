import 'package:flutter/material.dart';

class VideoListPage extends StatefulWidget {
  const VideoListPage({super.key});

  @override
  State<VideoListPage> createState() => _VideoListPageState();
}

class _VideoListPageState extends State<VideoListPage> {
  // 模拟视频数据
  final List<VideoItem> _videos = [
    VideoItem(
      title: '国内AV91 穿着T背教学的茄子中出钢琴老师#Tangtang',
      thumbnail: 'assets/images/video1.jpg',
      duration: '0:40:12',
      views: '2231',
    ),
    VideoItem(
      title: '国产AV电影TM0109神母-孟若羽',
      thumbnail: 'assets/images/video2.jpg', 
      duration: '0:43:20',
      views: '1231',
    ),
    VideoItem(
      title: '视频名字视频名字视频名字视频名字',
      thumbnail: 'assets/images/video3.jpg',
      duration: '1:20:20', 
      views: '1231',
    ),
    VideoItem(
      title: '视频名字视频名字视频名字视频名字',
      thumbnail: 'assets/images/video4.jpg',
      duration: '1:20:20',
      views: '1231', 
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Row(
          children: [
            Icon(Icons.male, color: Colors.white),
            SizedBox(width: 8),
            Text('热门推荐', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            SizedBox(width: 16),
            Text('乱伦换妻', style: TextStyle(color: Colors.white)),
            SizedBox(width: 16), 
            Text('中文原创', style: TextStyle(color: Colors.white)),
            SizedBox(width: 16),
            Text('日韩欧美', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
      body: Column(
        children: [
          // 分类标签栏
          Container(
            color: Colors.black,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _buildCategoryButton('推荐', true),
                SizedBox(width: 16),
                _buildCategoryButton('最新', false),
                SizedBox(width: 16), 
                _buildCategoryButton('最热', false),
                Spacer(),
                Text('10分钟+', style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          // 视频列表
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              itemCount: _videos.length,
              itemBuilder: (context, index) {
                return _buildVideoCard(_videos[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(String text, bool isSelected) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.black : Colors.white,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildVideoCard(VideoItem video) {
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
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
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
                          video.views,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
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
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
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

class VideoItem {
  final String title;
  final String thumbnail;
  final String duration;
  final String views;

  VideoItem({
    required this.title,
    required this.thumbnail, 
    required this.duration,
    required this.views,
  });
}
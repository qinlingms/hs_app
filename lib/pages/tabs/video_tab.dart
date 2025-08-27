import 'package:flutter/material.dart';
import '../video_detail_page.dart';

class VideoTab extends StatefulWidget {
  const VideoTab({super.key});

  @override
  State<VideoTab> createState() => _VideoTabState();
}

class _VideoTabState extends State<VideoTab> with TickerProviderStateMixin {
  late TabController _tabController;
  
  final List<String> _tabs = ['推荐', '最新', '最热', '10分钟+'];
  
  final List<Map<String, dynamic>> _videoList = [
    {
      'title': '国内AV91 穿着T背教学的茄子中出钢琴老师#Tangtang',
      'thumbnail': null, // Remove external URL
      'duration': '0:40:12',
      'views': '2231',
    },
    {
      'title': '国产AV电影TM0109神母-孟若羽',
      'thumbnail': null, // Remove external URL
      'duration': '0:43:20',
      'views': '1231',
    },
    {
      'title': '视频名字视频名字视频名字视频名字',
      'thumbnail': null, // Remove external URL
      'duration': '1:20:20',
      'views': '1231',
    },
    {
      'title': '视频名字视频名字视频名字视频名字视频名字',
      'thumbnail': null, // Remove external URL
      'duration': '1:20:20',
      'views': '1231',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 顶部Tab栏
        Container(
          color: Colors.white,
          child: TabBar(
            controller: _tabController,
            tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
            labelColor: Colors.red,
            unselectedLabelColor: Colors.black54,
            indicatorColor: Colors.red,
            indicatorWeight: 2,
            labelStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        // 视频内容区域 - 使用固定高度而不是Expanded
        SizedBox(
          height: MediaQuery.of(context).size.height, // 使用屏幕高度的60%
          child: TabBarView(
            controller: _tabController,
            children: _tabs.map((tab) => _buildVideoGrid()).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildVideoGrid() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: _videoList.length * 2, // 重复显示以填充更多内容
        itemBuilder: (context, index) {
          final video = _videoList[index % _videoList.length];
          return _buildVideoItem(video);
        },
      ),
    );
  }

  Widget _buildVideoItem(Map<String, dynamic> video) {
    return GestureDetector(
      onTap: () {
        // 点击视频项时跳转到视频详细页面
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoDetailPage(videoData: video),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
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
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                  color: Colors.grey[300],
                ),
                child: Stack(
                  children: [
                    // 缩略图占位 - 使用纯色背景而不是网络图片
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.grey[400]!,
                            Colors.grey[600]!,
                          ],
                        ),
                      ),
                      child: const Icon(
                        Icons.play_circle_outline,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    // 播放次数
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                              size: 12,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              video['views'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // 视频时长
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          video['duration'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
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
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  video['title'],
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
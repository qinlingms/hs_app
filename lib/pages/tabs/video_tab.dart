import 'package:app_hs/pages/widgets/grid_section_widget.dart';
import 'package:flutter/material.dart';

class VideoTab extends StatelessWidget {
  const VideoTab({super.key});
  
  final List<Map<String, dynamic>> _videoItems = const [
    {'title': '最新电影', 'color': Colors.red, 'icon': Icons.movie},
    {'title': '热播剧集', 'color': Colors.blue, 'icon': Icons.tv},
    {'title': '综艺节目', 'color': Colors.orange, 'icon': Icons.theater_comedy},
    {'title': '纪录片', 'color': Colors.green, 'icon': Icons.nature_people},
    {'title': '动漫', 'color': Colors.purple, 'icon': Icons.animation},
    {'title': '短视频', 'color': Colors.pink, 'icon': Icons.video_library},
  ];
  
  final List<Map<String, dynamic>> _categoryItems = const [
    {'title': '动作片', 'color': Colors.red, 'icon': Icons.local_fire_department},
    {'title': '喜剧片', 'color': Colors.yellow, 'icon': Icons.sentiment_very_satisfied},
    {'title': '爱情片', 'color': Colors.pink, 'icon': Icons.favorite},
    {'title': '科幻片', 'color': Colors.blue, 'icon': Icons.rocket_launch},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            '视频内容',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        GridSectionWidget(title: '热门影片', items: _videoItems),
        const SizedBox(height: 24),
        GridSectionWidget(title: '分类推荐', items: _categoryItems),
      ],
    );
  }
}
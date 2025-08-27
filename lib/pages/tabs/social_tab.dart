import 'package:app_hs/pages/widgets/grid_section_widget.dart';
import 'package:flutter/material.dart';

class SocialTab extends StatelessWidget {
  const SocialTab({super.key});
  
  final List<Map<String, dynamic>> _socialItems = const [
    {'title': '同城交友', 'color': Colors.pink, 'icon': Icons.location_on},
    {'title': '语音聊天', 'color': Colors.purple, 'icon': Icons.mic},
    {'title': '视频聊天', 'color': Colors.blue, 'icon': Icons.videocam},
    {'title': '匿名聊天', 'color': Colors.grey, 'icon': Icons.visibility_off},
    {'title': '兴趣群组', 'color': Colors.green, 'icon': Icons.group},
    {'title': '约会活动', 'color': Colors.red, 'icon': Icons.event},
  ];
  
  final List<Map<String, dynamic>> _topicItems = const [
    {'title': '情感倾诉', 'color': Colors.pink, 'icon': Icons.favorite},
    {'title': '生活分享', 'color': Colors.orange, 'icon': Icons.share},
    {'title': '兴趣爱好', 'color': Colors.blue, 'icon': Icons.interests},
    {'title': '职场交流', 'color': Colors.indigo, 'icon': Icons.work},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GridSectionWidget(title: '交友社区', items: _socialItems),
        const SizedBox(height: 24),
        GridSectionWidget(title: '热门话题', items: _topicItems),
      ],
    );
  }
}
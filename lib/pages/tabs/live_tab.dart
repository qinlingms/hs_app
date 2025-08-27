import 'package:app_hs/pages/widgets/grid_section_widget.dart';
import 'package:flutter/material.dart';

class LiveTab extends StatelessWidget {
  const LiveTab({super.key});
  
  final List<Map<String, dynamic>> _liveItems = const [
    {'title': '杏吧直播', 'color': Colors.pink, 'icon': Icons.live_tv},
    {'title': '海角社区', 'color': Colors.blue, 'icon': Icons.waves},
    {'title': '成人游戏', 'color': Colors.deepPurple, 'icon': Icons.games},
    {'title': '澳门新葡京', 'color': Colors.amber, 'icon': Icons.account_balance},
    {'title': '妹团的约炮', 'color': Colors.pink, 'icon': Icons.group},
    {'title': 'AI色色', 'color': Colors.purple, 'icon': Icons.smart_toy},
  ];
  
  final List<Map<String, dynamic>> _categoryItems = const [
    {'title': '游戏直播', 'color': Colors.purple, 'icon': Icons.games},
    {'title': '音乐直播', 'color': Colors.pink, 'icon': Icons.music_note},
    {'title': '舞蹈直播', 'color': Colors.red, 'icon': Icons.music_video},
    {'title': '聊天直播', 'color': Colors.blue, 'icon': Icons.chat},
    {'title': '户外直播', 'color': Colors.green, 'icon': Icons.nature},
    {'title': '美食直播', 'color': Colors.orange, 'icon': Icons.restaurant},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GridSectionWidget(title: '热门直播', items: _liveItems),
        const SizedBox(height: 24),
        GridSectionWidget(title: '直播分类', items: _categoryItems),
      ],
    );
  }
}
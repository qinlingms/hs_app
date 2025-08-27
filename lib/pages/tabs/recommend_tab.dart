import 'package:app_hs/pages/widgets/grid_section_widget.dart';
import 'package:app_hs/pages/widgets/promotion_banners_widget.dart';
import 'package:flutter/material.dart';

class RecommendTab extends StatelessWidget {
  const RecommendTab({super.key});
  
  final List<Map<String, dynamic>> _gameItems = const [
    {'title': 'AG游戏', 'color': Colors.red, 'icon': Icons.casino},
    {'title': 'PG电子', 'color': Colors.amber, 'icon': Icons.videogame_asset},
    {'title': '开元棋牌', 'color': Colors.blue, 'icon': Icons.grid_view},
    {'title': '同城约炮', 'color': Colors.pink, 'icon': Icons.favorite},
    {'title': '迷药', 'color': Colors.purple, 'icon': Icons.local_pharmacy},
    {'title': '换妻交友', 'color': Colors.red, 'icon': Icons.people},
  ];
  
  final List<Map<String, dynamic>> _liveItems = const [
    {'title': '杏吧直播', 'color': Colors.pink, 'icon': Icons.live_tv},
    {'title': '海角社区', 'color': Colors.blue, 'icon': Icons.waves},
    {'title': '成人游戏', 'color': Colors.deepPurple, 'icon': Icons.games},
    {'title': '澳门新葡京', 'color': Colors.amber, 'icon': Icons.account_balance},
    {'title': '妹团的约炮', 'color': Colors.pink, 'icon': Icons.group},
    {'title': 'AI色色', 'color': Colors.purple, 'icon': Icons.smart_toy},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GridSectionWidget(title: '热门推荐', items: _gameItems),
        const SizedBox(height: 24),
        GridSectionWidget(title: '精选内容', items: _liveItems),
        const SizedBox(height: 24),
        const PromotionBannersWidget(),
      ],
    );
  }
}
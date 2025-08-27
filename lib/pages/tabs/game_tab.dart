import 'package:app_hs/pages/widgets/grid_section_widget.dart';
import 'package:flutter/material.dart';

class GameTab extends StatelessWidget {
  const GameTab({super.key});
  
  final List<Map<String, dynamic>> _gameItems = const [
    {'title': 'AG游戏', 'color': Colors.red, 'icon': Icons.casino},
    {'title': 'PG电子', 'color': Colors.amber, 'icon': Icons.videogame_asset},
    {'title': '开元棋牌', 'color': Colors.blue, 'icon': Icons.grid_view},
    {'title': '同城约炮', 'color': Colors.pink, 'icon': Icons.favorite},
    {'title': '迷药', 'color': Colors.purple, 'icon': Icons.local_pharmacy},
    {'title': '换妻交友', 'color': Colors.red, 'icon': Icons.people},
  ];
  
  final List<Map<String, dynamic>> _cardGameItems = const [
    {'title': '德州扑克', 'color': Colors.green, 'icon': Icons.casino},
    {'title': '斗地主', 'color': Colors.orange, 'icon': Icons.grid_view},
    {'title': '麻将', 'color': Colors.red, 'icon': Icons.view_module},
    {'title': '炸金花', 'color': Colors.purple, 'icon': Icons.stars},
    {'title': '牛牛', 'color': Colors.blue, 'icon': Icons.pets},
    {'title': '百家乐', 'color': Colors.teal, 'icon': Icons.account_balance},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GridSectionWidget(title: '热门游戏', items: _gameItems),
        const SizedBox(height: 24),
        GridSectionWidget(title: '棋牌游戏', items: _cardGameItems),
      ],
    );
  }
}
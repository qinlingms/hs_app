import 'package:flutter/material.dart';
import 'package:app_hs/log/logger.dart';

class VideoPlatformPage extends StatefulWidget {
  const VideoPlatformPage({super.key});

  @override
  State<VideoPlatformPage> createState() => _VideoPlatformPageState();
}

class _VideoPlatformPageState extends State<VideoPlatformPage> {
  int _selectedIndex = 0;
  
  final List<String> _tabTitles = ['推荐', '游戏', '交友', '直播', '看片'];
  
  final List<Map<String, dynamic>> _gameItems = [
    {'title': 'AG游戏', 'color': Colors.red, 'icon': Icons.casino},
    {'title': 'PG电子', 'color': Colors.amber, 'icon': Icons.videogame_asset},
    {'title': '开元棋牌', 'color': Colors.blue, 'icon': Icons.grid_view},
    {'title': '同城约炮', 'color': Colors.pink, 'icon': Icons.favorite},
    {'title': '迷药', 'color': Colors.purple, 'icon': Icons.local_pharmacy},
    {'title': '换妻交友', 'color': Colors.red, 'icon': Icons.people},
  ];
  
  final List<Map<String, dynamic>> _liveItems = [
    {'title': '杏吧直播', 'color': Colors.pink, 'icon': Icons.live_tv},
    {'title': '海角社区', 'color': Colors.blue, 'icon': Icons.waves},
    {'title': '成人游戏', 'color': Colors.deepPurple, 'icon': Icons.games},
    {'title': '澳门新葡京', 'color': Colors.amber, 'icon': Icons.account_balance},
    {'title': '妹团的约炮', 'color': Colors.pink, 'icon': Icons.group},
    {'title': 'AI色色', 'color': Colors.purple, 'icon': Icons.smart_toy},
  ];

  @override
  void initState() {
    super.initState();
    logger.d('VideoPlatformPage 初始化');
  }

  Widget _buildBannerSection() {
    return Container(
      height: 200,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          colors: [Colors.purple, Colors.pink, Colors.orange],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // 背景装饰
          Positioned(
            right: 20,
            top: 20,
            child: Container(
              width: 120,
              height: 160,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.phone_android,
                size: 80,
                color: Colors.white,
              ),
            ),
          ),
          // 主要内容
          Positioned(
            left: 20,
            top: 40,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Bonus99',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  '超级大奖',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  '赢取丰厚奖励',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Text(
                    'Bonus99',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridSection(String title, List<Map<String, dynamic>> items) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1.2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('点击了 ${item['title']}'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: item['color'],
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        item['icon'],
                        size: 32,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item['title'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPromotionBanners() {
    return Column(
      children: [
        // 第一行横幅
        Container(
          height: 100,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: const LinearGradient(
              colors: [Colors.purple, Colors.blue],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: const Center(
            child: Text(
              'PG娱乐广告PG娱乐广告',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        // 第二行两个并排的横幅
        Row(
          children: [
            Expanded(
              child: Container(
                height: 120,
                margin: const EdgeInsets.only(left: 16, right: 8, top: 8, bottom: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: const LinearGradient(
                    colors: [Colors.green, Colors.teal],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    const Positioned(
                      left: 16,
                      top: 16,
                      child: Text(
                        '30',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Positioned(
                      left: 16,
                      bottom: 16,
                      child: Text(
                        '特别优惠',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: const Text(
                          'SC',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 120,
                margin: const EdgeInsets.only(left: 8, right: 16, top: 8, bottom: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: const LinearGradient(
                    colors: [Colors.orange, Colors.red],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    const Positioned(
                      left: 16,
                      top: 16,
                      child: Text(
                        '30',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Positioned(
                      left: 16,
                      bottom: 16,
                      child: Text(
                        '限时活动',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: const Text(
                          'SC',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                'XO',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
        title: const Text(
          '视频',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_border, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 顶部横幅
            _buildBannerSection(),
            
            // 标签栏
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _tabTitles.asMap().entries.map((entry) {
                    int index = entry.key;
                    String title = entry.value;
                    bool isSelected = index == _selectedIndex;
                    
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        margin: const EdgeInsets.only(right: 16),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.red : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected ? Colors.red : Colors.grey,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          title,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // 游戏网格
            _buildGridSection('热门游戏', _gameItems),
            
            const SizedBox(height: 24),
            
            // 直播网格
            _buildGridSection('直播社区', _liveItems),
            
            const SizedBox(height: 24),
            
            // 推广横幅
            _buildPromotionBanners(),
            
            const SizedBox(height: 100), // 底部间距
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        currentIndex: 1, // 设置当前选中视频tab
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '导航',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_library),
            label: '视频',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.apps),
            label: '分类',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: '赠礼',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '我的',
          ),
        ],
        onTap: (index) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('点击了底部导航第${index + 1}项'),
              duration: const Duration(seconds: 1),
            ),
          );
        },
      ),
    );
  }
}
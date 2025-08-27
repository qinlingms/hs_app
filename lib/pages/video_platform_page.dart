import 'package:flutter/material.dart';
import 'package:app_hs/log/logger.dart';
import 'dart:async';

class VideoPlatformPage extends StatefulWidget {
  const VideoPlatformPage({super.key});

  @override
  State<VideoPlatformPage> createState() => _VideoPlatformPageState();
}

class _VideoPlatformPageState extends State<VideoPlatformPage> {
  int _selectedIndex = 0;
  int _currentBannerIndex = 0;
  late PageController _bannerPageController;
  late Timer _bannerTimer;
  
  final List<String> _tabTitles = ['推荐', '游戏', '交友', '直播', '看片'];
  
  // 轮播图数据
  final List<Map<String, dynamic>> _bannerItems = [
    {
      'title': '超级大奖',
      'subtitle': '赢取丰厚奖励',
      'colors': [Colors.purple, Colors.pink, Colors.orange],
      'buttonText': 'Bonus99',
    },
    {
      'title': '限时活动',
      'subtitle': '立即参与获得奖励',
      'colors': [Colors.blue, Colors.cyan, Colors.teal],
      'buttonText': '立即参与',
    },
    {
      'title': '新用户福利',
      'subtitle': '注册即送大礼包',
      'colors': [Colors.red, Colors.orange, Colors.yellow],
      'buttonText': '立即注册',
    },
    {
      'title': '每日签到',
      'subtitle': '连续签到获得更多奖励',
      'colors': [Colors.green, Colors.lightGreen, Colors.lime],
      'buttonText': '立即签到',
    },
  ];
  
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
    _bannerPageController = PageController();
    _startBannerTimer();
  }

  @override
  void dispose() {
    _bannerTimer.cancel();
    _bannerPageController.dispose();
    super.dispose();
  }

  void _startBannerTimer() {
    _bannerTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_currentBannerIndex < _bannerItems.length - 1) {
        _currentBannerIndex++;
      } else {
        _currentBannerIndex = 0;
      }
      
      if (_bannerPageController.hasClients) {
        _bannerPageController.animateToPage(
          _currentBannerIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  Widget _buildBannerSection() {
    return Container(
      height: 200,
      margin: const EdgeInsets.all(16),
      child: Stack(
        children: [
          // 轮播图主体
          PageView.builder(
            controller: _bannerPageController,
            onPageChanged: (index) {
              setState(() {
                _currentBannerIndex = index;
              });
            },
            itemCount: _bannerItems.length,
            itemBuilder: (context, index) {
              final item = _bannerItems[index];
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: item['colors'],
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
                          Text(
                            item['title'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            item['subtitle'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 20),
                          GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('点击了 ${item['buttonText']}'),
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Text(
                                item['buttonText'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          // 指示器
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _bannerItems.asMap().entries.map((entry) {
                return Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentBannerIndex == entry.key
                        ? Colors.white
                        : Colors.white.withOpacity(0.4),
                  ),
                );
              }).toList(),
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

  // 为每个标签页创建不同的内容
  Widget _buildTabContent() {
    switch (_selectedIndex) {
      case 0: // 推荐
        return Column(
          children: [
            _buildGridSection('热门推荐', _gameItems),
            const SizedBox(height: 24),
            _buildGridSection('精选内容', _liveItems),
            const SizedBox(height: 24),
            _buildPromotionBanners(),
          ],
        );
      case 1: // 游戏
        return Column(
          children: [
            _buildGridSection('热门游戏', _gameItems),
            const SizedBox(height: 24),
            _buildGridSection('棋牌游戏', [
              {'title': '德州扑克', 'color': Colors.green, 'icon': Icons.casino},
              {'title': '斗地主', 'color': Colors.orange, 'icon': Icons.grid_view},
              {'title': '麻将', 'color': Colors.red, 'icon': Icons.view_module},
              {'title': '炸金花', 'color': Colors.purple, 'icon': Icons.stars},
              {'title': '牛牛', 'color': Colors.blue, 'icon': Icons.pets},
              {'title': '百家乐', 'color': Colors.teal, 'icon': Icons.account_balance},
            ]),
          ],
        );
      case 2: // 交友
        return Column(
          children: [
            _buildGridSection('交友社区', [
              {'title': '同城交友', 'color': Colors.pink, 'icon': Icons.location_on},
              {'title': '语音聊天', 'color': Colors.purple, 'icon': Icons.mic},
              {'title': '视频聊天', 'color': Colors.blue, 'icon': Icons.videocam},
              {'title': '匿名聊天', 'color': Colors.grey, 'icon': Icons.visibility_off},
              {'title': '兴趣群组', 'color': Colors.green, 'icon': Icons.group},
              {'title': '约会活动', 'color': Colors.red, 'icon': Icons.event},
            ]),
            const SizedBox(height: 24),
            _buildGridSection('热门话题', [
              {'title': '情感倾诉', 'color': Colors.pink, 'icon': Icons.favorite},
              {'title': '生活分享', 'color': Colors.orange, 'icon': Icons.share},
              {'title': '兴趣爱好', 'color': Colors.blue, 'icon': Icons.interests},
              {'title': '职场交流', 'color': Colors.indigo, 'icon': Icons.work},
            ]),
          ],
        );
      case 3: // 直播
        return Column(
          children: [
            _buildGridSection('热门直播', _liveItems),
            const SizedBox(height: 24),
            _buildGridSection('直播分类', [
              {'title': '游戏直播', 'color': Colors.purple, 'icon': Icons.games},
              {'title': '音乐直播', 'color': Colors.pink, 'icon': Icons.music_note},
              {'title': '舞蹈直播', 'color': Colors.red, 'icon': Icons.music_video},
              {'title': '聊天直播', 'color': Colors.blue, 'icon': Icons.chat},
              {'title': '户外直播', 'color': Colors.green, 'icon': Icons.nature},
              {'title': '美食直播', 'color': Colors.orange, 'icon': Icons.restaurant},
            ]),
          ],
        );
      case 4: // 看片
        return Column(
          children: [
            _buildGridSection('热门影片', [
              {'title': '最新电影', 'color': Colors.red, 'icon': Icons.movie},
              {'title': '热播剧集', 'color': Colors.blue, 'icon': Icons.tv},
              {'title': '综艺节目', 'color': Colors.orange, 'icon': Icons.theater_comedy},
              {'title': '纪录片', 'color': Colors.green, 'icon': Icons.nature_people},
              {'title': '动漫', 'color': Colors.purple, 'icon': Icons.animation},
              {'title': '短视频', 'color': Colors.pink, 'icon': Icons.video_library},
            ]),
            const SizedBox(height: 24),
            _buildGridSection('分类推荐', [
              {'title': '动作片', 'color': Colors.red, 'icon': Icons.local_fire_department},
              {'title': '喜剧片', 'color': Colors.yellow, 'icon': Icons.sentiment_very_satisfied},
              {'title': '爱情片', 'color': Colors.pink, 'icon': Icons.favorite},
              {'title': '科幻片', 'color': Colors.blue, 'icon': Icons.rocket_launch},
            ]),
          ],
        );
      default:
        return Column(
          children: [
            _buildGridSection('热门游戏', _gameItems),
            const SizedBox(height: 24),
            _buildGridSection('直播社区', _liveItems),
            const SizedBox(height: 24),
            _buildPromotionBanners(),
          ],
        );
    }
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
                        logger.d('切换到标签页: $title (索引: $index)');
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
            
            // 根据选中的标签显示不同内容
            _buildTabContent(),
            
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
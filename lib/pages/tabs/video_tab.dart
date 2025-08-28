import 'package:app_hs/log/logger.dart';
import 'package:app_hs/model/menu.dart';
import 'package:app_hs/pages/tabs/video_tab_content.dart';
import 'package:app_hs/service/movie_service.dart';
import 'package:flutter/material.dart';

class VideoTab extends StatefulWidget {
  const VideoTab({super.key});

  @override
  State<VideoTab> createState() => _VideoTabState();
}

class _VideoTabState extends State<VideoTab> with TickerProviderStateMixin {
  late PageController _bannerController;
  late TabController _tabController;
  AnimationController? _headerAnimationController;
  Animation<double>? _headerAnimation;
  int _currentBannerIndex = 0;
  bool _isHeaderVisible = true;
  bool _isAutoScrolling = false; // 添加标志来标识是否正在自动滚动

  //加载中
  bool isLoading = true;

  // 轮播广告数据
  final List<Map<String, dynamic>> _bannerAds = [
    {
      'title': 'Fortune Dragon',
      'subtitle': '新用户注册即送彩金',
      'brand': 'Bonus99',
      'color': LinearGradient(
        colors: [Color(0xFF6a4c93), Color(0xFF9b59b6)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    },
    {
      'title': 'Lucky Slots',
      'subtitle': '首充送100%奖金',
      'brand': 'Bonus99',
      'color': LinearGradient(
        colors: [Color(0xFFe74c3c), Color(0xFFf39c12)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    },
    {
      'title': 'Mega Win',
      'subtitle': '每日签到送好礼',
      'brand': 'Bonus99',
      'color': LinearGradient(
        colors: [Color(0xFF2ecc71), Color(0xFF27ae60)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    },
  ];

  // 广告板块数据（2排）
  final List<Map<String, dynamic>> _adBlocks = [
    {'name': 'AG真人', 'icon': Icons.person, 'color': Colors.red},
    {'name': 'PG电子', 'icon': Icons.games, 'color': Colors.blue},
    {'name': '开元棋牌', 'icon': Icons.casino, 'color': Colors.green},
    {'name': '同城约炮', 'icon': Icons.location_on, 'color': Colors.orange},
    {'name': '迷药', 'icon': Icons.medical_services, 'color': Colors.purple},
    {'name': '换妻交友', 'icon': Icons.favorite, 'color': Colors.pink},
    {'name': '杏吧直播', 'icon': Icons.live_tv, 'color': Colors.red},
    {'name': '海角社区', 'icon': Icons.waves, 'color': Colors.blue},
    {'name': '成人游戏', 'icon': Icons.gamepad, 'color': Colors.green},
    {'name': '澳门新葡京', 'icon': Icons.account_balance, 'color': Colors.amber},
    {'name': '妹团约炮', 'icon': Icons.group, 'color': Colors.pink},
    {'name': 'AI色色', 'icon': Icons.smart_toy, 'color': Colors.deepPurple},
  ];

  // 储存完整的菜单数据
  List<Menu> _menuList = [];

  // 查询条件数据
  final List<String> _filterTabs = ['推荐', '最新', '最热'];
  // menuId, 选中的查询条件
  final Map<String, int> _selectedFilters = {};

  @override
  void initState() {
    super.initState();

    // 初始化时获取数据
    fetchData();
    _bannerController = PageController();
    // 初始化头部动画控制器
    _headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _headerAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _headerAnimationController!,
        curve: Curves.easeInOut,
      ),
    );

    // 初始状态显示头部
    _headerAnimationController!.forward();

    // 自动轮播
    _startAutoScroll();
  }

  // 获取数据
  void fetchData() async {
    try {
      setState(() {
        isLoading = true;
      });
      final res = await MovieService.menuList();
      setState(() {
        _menuList = res;
        // 重新初始化TabController
        _tabController = TabController(
          length: _menuList.length,
          vsync: this,
          initialIndex: 0,
        );
        isLoading = false;
      });
    } catch (e) {
      logger.e("fetchData: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  // void _onTabChanged() async {
  //   if (_tabController?.indexIsChanging == true) {
  //     return;
  //   }
  // }

  // 自动滚动
  void _startAutoScroll() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && _bannerController.hasClients == true) {
        int nextPage = (_currentBannerIndex + 1) % _bannerAds.length;

        // 设置自动滚动标志
        _isAutoScrolling = true;

        _bannerController
            .animateToPage(
              nextPage,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            )
            .then((_) {
              // 动画完成后重置标志
              _isAutoScrolling = false;
            });

        _startAutoScroll();
      }
    });
  }

  @override
  void dispose() {
    _bannerController.dispose();
    _tabController.dispose();
    _headerAnimationController?.dispose();
    super.dispose();
  }

  // 处理滑动事件
  bool _handleScrollNotification(ScrollNotification notification) {
    // 如果正在自动滚动，忽略滑动事件
    if (_isAutoScrolling) {
      return false;
    }

    // 只处理来自NestedScrollView的滑动事件，忽略来自广告栏PageView的滑动
    if (notification.depth != 0) {
      return false;
    }

    if (notification is ScrollUpdateNotification) {
      // 向上滑动（delta > 0）隐藏头部，向下滑动不再显示头部
      if (notification.scrollDelta! > 10 && _isHeaderVisible) {
        // 向上滑动，隐藏头部
        setState(() {
          _isHeaderVisible = false;
        });
        _headerAnimationController!.reverse();
      }
      // 移除向下滑动显示头部的逻辑
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    if (_headerAnimationController == null ||
        _menuList.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: NotificationListener<ScrollNotification>(
        onNotification: _handleScrollNotification,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              // 顶部滚动广告 - 可以被滑动隐藏
              SliverToBoxAdapter(
                child: AnimatedBuilder(
                  animation: _headerAnimation!,
                  builder: (context, child) {
                    return SizeTransition(
                      sizeFactor: _headerAnimation!,
                      child: FadeTransition(
                        opacity: _headerAnimation!,
                        child: NotificationListener<ScrollNotification>(
                          onNotification:
                              (notification) => true, // 阻止广告栏的滑动事件向上传播
                          child: _buildScrollingBanner(),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // 2排广告板块 - 可以被滑动隐藏
              SliverToBoxAdapter(
                child: AnimatedBuilder(
                  animation: _headerAnimation!,
                  builder: (context, child) {
                    return SizeTransition(
                      sizeFactor: _headerAnimation!,
                      child: FadeTransition(
                        opacity: _headerAnimation!,
                        child: _buildAdBlocks(),
                      ),
                    );
                  },
                ),
              ),

              // Tab栏 + 标签 + 查询条件 - 固定在顶部
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverTabBarDelegate(
                  TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    indicator: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.grey[400],
                    labelStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                    tabs:
                        _menuList.map((tab) => Tab(text: tab.display)).toList(),
                  ),
                  _tabController,
                  _buildFixedTagsAndFilters,
                ),
              ),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children:
                _menuList
                    .map(
                      (tab) => _buildTabContent(tab.menuId),
                    ) // 修改：传递menuId而不是categoryId
                    .toList(),
          ),
        ),
      ),
    );
  }

  // 1. 顶部滚动广告
  Widget _buildScrollingBanner() {
    return Container(
      height: 180,
      margin: const EdgeInsets.all(16),
      child: PageView.builder(
        controller: _bannerController,
        onPageChanged: (index) {
          setState(() {
            _currentBannerIndex = index;
          });
        },
        itemCount: _bannerAds.length,
        itemBuilder: (context, index) {
          final ad = _bannerAds[index];
          return Container(
            decoration: BoxDecoration(
              gradient: ad['color'],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                // 左侧内容
                Positioned(
                  left: 20,
                  top: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          ad['brand'],
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        ad['title'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        ad['subtitle'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          '@bonus99',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // 右侧手机和游戏图标
                Positioned(
                  right: 20,
                  top: 20,
                  child: SizedBox(
                    width: 120,
                    height: 140,
                    child: Stack(
                      children: [
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            width: 80,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(
                              Icons.phone_android,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 0,
                          bottom: 0,
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.casino,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 15,
                          bottom: 15,
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.games,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // 指示器
                Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:
                        _bannerAds.asMap().entries.map((entry) {
                          return Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  _currentBannerIndex == entry.key
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
        },
      ),
    );
  }

  // 2. 2排广告板块
  Widget _buildAdBlocks() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 6,
          childAspectRatio: 0.8,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: _adBlocks.length,
        itemBuilder: (context, index) {
          final block = _adBlocks[index];
          return GestureDetector(
            onTap: () {
              // 处理广告板块点击
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: block['color'],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(block['icon'], color: Colors.white, size: 20),
                ),
                const SizedBox(height: 4),
                Flexible(
                  child: Text(
                    block['name'],
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // 构建固定的标签和查询条件
  Widget _buildFixedTagsAndFilters() {
    // 为 _tabController 添加空值检查，确保 _menuList 不为空
    if (_menuList.isEmpty) {
      return const SizedBox.shrink();
    }
    
    final currentTabName = _menuList[_tabController!.index].display;

    return Column(
      children: [
        // 标签区域
        //_buildTagsSection(currentTabName),
        // 查询条件
        _buildFilterSection(currentTabName),
      ],
    );
  }

  // 每个Tab页的内容（只包含视频列表）
  Widget _buildTabContent(String menuId) {
    // Find the specific VideoTabContent for this menuId
    final menuIndex = _menuList.indexWhere((item) => item.menuId == menuId);
    if (menuIndex == -1) {
      return const Center(child: Text('Menu not found'));
    }
    
    return VideoTabContent(
      menuId: menuId,
      tabController: _tabController,
      tabIndex: menuIndex,
    );
  }

  // 查询条件
  Widget _buildFilterSection(String menuId) {
    final selectedFilter = _selectedFilters[menuId] ?? 0;

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 0,
      ), // 减少垂直margin从8到4
      child: Row(
        children:
            _filterTabs.asMap().entries.map((entry) {
              final index = entry.key;
              final filter = entry.value;
              final isSelected = index == selectedFilter;

              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedFilters[menuId] = index;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.black : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? Colors.orange : Colors.grey[700]!,
                      ),
                    ),
                    child: Text(
                      filter,
                      style: TextStyle(
                        color: isSelected ? Colors.orange : Colors.grey[400],
                        fontSize: 14,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }
}

// 自定义SliverPersistentHeaderDelegate用于固定Tab栏、标签和查询条件
class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;
  final TabController _tabController;
  final Widget Function() _buildTagsAndFilters;

  _SliverTabBarDelegate(
    this._tabBar,
    this._tabController,
    this._buildTagsAndFilters,
  );

  @override
  double get minExtent => _tabBar.preferredSize.height + 80; // 减少高度避免遮挡

  @override
  double get maxExtent => _tabBar.preferredSize.height + 80;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Colors.white, // 将背景改为透明
      child: Column(
        mainAxisSize: MainAxisSize.min, // 添加这行以防止Column占用过多空间
        children: [
          // Tab栏
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(25),
              ),
              child: _tabBar,
            ),
          ),

          // 标签和查询条件
          Flexible(
            // 使用Flexible包装以防止溢出
            child: _buildTagsAndFilters(),
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return true; // 需要重建以响应Tab切换
  }
}

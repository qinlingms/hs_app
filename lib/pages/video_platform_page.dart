import 'package:flutter/material.dart';
import 'package:app_hs/log/logger.dart';
import 'dart:async';
import 'tabs/recommend_tab.dart';
import 'tabs/game_tab.dart';
import 'tabs/social_tab.dart';
import 'tabs/live_tab.dart';
import 'tabs/video_tab.dart';
import 'tabs/category_tab.dart';
import 'tabs/gift_tab.dart';
import 'tabs/profile_tab.dart';
import 'widgets/banner_widget.dart';

class VideoPlatformPage extends StatefulWidget {
  const VideoPlatformPage({super.key});

  @override
  State<VideoPlatformPage> createState() => _VideoPlatformPageState();
}

class _VideoPlatformPageState extends State<VideoPlatformPage> {
  int _selectedIndex = 0;
  int _bottomNavIndex = 0;
  bool _isRefreshing = false;
  
  final List<String> _tabTitles = ['推荐', '游戏', '交友', '直播', '看片'];

  @override
  void initState() {
    super.initState();
    logger.d('VideoPlatformPage 初始化');
  }

  Future<void> _onRefresh() async {
    setState(() {
      _isRefreshing = true;
    });
    
    logger.d('开始下拉刷新');
    
    try {
      await Future.delayed(const Duration(seconds: 2));
      
      logger.d('下拉刷新完成');
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('刷新成功'),
            duration: Duration(seconds: 1),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      logger.e('下拉刷新失败: $e');
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('刷新失败，请重试'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isRefreshing = false;
        });
      }
    }
  }
  
  Widget _buildTabContent() {
    switch (_selectedIndex) {
      case 0:
        return const RecommendTab();
      case 1:
        return const GameTab();
      case 2:
        return const SocialTab();
      case 3:
        return const LiveTab();
      case 4:
        return const VideoTab();
      default:
        return const RecommendTab();
    }
  }
  
  Widget _buildBottomNavContent() {
    switch (_bottomNavIndex) {
      case 0:
        return _buildMainContent();
      case 1:
        return const VideoTab();
      case 2:
        return const CategoryTab();
      case 3:
        return const GiftTab();
      case 4:
        return const ProfileTab();
      default:
        return _buildMainContent();
    }
  }
  
  Widget _buildMainContent() {
    return Column(
      children: [
        const BannerWidget(),
        
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
        
        _buildTabContent(),
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
        title: Text(
          _bottomNavIndex == 1 ? '视频' : '视频',
          style: const TextStyle(
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
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: Colors.red,
        backgroundColor: Colors.white,
        strokeWidth: 2.0,
        displacement: 40.0,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              _buildBottomNavContent(),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        currentIndex: _bottomNavIndex,
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
          setState(() {
            _bottomNavIndex = index;
          });
          
          if (index == 1) {
            logger.d('显示视频内容');
          } else {
            logger.d('切换到底部导航第${index + 1}项');
          }
        },
      ),
    );
  }
}
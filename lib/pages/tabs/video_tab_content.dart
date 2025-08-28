import 'package:app_hs/model/movie.dart';
import 'package:app_hs/pages/widgets/video_widget.dart';
import 'package:app_hs/service/movie_service.dart';
import 'package:flutter/material.dart';

class VideoTabContent extends StatefulWidget {
  final String menuId; // Tab标题，用于错误信息展示
  final TabController tabController;
  final int tabIndex;

  const VideoTabContent({
    super.key,
    required this.menuId,
    required this.tabController,
    required this.tabIndex,
  });

  @override
  State<VideoTabContent> createState() => _VideoTabContentState();
}

// 视频列表
class _VideoTabContentState extends State<VideoTabContent> {
  List<Movie> _movies= [];
  bool _isLoading = false; // 当前Tab是否正在加载数据
  bool _hasLoaded = false; // 当前Tab是否已加载过数据
  @override
  void initState() {
    super.initState();
    //切换tab时加载数据
    widget.tabController.addListener(_onTabChanged);

    // 5. 默认选中的Tab（第一个）在初始化时加载数据
    if (widget.tabController.index == widget.tabIndex) {
      _loadContent();
    }
  }

  // 监听Tab切换
  void _onTabChanged() {
    // 当切换到当前Tab，且未加载过数据时，触发加载
    if (widget.tabController.index == widget.tabIndex && !_hasLoaded) {
      _loadContent();
    }
  }

  // 加载当前Tab的内容
  Future<void> _loadContent() async {
    if (_isLoading) return; // 防止重复请求
    setState(() {
      _isLoading = true;
    });
    final content = await MovieService.moviePopularList(widget.menuId);
    setState(() {
      _isLoading = false;
      _hasLoaded = true;
      _movies = content;
    });
  }

  // 刷新内容
  // void _refreshContent() {
  //   setState(() {
  //     _loadContent();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // 显示加载状态

    // 显示错误状态

    // 显示数据列表
    return RefreshIndicator(
      onRefresh: () async => _loadContent(), // 下拉刷新
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _movies.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: VideoWidget(
                
              ),
            ),
          );
        },
      ),
    );
  }
}

import 'package:app_hs/model/movie.dart';
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
  late Future<List<Movie>> _contentFuture;
  bool _isLoading = false; // 当前Tab是否正在加载数据
  bool _hasLoaded = false; // 当前Tab是否已加载过数据
  @override
  void initState() {
    super.initState();

    _contentFuture = Future.value([]);
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
      _contentFuture = Future.value(content);
    });
  }

  // 刷新内容
  void _refreshContent() {
    setState(() {
      _loadContent();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Movie>>(
      future: _contentFuture,
      builder: (context, snapshot) {
        // 加载中状态
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: Text("加载中"));
        }
        // 错误状态
        else if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '加载${widget.menuId}数据失败:\n${snapshot.error}',
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _refreshContent,
                  child: const Text('重试'),
                ),
              ],
            ),
          );
        }
        // 数据加载成功
        else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return RefreshIndicator(
            onRefresh: () async => _refreshContent(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Movie item = snapshot.data![index];
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          item.title,
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }
        // 没有数据
        else {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('${widget.menuId}没有数据'),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _refreshContent,
                  child: const Text('刷新'),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

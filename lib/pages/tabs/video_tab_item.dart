import 'package:app_hs/models/movie.dart';
import 'package:app_hs/service/movie_service.dart';
import 'package:flutter/material.dart';

class VideoTabContent extends StatefulWidget {
  final String menuId; // Tab标题，用于错误信息展示

  const VideoTabContent({
    super.key,
    required this.menuId,
  });

  @override
  State<VideoTabContent> createState() => _VideoTabContentState();
}

class _VideoTabContentState extends State<VideoTabContent> {
  //final ApiService apiService = ApiService();
  late Future<List<Movie>> _contentFuture;

  @override
  void initState() {
    super.initState();
    _loadContent();
  }

  // 加载当前Tab的内容
  void _loadContent() {
    _contentFuture = MovieService.moviePopularList(widget.menuId);
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
          return Center(
            child: Text("加载中"),
          );
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

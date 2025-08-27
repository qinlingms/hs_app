import 'package:flutter/material.dart';

class CategoryTab extends StatefulWidget {
  const CategoryTab({super.key});

  @override
  State<CategoryTab> createState() => _CategoryTabState();
}

class _CategoryTabState extends State<CategoryTab> {
  int _selectedTabIndex = 0; // 0: 分类, 1: 女优

  // 分类数据
  static const List<Map<String, String>> _categories = [
    {'title': '国产自拍', 'image': 'assets/images/category1.jpg'},
    {'title': '国产传媒', 'image': 'assets/images/category2.jpg'},
    {'title': '日韩', 'image': 'assets/images/category3.jpg'},
    {'title': '欧美', 'image': 'assets/images/category4.jpg'},
    {'title': '网络红人', 'image': 'assets/images/category5.jpg'},
    {'title': '角色扮演', 'image': 'assets/images/category6.jpg'},
    {'title': '少女学生', 'image': 'assets/images/category7.jpg'},
    {'title': '制服诱惑', 'image': 'assets/images/category8.jpg'},
    {'title': '强好淫好', 'image': 'assets/images/category9.jpg'},
    {'title': '乱伦换妻', 'image': 'assets/images/category10.jpg'},
    {'title': 'SM调教', 'image': 'assets/images/category11.jpg'},
    {'title': '人妻少妇', 'image': 'assets/images/category12.jpg'},
    {'title': '多人群P', 'image': 'assets/images/category13.jpg'},
    {'title': '探花约炮', 'image': 'assets/images/category14.jpg'},
    {'title': '剧情', 'image': 'assets/images/category15.jpg'},
    {'title': '巨乳熟女', 'image': 'assets/images/category16.jpg'},
    {'title': '明星黑料', 'image': 'assets/images/category17.jpg'},
    {'title': '另类重口', 'image': 'assets/images/category18.jpg'},
    {'title': '男同女同', 'image': 'assets/images/category19.jpg'},
    {'title': '动漫同人', 'image': 'assets/images/category20.jpg'},
  ];

  // 女优数据
  static const List<Map<String, String>> _actresses = [
    {'title': '波多野结衣', 'image': 'assets/images/actress1.jpg'},
    {'title': '三上悠亚', 'image': 'assets/images/actress2.jpg'},
    {'title': '桥本有菜', 'image': 'assets/images/actress3.jpg'},
    {'title': '深田咏美', 'image': 'assets/images/actress4.jpg'},
    {'title': '明日花绮罗', 'image': 'assets/images/actress5.jpg'},
    {'title': '小岛南', 'image': 'assets/images/actress6.jpg'},
    {'title': '天使萌', 'image': 'assets/images/actress7.jpg'},
    {'title': '桃乃木香奈', 'image': 'assets/images/actress8.jpg'},
    {'title': '高桥圣子', 'image': 'assets/images/actress9.jpg'},
    {'title': '樱空桃', 'image': 'assets/images/actress10.jpg'},
    {'title': '相泽南', 'image': 'assets/images/actress11.jpg'},
    {'title': '白石茉莉奈', 'image': 'assets/images/actress12.jpg'},
    {'title': '筱田优', 'image': 'assets/images/actress13.jpg'},
    {'title': '佐山爱', 'image': 'assets/images/actress14.jpg'},
    {'title': '椎名由奈', 'image': 'assets/images/actress15.jpg'},
    {'title': '麻生希', 'image': 'assets/images/actress16.jpg'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 顶部标签切换
          Container(
            height: 50,
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedTabIndex = 0;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: _selectedTabIndex == 0 ? Colors.red : Colors.transparent,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Center(
                        child: Text(
                          '分类',
                          style: TextStyle(
                            color: _selectedTabIndex == 0 ? Colors.white : Colors.grey,
                            fontSize: 16,
                            fontWeight: _selectedTabIndex == 0 ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedTabIndex = 1;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: _selectedTabIndex == 1 ? Colors.red : Colors.transparent,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Center(
                        child: Text(
                          '女优',
                          style: TextStyle(
                            color: _selectedTabIndex == 1 ? Colors.white : Colors.grey,
                            fontSize: 16,
                            fontWeight: _selectedTabIndex == 1 ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // 内容区域
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 12,
                mainAxisSpacing: 16,
                childAspectRatio: 0.8,
              ),
              itemCount: _selectedTabIndex == 0 ? _categories.length : _actresses.length,
              itemBuilder: (context, index) {
                final data = _selectedTabIndex == 0 ? _categories[index] : _actresses[index];
                return GestureDetector(
                  onTap: () {
                    // 处理点击事件
                    print('点击了${_selectedTabIndex == 0 ? "分类" : "女优"}: ${data['title']}');
                  },
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey[900],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              width: double.infinity,
                              color: Colors.grey[800],
                              child: Icon(
                                _selectedTabIndex == 0 ? Icons.category : Icons.person,
                                color: Colors.grey[600],
                                size: 40,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        data['title']!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
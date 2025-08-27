import 'package:flutter/material.dart';
import 'package:app_hs/log/logger.dart';

class ExamplePage extends StatefulWidget {
  const ExamplePage({super.key});

  @override
  State<ExamplePage> createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  int _counter = 0;
  String _inputText = '';
  bool _isLoading = false;
  final TextEditingController _textController = TextEditingController();
  final List<String> _items = ['项目1', '项目2', '项目3', '项目4', '项目5'];

  @override
  void initState() {
    super.initState();
    logger.d('ExamplePage 初始化');
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
    logger.d('计数器增加到: $_counter');
  }

  void _onTextChanged(String value) {
    setState(() {
      _inputText = value;
    });
  }

  Future<void> _simulateAsyncOperation() async {
    setState(() {
      _isLoading = true;
    });
    
    // 模拟网络请求
    await Future.delayed(const Duration(seconds: 2));
    
    setState(() {
      _isLoading = false;
    });
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('操作完成！'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('提示'),
          content: Text('当前计数器值: $_counter\n输入内容: $_inputText'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('确定'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('示例页面'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: _showDialog,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 计数器卡片
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      '计数器',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '$_counter',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _incrementCounter,
                      child: const Text('增加'),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // 输入框卡片
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '文本输入',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _textController,
                      onChanged: _onTextChanged,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: '请输入内容',
                        hintText: '在这里输入一些文字...',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '当前输入: $_inputText',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // 列表卡片
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '列表项目',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _items.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: CircleAvatar(
                            child: Text('${index + 1}'),
                          ),
                          title: Text(_items[index]),
                          subtitle: Text('这是第${index + 1}个项目'),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('点击了 ${_items[index]}'),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // 异步操作按钮
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      '异步操作',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _isLoading
                        ? const Column(
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 8),
                              Text('正在处理...'),
                            ],
                          )
                        : ElevatedButton.icon(
                            onPressed: _simulateAsyncOperation,
                            icon: const Icon(Icons.cloud_download),
                            label: const Text('模拟网络请求'),
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showDialog,
        tooltip: '显示信息',
        child: const Icon(Icons.info),
      ),
    );
  }
}
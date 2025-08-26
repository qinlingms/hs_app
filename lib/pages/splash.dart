import 'dart:async';

import 'package:app_hs/pages/home.dart';
import 'package:flutter/material.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int _countdownSeconds = 5;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    
    // 初始化定时器，每秒更新一次倒计时
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _countdownSeconds--;
      });
      
      // 当倒计时结束时，跳转到主页
      if (_countdownSeconds <= 0) {
        _timer.cancel();
        _navigateToHome();
      }
    });
  }

  // 跳转到主页的方法
  void _navigateToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  @override
  void dispose() {
    _timer.cancel(); // 页面销毁时取消定时器，防止内存泄漏
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 启动页主体内容
          Container(
            color: Colors.white,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 应用Logo
                  const Icon(
                    Icons.apps,
                    size: 100,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 20),
                  // 应用名称
                  const Text(
                    '我的应用',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
          
          // 右上角的倒计时显示（仅显示倒计时，无跳过功能）
          Positioned(
            top: 40, // 距离顶部的距离
            right: 20, // 距离右侧的距离
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${_countdownSeconds}s', // 仅显示倒计时秒数
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

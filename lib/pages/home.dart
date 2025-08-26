import 'package:app_hs/http/mtls_http_client.dart';
import 'package:app_hs/service_locator.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blue,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    MtlsHttpClient client = getIt<MtlsHttpClient>();

    Future<Response?> future = client.post("/api/v1/internal/app/share");
    future.then((response) {
      print("请求成功：${response!.data}");
    }).catchError((error) {
      print("请求失败：$error");
    });
  }
}
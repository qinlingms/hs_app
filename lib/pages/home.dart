import 'package:app_hs/http/mtls_http_client.dart';
import 'package:app_hs/log/logger.dart';
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
    return Scaffold(body: Container(color: Colors.blue));
  }

  @override
  void initState() {
    super.initState();
    MtlsHttpClient client = getIt<MtlsHttpClient>();
    Map<String, dynamic> dataObj = {
      "appVer": "v0.0.1",
      "resId": "111",
      "timeStamp": DateTime.now().millisecondsSinceEpoch ~/ 1000,
      "data": {},
    };
    Map<String, String> headers = {"X-UUID": "11111"};
    Future<Response?> future = client.post(
      "/api/v1/login/anonymous",
      headers: headers,
      data: dataObj,
    );
    future
        .then((response) {
          logger.d("请求成功：$response");
        })
        .catchError((error) {
          logger.d("请求失败：$error");
        });
  }
}

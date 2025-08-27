import 'package:app_hs/http/api.dart';
import 'package:app_hs/http/mtls_http_client.dart';
import 'package:app_hs/http/resp.dart';
import 'package:app_hs/log/logger.dart';
import 'package:app_hs/service_locator.dart';
import 'package:app_hs/storage/login_info.dart';
import 'package:app_hs/utils/http_request_data.dart';
import 'package:app_hs/utils/http_request_header.dart';
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
    Future<ApiResponse?> future = client.post(
      Api.anonymousLogin,
      headers: HttpRequestHeader.getNormalHeader(),
      data: HttpRequestData.build(data: {}),
    );
    future
        .then((response) {
          if (response?.isSuccess == true) {
            logger.d("请求成功：${response?.data}");
            LoginInfo.saveLoginInfo(
              sessionId: response?.data?[LoginInfo.sessionId] ?? '',
              uid: response?.data?[LoginInfo.uid] ?? '',
              authToken: response?.data?[LoginInfo.authToken] ?? '',
              ttl: response?.data?[LoginInfo.ttl] ?? 0,
            );
          }
        })
        .catchError((error) {
          logger.d("请求失败：$error");
        });
  }
}

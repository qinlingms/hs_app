import 'package:app_hs/http/api.dart';
import 'package:app_hs/http/mtls_http_client.dart';
import 'package:app_hs/http/resp.dart';
import 'package:app_hs/service_locator.dart';

class LoginService {
  Future<ApiResponse?> login() async {
    MtlsHttpClient client = getIt<MtlsHttpClient>();
    Future<ApiResponse?> resp = client.post(
      Api.login,
      data: {
        "username": "admin",
        "password": "123456",
      },
    );
    return resp;
  }
}
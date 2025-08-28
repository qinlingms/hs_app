import 'package:app_hs/http/api.dart';
import 'package:app_hs/http/mtls_http_client.dart';
import 'package:app_hs/model/login_info.dart';
import 'package:app_hs/service_locator.dart';

class LoginService {
  static Future<LoginInfo?> anonymousLogin() async {
    MtlsHttpClient client = getIt<MtlsHttpClient>();
    final resp = await client.post(Api.anonymousLogin, data: {});
    if (resp == null || resp.isFailure) {
      return null;
    }
    if (resp.isSuccess) {
      final data = resp.data;
      if (data != null) {
        return LoginInfo.fromJson(data);
      }
    }
    return null;
  }
}

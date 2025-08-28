import 'package:app_hs/http/api.dart';
import 'package:app_hs/http/mtls_http_client.dart';
import 'package:app_hs/log/logger.dart';
import 'package:app_hs/model/menu.dart';
import 'package:app_hs/model/tag.dart';
import 'package:app_hs/service_locator.dart';
import 'package:app_hs/utils/http_request_header.dart';

class MovieService {
  // 菜单列表
  static Future<List<Menu>> menuList() async {
    MtlsHttpClient client = getIt<MtlsHttpClient>();
    try {
      final resp = await client.post(
        Api.movieMenu,
        headers: HttpRequestHeader.getNormalHeader(),
        data: {},
      );
      List<Menu> menus = [];
      if (resp == null || resp.isFailure) {
        return menus;
      }
      if (resp.isSuccess) {
        for (var item in resp.data!['list'] as List) {
          menus.add(Menu.fromJson(item));
        }
      }
      return menus;
    } catch (e) {
      logger.e("menuList: $e");
      return [];
    }
  }

  // tags 分类
  static Future<List<Tag>> tags(String categoryId) async {
    MtlsHttpClient client = getIt<MtlsHttpClient>();
    try {
      final resp = await client.post(
        "${Api.category}/$categoryId/tag_list",
        headers: HttpRequestHeader.getNormalHeader(),
        data: {},
      );
      List<Tag> tagsList = [];
      if (resp == null || resp.isFailure) {
        return tagsList;
      }
      if (resp.isSuccess) {
        for (var item in resp.data!['list'] as List) {
          tagsList.add(Tag.fromJson(item));
        }
      }
      return tagsList;
    } catch (e) {
      logger.e("tagsList: $e");
      return [];
    }
  }
}

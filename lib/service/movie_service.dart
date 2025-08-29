import 'package:app_hs/http/api.dart';
import 'package:app_hs/http/mtls_http_client.dart';
import 'package:app_hs/log/logger.dart';
import 'package:app_hs/models/menu.dart';
import 'package:app_hs/models/movie.dart';
import 'package:app_hs/models/tag.dart';
import 'package:app_hs/service_locator.dart';

class MovieService {
  // 菜单列表
  static Future<List<Menu>> menuList() async {
    MtlsHttpClient client = getIt<MtlsHttpClient>();
    try {
      final resp = await client.post(
        Api.movieMenu,
        data: {},
      );
      List<Menu> menus = [];
      if (resp == null || resp.isFailure) {
        return menus;
      }
      if (resp.isSuccess) {
        final array = resp.data!['list'] as List;
        for (var item in array) {
          menus.add(Menu.fromJson(item));
        }
      }
      return menus;
    } catch (e) {
      logger.e("menuList: $e");
      return [];
    }
  }

  // 点击次数视频列表
  static Future<List<Movie>> moviePopularList(String categoryId) async {
    MtlsHttpClient client = getIt<MtlsHttpClient>();
    try {
      final resp = await client.post(
        "${Api.category}/$categoryId/popular",
        sign: true,
        data: {
          "pageIdx": 1,
          "pageCnt": 10,
        },
      );
      List<Movie> data = [];
      if (resp == null || resp.isFailure) {
        return data;
      }
      if (resp.isSuccess) {
        final array = resp.data!['list'] as List;
        for (var item in array) {
          data.add(Movie.fromJson(item));
        }
      }
      return data;
    } catch (e) {
      logger.e("moviePopular: $e");
      return [];
    }
  }

  // tags 分类
  static Future<List<Tag>> tags(String categoryId) async {
    MtlsHttpClient client = getIt<MtlsHttpClient>();
    try {
      final resp = await client.post(
        "${Api.category}/$categoryId/tag_list",
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

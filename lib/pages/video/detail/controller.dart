import 'dart:io';
import 'package:app_hs/utils/id_utils.dart';
import 'package:floating/floating.dart';
import 'package:app_hs/models/common/search_type.dart';
import 'package:app_hs/models/video/play/quality.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../../../utils/strorage.dart';

class VideoDetailController extends GetxController
    with GetSingleTickerProviderStateMixin {
  /// 路由传参
  String bvid = Get.parameters['bvid']!;
  RxInt cid = int.parse(Get.parameters['cid']!).obs;
  RxInt danmakuCid = 0.obs;
  String heroTag = Get.arguments['heroTag'];
  // 视频详情
  Map videoItem = {};
  // 视频类型 默认投稿视频
  SearchType videoType = Get.arguments['videoType'] ?? SearchType.video;

  /// tabs相关配置
  int tabInitialIndex = 0;
  late TabController tabCtr;
  RxList<String> tabs = <String>['简介', '评论'].obs;
  // 请求状态
  RxBool isLoading = false.obs;

  /// 播放器配置 画质 音质 解码格式
  late VideoQuality currentVideoQa;
  AudioQuality? currentAudioQa;
  late VideoDecodeFormats currentDecodeFormats;
  // 是否开始自动播放 存在多p的情况下，第二p需要为true
  RxBool autoPlay = true.obs;
  // 视频资源是否有效
  RxBool isEffective = true.obs;
  // 封面图的展示
  RxBool isShowCover = true.obs;
  // 硬解
  RxBool enableHA = true.obs;

  /// 本地存储
  Box userInfoCache = GStrorage.userInfo;
  Box localCache = GStrorage.localCache;
  Box setting = GStrorage.setting;
  
  RxInt oid = 0.obs;
  // 默认记录历史记录
  bool enableHeart = true;
  var userInfo;

  late bool isFirstTime = true;
  Floating? floating;

  late int? cacheVideoQa;
  late String cacheDecode;
  late int defaultAudioQa;

  late bool enableRelatedVideo;
  List subtitles = [];

  @override
  void onInit() {
    super.onInit();
    final Map argMap = Get.arguments;
    userInfo = userInfoCache.get('userInfoCache');
    var keys = argMap.keys.toList();
    if (keys.isNotEmpty) {
      if (keys.contains('videoItem')) {
        var args = argMap['videoItem'];
        if (args.pic != null && args.pic != '') {
          videoItem['pic'] = args.pic;
        }
      }
      if (keys.contains('pic')) {
        videoItem['pic'] = argMap['pic'];
      }
    }

    tabCtr = TabController(length: 2, vsync: this);
    autoPlay.value = setting.get(
      SettingBoxKey.autoPlayEnable,
      defaultValue: true,
    );
    enableHA.value = setting.get(SettingBoxKey.enableHA, defaultValue: true);
    enableRelatedVideo = setting.get(
      SettingBoxKey.enableRelatedVideo,
      defaultValue: true,
    );
    if (userInfo == null ||
        localCache.get(LocalCacheKey.historyPause) == true) {
      enableHeart = false;
    }
    danmakuCid.value = cid.value;

    if (Platform.isAndroid) {
      floating = Floating();
    }

    // 预设的画质
    cacheVideoQa = setting.get(SettingBoxKey.defaultVideoQa);
    // 预设的解码格式
    cacheDecode = setting.get(SettingBoxKey.defaultDecode,
        defaultValue: VideoDecodeFormats.values.last.code);
    defaultAudioQa = setting.get(SettingBoxKey.defaultAudioQa,
        defaultValue: AudioQuality.hiRes.code);
    oid.value = IdUtils.bv2av(Get.parameters['bvid']!);
    // 初始化字幕
    //getSubtitle();
  }
}

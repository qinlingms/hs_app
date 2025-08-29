import 'dart:async';

import 'package:app_hs/plugin/pl_player/models/play_status.dart';
import 'package:flutter/material.dart';

class VideoDetailPage extends StatefulWidget {
  const VideoDetailPage({super.key});

  @override
  State<VideoDetailPage> createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage>
  with TickerProviderStateMixin ,RouteAware{

    final ScrollController _extendNestCtr = ScrollController();
  late StreamController<double> appbarStream;
  // late VideoIntroController videoIntroController;
  // late BangumiIntroController bangumiIntroController;
  late String heroTag;
    PlayerStatus playerStatus = PlayerStatus.playing;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Container());
  }
}
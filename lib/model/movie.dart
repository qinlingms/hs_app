import 'package:app_hs/log/logger.dart';

class Movie {
  String id;
  String title;
  int likeCnt;
  int playCnt;
  List<String> logoUrl;
  String duration;
  String previewUrl;
  bool free;
  int ctime;

  Movie({
    required this.id,
    required this.title,
    required this.likeCnt,
    required this.playCnt,
    required this.logoUrl,
    required this.duration,
    required this.previewUrl,
    required this.free,
    required this.ctime,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    // logger.d("Movie.fromJson: $json");
    List<String> logoUrls = [];
    for (var item in json['logoUrl']) {
      logoUrls.add(item.toString());
    }
    return Movie(
      id: json['id'] as String,
      title: json['title'] as String,
      likeCnt: json['likeCnt'] as int,
      playCnt: json['playCnt'] as int,
      logoUrl: logoUrls,
      duration: json['duration'] as String,
      previewUrl: json['previewUrl'] as String,
      free: json['free'] as bool,
      ctime: json['ctime'] as int,
    );
  }
}

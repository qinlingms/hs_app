class Movie{
  String id;
  String title;
  int likeCnt;
  int playCnt;
  String logoUrl;
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
    return Movie(
      id: json['id'],
      title: json['title'],
      likeCnt: json['likeCnt'],
      playCnt: json['playCnt'],
      logoUrl: json['logoUrl'],
      duration: json['duration'],
      previewUrl: json['previewUrl'],
      free: json['free'],
      ctime: json['ctime'],
    );
  }
}
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
    List<String> logoUrls = [];
    for (var item in json['logoUrl']) {
      logoUrls.add(item.toString());
    }
    String previewUrl = json['previewUrl'] as String;
    previewUrl = "http://192.168.3.84:9010/encrypted/2025/08/29/4e479718244d969dcf7805604d76b0cf742646def8a3c8d5c929067b8f212bc2/1961099978506514432.png";
    return Movie(
      id: json['id'] as String,
      title: json['title'] as String,
      likeCnt: json['likeCnt'] as int,
      playCnt: json['playCnt'] as int,
      logoUrl: logoUrls,
      duration: json['duration'] as String,
      previewUrl: previewUrl,
      free: json['free'] as bool,
      ctime: json['ctime'] as int,
    );
  }
}

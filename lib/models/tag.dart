class Tag {
  String id;
  String display;
  Tag({required this.id, required this.display});
  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(id: json['id'], display: json['display']);
  }
}

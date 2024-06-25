class Video {
  Video({
    required this.id,
    required this.author,
    required this.title,
    required this.thumbnailUrl,
    required this.duration,
    required this.timestamp,
    required this.viewCount,
    required this.likes,
    required this.dislikes,
    required this.url,
  });
  late int id;
  late String author;
  late String title;
  late String thumbnailUrl;
  late String duration;
  late String timestamp;
  late String viewCount;
  late String likes;
  late String dislikes;
  late String url;

  Video.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    author = json['author'] ?? "";
    title = json['title'] ?? "";
    thumbnailUrl = json['thumbnailUrl'] ?? "";
    duration = json['duration'] ?? "";
    timestamp = json['timestamp'] ?? "";
    viewCount = json['viewCount'] ?? "";
    likes = json['likes'] ?? "";
    dislikes = json['dislikes'] ?? "";
    url = json['url'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['author'] = author;
    _data['title'] = title;
    _data['thumbnailUrl'] = thumbnailUrl;
    _data['duration'] = duration;
    _data['timestamp'] = timestamp;
    _data['viewCount'] = viewCount;
    _data['likes'] = likes;
    _data['dislikes'] = dislikes;
    _data['url'] = url;
    return _data;
  }
}

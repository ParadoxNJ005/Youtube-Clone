class ChatUser {
  ChatUser({
    required this.id,
    required this.createdAt,
    required this.name,
    required this.image,
    required this.email,
    required this.uid,
  });
  late int id;
  late String createdAt;
  late String name;
  late String image;
  late String email;
  late String uid;

  ChatUser.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    createdAt = json['created_at'] ?? '';
    name = json['name'] ?? '';
    image = json['image'] ?? '';
    email = json['email'] ?? '';
    uid = json['uid'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['created_at'] = createdAt;
    _data['name'] = name;
    _data['image'] = image;
    _data['email'] = email;
    _data['uid'] = uid;
    return _data;
  }
}

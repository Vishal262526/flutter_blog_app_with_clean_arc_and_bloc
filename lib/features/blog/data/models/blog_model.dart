import 'package:blog_app/features/blog/domain/entities/blog.dart';

class BlogModel extends Blog {
  BlogModel({
    required super.id,
    required super.userId,
    required super.title,
    required super.content,
    required super.imageUrl,
    super.name,
    required super.topics,
    required super.createdAt,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "title": title,
        "content": content,
        "image_url": imageUrl,
        "topics": topics,
        "created_at": createdAt.toIso8601String(),
      };

  factory BlogModel.fromJSON(Map<String, dynamic> json) {
    print(json);
    return BlogModel(
      id: json['id'] ?? "",
      userId: json['user_id'],
      name: json['users']['name'] ?? "",
      title: json['title'],
      content: json['content'],
      imageUrl: json['image_url'],
      topics: json['topics'],
      createdAt: json['created_at'] == null
          ? DateTime.now()
          : DateTime.parse(json['created_at']),
    );
  }

  BlogModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? content,
    String? username,
    String? imageUrl,
    List<String>? topics,
    DateTime? createdAt,
  }) =>
      BlogModel(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        name: username ?? this.userId,
        title: title ?? this.title,
        content: content ?? this.content,
        imageUrl: imageUrl ?? this.imageUrl,
        topics: topics ?? this.topics,
        createdAt: createdAt ?? this.createdAt,
      );
}

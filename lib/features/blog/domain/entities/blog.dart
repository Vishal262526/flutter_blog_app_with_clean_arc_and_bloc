class Blog {
  final String id;
  final String userId;
  final String? name;
  final String title;
  final String content;
  final String imageUrl;
  final List topics;
  final DateTime createdAt;

  Blog({
    required this.id,
    required this.userId,
    this.name,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.topics,
    required this.createdAt,
  });
}

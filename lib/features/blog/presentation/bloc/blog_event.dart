part of 'blog_bloc.dart';

@immutable
sealed class BlogEvent {}

final class BlogUpload extends BlogEvent {
  final File iamge;
  final String userId;
  final String title;
  final String content;
  final List<String> topics;

  BlogUpload({
    required this.iamge,
    required this.userId,
    required this.title,
    required this.content,
    required this.topics,
  });
}

final class BlogFetchBlogs extends BlogEvent {}

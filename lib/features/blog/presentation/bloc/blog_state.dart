part of 'blog_bloc.dart';

@immutable
sealed class BlogState {}

final class BlogInitial extends BlogState {}

final class BlogLoading extends BlogState {}

final class BlogFetchSuccess extends BlogState {
  final List<Blog> blogList;

  BlogFetchSuccess({required this.blogList});
}

final class BlogUploadSuccess extends BlogState {}

final class BlogFailure extends BlogState {
  final String errorMessage;

  BlogFailure({required this.errorMessage});
}

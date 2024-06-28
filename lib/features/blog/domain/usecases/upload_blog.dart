import 'dart:io';

import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class UploadBlog implements UseCase<Blog, UploadBlogParams> {
  final BlogRepository blogRepository;

  UploadBlog({required this.blogRepository});

  @override
  Future<Either<Failure, Blog>> call(UploadBlogParams params) {
    return blogRepository.uploadBlog(
      image: params.iamge,
      userId: params.userId,
      title: params.title,
      content: params.content,
      topics: params.topics,
    );
  }
}

class UploadBlogParams {
  final File iamge;
  final String userId;
  final String title;
  final String content;
  final List<String> topics;

  UploadBlogParams({
    required this.iamge,
    required this.userId,
    required this.title,
    required this.content,
    required this.topics,
  });
}

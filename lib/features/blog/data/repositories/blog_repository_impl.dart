import 'dart:io';

import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/error/server_exception.dart';
import 'package:blog_app/features/blog/data/datasources/blog_remote_data_source.dart';
import 'package:blog_app/features/blog/data/models/blog_model.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

class BlogRepositoryImpl implements BlogRepository {
  final BlogRemoteDataSource blogRemoteDataSource;

  BlogRepositoryImpl({required this.blogRemoteDataSource});

  @override
  Future<Either<Failure, Blog>> uploadBlog({
    required File image,
    required String userId,
    required String title,
    required String content,
    required List<String> topics,
  }) async {
    try {
      // Create a blog model
      final BlogModel blogModel = BlogModel(
        id: const Uuid().v1(),
        userId: userId,
        title: title,
        content: content,
        imageUrl: "",
        topics: topics,
        createdAt: DateTime.now(),
      );

      // Upload the image and the get url
      final imageUrl = await blogRemoteDataSource.uploadBlogImage(
        image: image,
        blog: blogModel,
      );

      // set the image url to the blog model
      final blog = blogModel.copyWith(imageUrl: imageUrl);

      // upload the whole blog with image url in the database (server)
      final uploadedBlog = await blogRemoteDataSource.uploadBlog(blog: blog);

      // return success
      return right(uploadedBlog);
    } on ServerException catch (e) {
      return left(Failure(errorMessage: e.errorMessage));
    }
  }

  @override
  Future<Either<Failure, List<Blog>>> getAllBlogs() async {
    try {
      final blogs = await blogRemoteDataSource.getAllBlogs();

      return right(blogs);
    } on ServerException catch (e) {
      return left(Failure(errorMessage: e.errorMessage));
    }
  }
}

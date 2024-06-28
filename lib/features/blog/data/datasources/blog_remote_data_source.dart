import 'dart:io';

import 'package:blog_app/core/error/server_exception.dart';
import 'package:blog_app/features/blog/data/models/blog_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class BlogRemoteDataSource {
  Future<BlogModel> uploadBlog({required BlogModel blog});
  Future<String?> uploadBlogImage({
    required File image,
    required BlogModel blog,
  });

  Future<List<BlogModel>> getAllBlogs();
}

class BlogRemoteDataSourceImpl extends BlogRemoteDataSource {
  final SupabaseClient supabaseClient;

  BlogRemoteDataSourceImpl({required this.supabaseClient});
  @override
  Future<BlogModel> uploadBlog({required BlogModel blog}) async {
    try {
      final blogData =
          await supabaseClient.from("blogs").insert(blog.toJson()).select();

      print("Blog Uploading is working ....");

      return BlogModel.fromJSON(blogData.first);
    } catch (e) {
      throw ServerException(errorMessage: e.toString());
    }
  }

  @override
  Future<String?> uploadBlogImage({
    required File image,
    required BlogModel blog,
  }) async {
    try {
      await supabaseClient.storage.from("blog_images").upload(blog.id, image);

      return supabaseClient.storage.from("blog_images").getPublicUrl(blog.id);
    } catch (e) {
      throw ServerException(errorMessage: e.toString());
    }
  }

  @override
  Future<List<BlogModel>> getAllBlogs() async {
    try {
      final blogList =
          await supabaseClient.from("blogs").select("*, users (name)");

      return blogList.map((blog) => BlogModel.fromJSON(blog)).toList();
    } catch (e) {
      throw ServerException(errorMessage: e.toString());
    }
  }
}

import 'dart:io';

import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/usecases/get_all_blogs.dart';
import 'package:blog_app/features/blog/domain/usecases/upload_blog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog _uploadBlog;
  final GetAllBlogs _getAllBlogs;

  BlogBloc({
    required UploadBlog uploadBlog,
    required GetAllBlogs getAllBlogs,
  })  : _uploadBlog = uploadBlog,
        _getAllBlogs = getAllBlogs,
        super(BlogInitial()) {
    on<BlogEvent>((event, emit) => emit(BlogLoading()));
    on<BlogUpload>(_onBlogUpload);
    on<BlogFetchBlogs>(_onGetAllBlogs);
  }

  void _onBlogUpload(BlogUpload event, Emitter<BlogState> emit) async {
    final res = await _uploadBlog(UploadBlogParams(
      iamge: event.iamge,
      userId: event.userId,
      title: event.title,
      content: event.content,
      topics: event.topics,
    ));

    res.fold((failure) {
      emit(BlogFailure(errorMessage: failure.errorMessage));
    }, (blog) {
      emit(BlogUploadSuccess());
    });
  }

  void _onGetAllBlogs(BlogFetchBlogs event, Emitter<BlogState> emit) async {
    final res = await _getAllBlogs(NoParams());

    res.fold(
      (failure) {
        emit(BlogFailure(errorMessage: failure.errorMessage));
      },
      (blogList) {
        emit(BlogFetchSuccess(blogList: blogList));
      },
    );
  }
}
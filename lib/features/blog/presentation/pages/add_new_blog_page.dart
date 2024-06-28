import 'dart:io';

import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/core/theme/app_pallate.dart';
import 'package:blog_app/core/utils/app_utils.dart';
import 'package:blog_app/core/utils/image_pciker.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/pages/blog_page.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_field.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

final categoryList = ["Technology", "Business", "Programming", "Entertainment"];

class AddNewBlogPage extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const AddNewBlogPage());

  const AddNewBlogPage({super.key});

  @override
  State<AddNewBlogPage> createState() => _AddNewBlogPageState();
}

class _AddNewBlogPageState extends State<AddNewBlogPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  File? image;
  final topics = <String>[];

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
  }

  void _selectImage() async {
    final picked = await pcikImage(ImageSource.gallery);
    if (picked != null) {
      setState(() {
        image = picked;
      });
    }
  }

  void _uploadBlog() {
    if (_formKey.currentState!.validate() &&
        image != null &&
        topics.isNotEmpty) {
      final userId =
          (context.read<AppUserCubit>().state as AppUserLoggedIn).user.uid;

      context.read<BlogBloc>().add(BlogUpload(
            iamge: image!,
            userId: userId!,
            title: _titleController.text.trim(),
            content: _descriptionController.text.trim(),
            topics: topics,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BlogBloc, BlogState>(
      listener: (context, state) {
        if (state is BlogUploadSuccess) {
          Navigator.pushAndRemoveUntil(
              context, BlogPage.route(), (context) => false);
        }

        if (state is BlogFailure) {
          AppUtils.showSnackBar(context, state.errorMessage);
        }
      },
      builder: (context, state) {
        if (state is BlogLoading) {
          return const Loader();
        }
        return Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                onPressed: _uploadBlog,
                icon: const Icon(Icons.done_rounded),
              ),
            ],
          ),
          body: BlocConsumer<BlogBloc, BlogState>(
            listener: (context, state) {
              if (state is BlogFailure) {
                AppUtils.showSnackBar(context, state.errorMessage);
              }

              if (state is BlogUpload) {
                Navigator.pop(context);
              }
            },
            builder: (context, state) {
              if (state is BlogLoading) {
                return const Loader();
              }
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: _selectImage,
                          child: DottedBorder(
                            color: AppPallete.borderColor,
                            radius: const Radius.circular(12.0),
                            borderType: BorderType.RRect,
                            dashPattern: const [10, 4],
                            strokeCap: StrokeCap.round,
                            child: Container(
                              height: 150,
                              width: double.infinity,
                              child: image != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(12.0),
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          Image.file(
                                            image!,
                                            fit: BoxFit.cover,
                                          ),
                                          Positioned(
                                            top: 0,
                                            right: 0,
                                            child: IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  image = null;
                                                });
                                              },
                                              icon: const Icon(
                                                Icons.close,
                                                size: 30,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  : const Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.folder_open,
                                          size: 40,
                                        ),
                                        SizedBox(
                                          height: 16,
                                        ),
                                        Text(
                                          "Select an Image",
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: categoryList
                                .map(
                                  (e) => Padding(
                                    padding: const EdgeInsets.only(right: 6),
                                    child: GestureDetector(
                                      onTap: () {
                                        if (topics.contains(e)) {
                                          setState(() {
                                            topics.remove(e);
                                          });
                                        } else {
                                          setState(() {
                                            topics.add(e);
                                          });
                                        }
                                      },
                                      child: Chip(
                                        color: MaterialStatePropertyAll(
                                            topics.contains(e)
                                                ? AppPallete.gradient2
                                                : AppPallete.transparentColor),
                                        side: topics.contains(e)
                                            ? null
                                            : const BorderSide(
                                                color: AppPallete.borderColor),
                                        label: Text(
                                          e,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        BlogField(
                            controller: _titleController,
                            hintText: "Blog Title"),
                        const SizedBox(
                          height: 20,
                        ),
                        BlogField(
                            controller: _descriptionController,
                            hintText: "Blog Description,"),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

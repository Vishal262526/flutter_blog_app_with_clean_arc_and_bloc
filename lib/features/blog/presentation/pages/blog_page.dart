import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/core/theme/app_pallate.dart';
import 'package:blog_app/core/utils/app_utils.dart';
import 'package:blog_app/features/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/pages/add_new_blog_page.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlogPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const BlogPage());

  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  @override
  void initState() {
    // TODO: implement initState
    context.read<BlogBloc>().add(BlogFetchBlogs());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Blogs"),
        actions: [
          IconButton(
            onPressed: () {
              context.read<AuthBloc>().add(AuthUserSignOut());
            },
            icon: Icon(Icons.logout_outlined),
          ),
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            AppUtils.showSnackBar(context, state.errorMessage);
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return const Loader();
          }

          if (state is BlogFetchSuccess) {
            return Container(
              child: ListView.builder(
                itemCount: state.blogList.length,
                itemBuilder: (context, index) {
                  final blog = state.blogList[index];

                  return BlogCard(
                    blog: blog,
                    color: index % 3 == 0
                        ? AppPallete.gradient1
                        : index % 3 == 1
                            ? AppPallete.gradient2
                            : AppPallete.gradient3,
                  );
                },
              ),
            );
          }
          return Container(
            padding: const EdgeInsets.all(16.0),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context, AddNewBlogPage.route());
        },
        icon: const Icon(CupertinoIcons.add_circled),
        label: const Text("Add New"),
      ),
    );
  }
}

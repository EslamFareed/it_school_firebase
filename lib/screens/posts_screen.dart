import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:it_school_firebase/cubits/posts/posts_cubit.dart';
import 'package:it_school_firebase/screens/create_post_screen.dart';
import 'package:it_school_firebase/screens/details_post_screen.dart';

class PostsScreen extends StatelessWidget {
  const PostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    PostsCubit.get(context).getPostsStream();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreatePostScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: BlocConsumer<PostsCubit, PostsState>(
        listener: (context, state) {},
        builder: (context, state) {
          return state is LoadingGetPostsState
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailsPostScreen(
                                    item: PostsCubit.get(context).posts[index]),
                              ));
                        },
                        title:
                            Text(PostsCubit.get(context).posts[index].title!),
                        subtitle:
                            Text(PostsCubit.get(context).posts[index].body!),
                      ),
                    );
                  },
                  itemCount: PostsCubit.get(context).posts.length,
                );
        },
      ),
    );
  }
}

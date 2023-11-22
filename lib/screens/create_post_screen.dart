import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:it_school_firebase/cubits/posts/posts_cubit.dart';
import 'package:it_school_firebase/models/post_model.dart';

class CreatePostScreen extends StatelessWidget {
  CreatePostScreen({super.key});

  final titleController = TextEditingController();
  final bodyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create New Post"),
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: titleController,
                minLines: 1,
                maxLines: 1,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Title",
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: bodyController,
                minLines: 10,
                maxLines: 10,
                textAlign: TextAlign.left,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Body",
                ),
              ),
              BlocConsumer<PostsCubit, PostsState>(
                listener: (context, state) {
                  if (state is SuccessCreatePostState) {
                    Navigator.pop(context);
                  } else if (state is ErrorCreatePostState) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content:
                            Text("Error in Create Post,Please try again")));
                  }
                },
                builder: (context, state) {
                  if (state is LoadingCreatePostState) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return ElevatedButton(
                      onPressed: () {
                        PostsCubit.get(context).createPost(PostModel(
                          title: titleController.text,
                          body: bodyController.text,
                        ));
                      },
                      child: const Text("Create Post"),
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:it_school_firebase/cubits/posts/posts_cubit.dart';
import 'package:it_school_firebase/models/post_model.dart';

class DetailsPostScreen extends StatelessWidget {
  DetailsPostScreen({super.key, required this.item});
  PostModel item;

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController(text: item.title);
    final bodyController = TextEditingController(text: item.body);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Post"),
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(item.id!),
              TextFormField(
                controller: titleController,
                minLines: 1,
                maxLines: 1,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Title",
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
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
                  if (state is SuccessEditPostState) {
                    Navigator.pop(context);
                  }
                },
                builder: (context, state) {
                  return state is LoadingEditPostState
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: () {
                            item.title = titleController.text;
                            item.body = bodyController.text;
                            PostsCubit.get(context).editPost(item);
                          },
                          child: const Text("Edit Post"),
                        );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

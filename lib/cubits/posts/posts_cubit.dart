import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../models/post_model.dart';

part 'posts_state.dart';

class PostsCubit extends Cubit<PostsState> {
  PostsCubit() : super(PostsInitial());

  static PostsCubit get(context) => BlocProvider.of(context);

  FirebaseFirestore db = FirebaseFirestore.instance;

  FirebaseStorage storage = FirebaseStorage.instance;

  uploadFile() {
    storage.ref("Images").putFile(File("path")).then((p0) {
      if (p0.state == TaskState.success) {
        print("Finished");
      } else {
        print("error");
      }
    });
  }

  void createPost(PostModel post) {
    emit(LoadingCreatePostState());
    db.collection("posts").add(post.toJson()).then((value) {
      emit(SuccessCreatePostState());
    }).catchError((error) {
      print(error.toString());
      emit(ErrorCreatePostState());
    });
  }

  List<PostModel> posts = [];

  void deletePost(PostModel item) {
    db.collection("posts").doc(item.id).delete();
  }

  // void getPostsOnce() {
  //   emit(LoadingGetPostsState());
  //   posts = [];
  //   db.collection("posts").get().then((value) {
  // for (var element in value.docs) {
  //   posts.add(PostModel.fromJson(element.data()));
  // }
  //     emit(SuccessGetPostsState());
  //   }).catchError((error) {
  //     print(error.toString());
  //     emit(ErrorGetPostsState());
  //   });
  // }

  void getPostsStream() {
    emit(LoadingGetPostsState());

    db.collection("posts").snapshots().listen((event) {
      posts = [];
      for (var element in event.docs) {
        posts.add(
          PostModel.fromJson(
            element.data(),
            element.id,
          ),
        );
      }

      emit(SuccessGetPostsState());
    }).onError((error) {
      print(error.toString());
      emit(ErrorGetPostsState());
    });
  }

  void editPost(PostModel item) async {
    emit(LoadingEditPostState());
    try {
      await db.collection("posts").doc(item.id).set(item.toJson());
      emit(SuccessEditPostState());
    } catch (e) {
      print(e.toString());
      emit(ErrorEditPostState());
    }
  }
}

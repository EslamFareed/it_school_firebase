part of 'posts_cubit.dart';

@immutable
sealed class PostsState {}

final class PostsInitial extends PostsState {}

//! -----------------------------------------------------------------

class LoadingCreatePostState extends PostsState {}

class SuccessCreatePostState extends PostsState {}

class ErrorCreatePostState extends PostsState {}

//! -----------------------------------------------------------------

class LoadingGetPostsState extends PostsState {}

class SuccessGetPostsState extends PostsState {}

class ErrorGetPostsState extends PostsState {}

//! -----------------------------------------------------------------

class LoadingEditPostState extends PostsState {}

class SuccessEditPostState extends PostsState {}

class ErrorEditPostState extends PostsState {}

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_interview_task/models/post_model.dart';
import 'package:flutter_interview_task/services/local_storage_service/sqflite_local_service.dart';
import 'package:flutter_interview_task/services/network_service/api_functions.dart';
import 'package:flutter_interview_task/services/network_service/server_apis.dart';
import 'package:flutter_interview_task/src/post_details/post_details_screen.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeLoading()) {
    on<GetAllPosts>(_onGetAllPosts);
    on<MarkAsRead>(_onMarkAsRead);
  }

  Future<void> _onGetAllPosts(GetAllPosts event, Emitter<HomeState> emit) async {
    emit(HomeLoading());

    await httpGetRequest(url: getAllPosts).then((response) async {
      if (response.statusCode == 200) {
        final List<PostModel> postList = postModelFromJson(response.body);
        await _addNewPostsToLocalDatabase(postList);

        emit(HomeInitial(postList: postList));
      }
    });
  }

  Future<List<PostModel>> _getPostsFromLocalStorage() async {
    final posts = await LocalStorage.getPosts();
    return posts.map((post) => PostModel.fromJson(post)).toList();
  }

  Future<void> _addNewPostsToLocalDatabase(List<PostModel> postList) async {
    for (PostModel post in postList) {
      final existingPost = await LocalStorage.getPostByPostId(post.id ?? 0);
      if (existingPost == null) {
        await LocalStorage.insertPost(post.userId, post.id, post.title, post.body);
      }
    }
  }

  void _onMarkAsRead(MarkAsRead event, Emitter<HomeState> emit) async {
    final currentState = state;
    if (currentState is HomeInitial) {
      final updatedPosts = currentState.postList?.map((post) {
        if (post.id == event.postId) {
          return post.copyWith(isUnread: false);
        }
        return post;
      }).toList();

      emit(HomeInitial(postList: updatedPosts));
      Navigator.push(
        event.context,
        MaterialPageRoute(
          builder: (context) => PostDetailsScreen(id: event.postId.toString()),
        ),
      );
    }
  }
}

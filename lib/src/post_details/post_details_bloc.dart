import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_interview_task/models/post_model.dart';
import 'package:flutter_interview_task/services/network_service/api_functions.dart';
import 'package:flutter_interview_task/services/network_service/server_apis.dart';

part 'post_details_event.dart';
part 'post_details_state.dart';

class PostDetailsBloc extends Bloc<PostDetailsEvent, PostDetailsState> {
  PostDetailsBloc() : super(PostDetailsLoading()) {
    on<GetPostDetails>(_onGetPostDetails);
  }

  Future<void> _onGetPostDetails(GetPostDetails event, Emitter<PostDetailsState> emit) async {
    emit(PostDetailsLoading());
    await httpGetRequest(url: getPostDetails + event.postId).then(
      (response) {
        if (response.statusCode == 200) {
          PostModel postDetails = PostModel.fromJson(jsonDecode(response.body));
          emit(PostDetailsInitial(postDetails: postDetails));
        }
      },
    );
  }
}

part of 'post_details_bloc.dart';

abstract class PostDetailsState extends Equatable {
  const PostDetailsState();
}

class PostDetailsLoading extends PostDetailsState {
  @override
  List<Object?> get props => [];
}

class PostDetailsInitial extends PostDetailsState {
  final PostModel? postDetails;

  const PostDetailsInitial({this.postDetails});

  PostDetailsInitial copyWith({PostModel? postDetails}) {
    return PostDetailsInitial(postDetails: postDetails ?? this.postDetails);
  }

  @override
  List<Object?> get props => [postDetails];
}

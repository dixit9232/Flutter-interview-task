part of 'post_details_bloc.dart';

abstract class PostDetailsEvent extends Equatable {
  const PostDetailsEvent();
}

class GetPostDetails extends PostDetailsEvent {
  final String postId;

  const GetPostDetails({required this.postId});

  @override
  List<Object?> get props => [];
}

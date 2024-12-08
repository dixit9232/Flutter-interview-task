part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
}

class GetAllPosts extends HomeEvent {
  @override
  List<Object?> get props => [];
}

class MarkAsRead extends HomeEvent {
  final int postId;
  final BuildContext context;

  const MarkAsRead({
    required this.postId,
    required this.context,
  });

  @override
  List<Object?> get props => [postId, context];
}

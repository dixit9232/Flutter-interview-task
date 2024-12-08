part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();
}

class HomeInitial extends HomeState {
  final List<PostModel>? postList;

  const HomeInitial({
    this.postList,
  });

  HomeInitial copyWith({
    List<PostModel>? postList,
  }) {
    return HomeInitial(
      postList: postList ?? this.postList,
    );
  }

  @override
  List<Object?> get props => [postList];
}

class HomeLoading extends HomeState {
  @override
  List<Object?> get props => [];
}

class HomeError extends HomeState {
  @override
  List<Object?> get props => [];
}

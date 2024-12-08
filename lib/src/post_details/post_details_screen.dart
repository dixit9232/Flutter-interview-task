import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_interview_task/src/post_details/post_details_bloc.dart';
import 'package:flutter_interview_task/widgets/loading_widget.dart';

import '../../utils/text_style.dart';

class PostDetailsScreen extends StatelessWidget {
  final String id;

  const PostDetailsScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PostDetailsBloc>(
      create: (context) => PostDetailsBloc()..add(GetPostDetails(postId: id)),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: const Icon(Icons.arrow_back, size: 20)),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Post's Details",
                      style: AppTextStyles.headlineMedium,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                BlocBuilder<PostDetailsBloc, PostDetailsState>(
                  builder: (context, state) {
                    if (state is PostDetailsLoading) {
                      return const Expanded(child: LoadingWidget());
                    } else if (state is PostDetailsInitial) {
                      final post = state.postDetails!;
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Title: ${post.title}",
                            style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          RichText(text: TextSpan(style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500), children: [const TextSpan(text: "Details: "), TextSpan(style: AppTextStyles.bodyMedium, text: post.body)]))
                        ],
                      );
                    } else {
                      return Expanded(
                        child: Center(
                          child: Text(
                            "No Post's Details Found",
                            style: AppTextStyles.bodyLarge,
                          ),
                        ),
                      );
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

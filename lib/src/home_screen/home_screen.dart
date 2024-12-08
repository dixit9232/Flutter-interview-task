import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_interview_task/src/home_screen/home_bloc.dart';
import 'package:flutter_interview_task/utils/color.dart';
import 'package:flutter_interview_task/utils/text_style.dart';
import 'package:flutter_interview_task/widgets/loading_widget.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../models/post_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<int> _randomTimes = [];

  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(GetAllPosts());
  }

  void _generateRandomTimes(int itemCount) {
    final random = Random();
    _randomTimes = List.generate(itemCount, (_) => random.nextInt(61));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Flutter Interview Task",
                style: AppTextStyles.headlineMedium,
              ),
              const SizedBox(height: 10),
              BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
                if (state is HomeLoading) {
                  return const Expanded(child: LoadingWidget());
                } else if (state is HomeInitial) {
                  _generateRandomTimes(state.postList?.length ?? 0);
                  return Expanded(
                    child: state.postList?.isNotEmpty ?? false
                        ? ListView.builder(
                            itemCount: state.postList?.length ?? 0,
                            itemBuilder: (context, index) {
                              final postData = state.postList![index];
                              return TimerListItem(
                                postData: postData,
                                index: index,
                                remainingTime: _randomTimes[index],
                              );
                            },
                          )
                        : Center(
                            child: Text(
                              "No Posts Data",
                              style: AppTextStyles.bodyLarge,
                            ),
                          ),
                  );
                } else {
                  return Expanded(
                    child: Center(
                      child: Text(
                        "No Posts Data",
                        style: AppTextStyles.bodyLarge,
                      ),
                    ),
                  );
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class TimerListItem extends StatefulWidget {
  final PostModel postData;
  final int index;
  final int remainingTime;

  const TimerListItem({
    required this.postData,
    required this.index,
    required this.remainingTime,
    Key? key,
  }) : super(key: key);

  @override
  State<TimerListItem> createState() => _TimerListItemState();
}

class _TimerListItemState extends State<TimerListItem> {
  late Timer timer;
  late int currentTime;
  bool isVisible = true;

  @override
  void initState() {
    super.initState();
    currentTime = widget.remainingTime;
    _startTimer();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (isVisible && currentTime > 0) {
        setState(() {
          currentTime--;
        });
      }
      if (currentTime == 0) {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('post_${widget.postData.id}'),
      onVisibilityChanged: (visibilityInfo) {
        setState(() {
          isVisible = visibilityInfo.visibleFraction > 0;
        });
      },
      child: Card(
        elevation: 0.5,
        color: widget.postData.isUnread ? unreadColor : readColor,
        child: ListTile(
          splashColor: textColor.withOpacity(0.2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          onTap: () {
            context.read<HomeBloc>().add(MarkAsRead(
                  postId: widget.postData.id ?? 0,
                  context: context,
                ));
          },
          title: Text(
            widget.postData.title ?? "",
            style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.watch_later_outlined, size: 15),
              const SizedBox(width: 5),
              Text(
                "$currentTime sec",
                style: AppTextStyles.subtitleSmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

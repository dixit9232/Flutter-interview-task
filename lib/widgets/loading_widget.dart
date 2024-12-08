import 'package:flutter/material.dart';

import '../utils/color.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: textColor,
      ),
    );
  }
}

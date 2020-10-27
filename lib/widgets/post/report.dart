import 'package:flutter/material.dart';
import 'package:longlive/models/post.dart';

class ReportButtonWidget extends StatelessWidget {
  final PostInfo info;

  const ReportButtonWidget(this.info);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.report,
        color: Colors.red,
      ),
      tooltip: '신고하기',
      onPressed: () {},
    );
  }
}

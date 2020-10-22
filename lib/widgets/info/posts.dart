import 'package:flutter/material.dart';
import 'package:longlive/widgets/info/base.dart';
import 'package:longlive/widgets/post/board.dart';

/// ## 내 게시글 확인 기능
class MyPostsInfo implements UserInfo {
  String get label => '내 게시글 확인';

  Future<void> onPressed(BuildContext context) async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => PostBoardWidget(
          PostBoardController(),
        ),
      ),
    );
  }
}

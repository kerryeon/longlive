import 'package:flutter/material.dart';
import 'package:longlive/widgets/content/base.dart';
import 'package:longlive/widgets/post/board.dart';

/// ## 리더보드 컨텐츠
/// ### 생김새
/// - 중앙
///   - 게시글 목록
/// - 하단
///   - 등록 버튼
///
/// ### 기능
/// - 탭을 눌러 컨텐츠 전환
class LeaderBoardWidget extends StatefulWidget implements ContentWidget {
  Icon get icon => Icon(Icons.leaderboard);
  String get label => '리더보드';

  @override
  State createState() => _State();
}

class _State extends State {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 중앙에 배치
      body: PostBoardWidget(date: true),
      // 등록 버튼
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.post_add),
        onPressed: () {},
      ),
    );
  }
}

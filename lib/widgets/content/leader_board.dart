import 'package:flutter/material.dart';
import 'package:longlive/models/post.dart';
import 'package:longlive/models/user.dart';
import 'package:longlive/widgets/content/base.dart';
import 'package:longlive/widgets/post/board.dart';
import 'package:longlive/widgets/post/create.dart';
import 'package:unicorndial/unicorndial.dart';

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
  final PostBoardController _controller = PostBoardController(date: true);

  @override
  void initState() {
    super.initState();

    // 임의의 카테고리 지정
    final user = User.getInstance();
    if (user.habits.isNotEmpty) {
      _controller.category = (user.habits.toList()..shuffle()).first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 중앙에 배치
      body: PostBoardWidget(
        _controller,
        'posts/all',
        onCategoryUpdate: () => setState(() {}),
      ),
      // 등록 버튼
      floatingActionButton: Visibility(
        visible: _controller.category != null,
        child: UnicornDialer(
          parentButton: Icon(Icons.post_add),
          childButtons: [
            UnicornButton(
              hasLabel: true,
              labelText: '등록하기',
              currentButton: FloatingActionButton(
                child: Icon(Icons.send),
                onPressed: _moveToCreatePage,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _moveToCreatePage() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute<bool>(
        builder: (BuildContext context) => PostCreateWidget(_controller),
      ),
    );

    if (result == true) {
      await _controller.reload(PostQueryOrder.Latest);
    }
  }
}

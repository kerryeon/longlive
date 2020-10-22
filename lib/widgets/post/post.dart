import 'package:flutter/material.dart';
import 'package:longlive/models/post.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

/// ## 게시글 위젯
/// ### 생김새
/// - 상단
///   - 게시글 제목
/// - 중앙
///   - 이미지 목록: 가로로 스크롤
///   - 글
///   - 해시태그
///   - (우측) 신고 버튼, 찜 버튼
/// - 하단: 작성자의 다른 글 목록
class PostWidget extends StatefulWidget {
  final PostInfo info;
  final List<PostInfo> relatives;

  const PostWidget(this.info, this.relatives);

  @override
  State createState() => _State(info, relatives);
}

class _State extends State {
  final PostInfo info;
  final List<PostInfo> relatives;

  _State(this.info, this.relatives);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // 게시글 제목
        title: Text(info.title),
      ),
      // 중앙에 배치
      body: Center(
        child: ListView(
          children: [
            // 설명
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
              child: Text(info.desc),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:longlive/widgets/content/base.dart';
import 'package:longlive/widgets/post/board.dart';

/// ## 찜 목록 컨텐츠
/// ### 생김새
/// - 게시글 목록
/// - 날짜 표기, 등록 버튼 생략
///
/// ### 기능
/// - 생략
class FavoritesWidget extends StatefulWidget implements ContentWidget {
  Icon get icon => Icon(Icons.favorite);
  String get label => '찜 목록';

  @override
  State createState() => _State();
}

class _State extends State {
  @override
  Widget build(BuildContext context) {
    return PostBoardWidget(
      date: false,
      sort: true,
    );
  }
}

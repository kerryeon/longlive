import 'package:flutter/material.dart';
import 'package:hashtagable/hashtagable.dart';
import 'package:longlive/models/post.dart';
import 'package:longlive/widgets/image/carousel.dart';
import 'package:longlive/widgets/post/board.dart';

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
            CarouselToolWidget(CarouselToolController(
              images: info.images.map((e) => NetworkImage(e)).toList(),
            )),
            // 설명
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 18, 12, 24),
              child: Text(info.desc),
            ),
            Stack(
              alignment: Alignment.bottomLeft,
              children: [
                // 해시태그
                Container(
                  width: 280,
                  padding: const EdgeInsets.only(left: 12),
                  child: HashTagText(
                    text: info.tags.map((e) => '#$e').join(' '),
                    basicStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                    decoratedStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.blue,
                    ),
                    decorateAtSign: true,
                    onTap: (x) => print(x),
                  ),
                ),
                // 신고 버튼 / 찜 버튼
                ButtonBar(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.report,
                        color: Colors.red,
                      ),
                      tooltip: '신고하기',
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.favorite,
                        color: Colors.pink,
                      ),
                      tooltip: '찜하기',
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
            // 작성자의 다른 글 목록
            Padding(
              padding: const EdgeInsets.fromLTRB(36, 60, 0, 0),
              child: Text(
                '작성자의 다른 글 보기',
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            PostBoardContentsWidget(relatives, primary: false),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hashtagable/hashtagable.dart';
import 'package:longlive/models/post.dart';
import 'package:carousel_slider/carousel_slider.dart';
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

  int _currentIndex = 0;

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
            // 이미지 목록
            CarouselSlider(
              options: CarouselOptions(
                enableInfiniteScroll: false,
                enlargeCenterPage: true,
                onPageChanged: (index, reason) {
                  setState(() => _currentIndex = index);
                },
              ),
              items: info.images.map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return Image.network(i);
                  },
                );
              }).toList(),
            ),
            // Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                info.images.length,
                (index) => Container(
                  width: 8.0,
                  height: 8.0,
                  margin: EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 2.0,
                  ),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentIndex == index
                        ? Color.fromRGBO(0, 0, 0, 0.9)
                        : Color.fromRGBO(0, 0, 0, 0.4),
                  ),
                ),
              ).toList(),
            ),
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
                      color: Colors.blue,
                    ),
                    decoratedStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ),
                // 신고 버튼 / 찜 버튼
                ButtonBar(
                  children: [
                    IconButton(
                      icon: Icon(Icons.report),
                      tooltip: '신고하기',
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(Icons.favorite),
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

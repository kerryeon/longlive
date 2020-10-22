import 'package:flutter/material.dart';

/// ## 게시글 목록 위젯
/// ### 생김새
/// - 상단
///   - (좌) 카테고리 선택 버튼
///   - 카테고리 이름
///   - (우) 검색 버튼
/// - 중앙
///   - (좌) 날짜 (xxxx년 xx월)
///   - (우) 정렬 (인기순 / 최신순)
/// - 하단
///   - 게시글 목록
///
/// ### 기능
/// - 탭을 눌러 컨텐츠 전환
class PostBoardWidget extends StatefulWidget {
  /// 날짜 표시
  final bool date;

  /// 정렬 기능
  final bool sort;

  const PostBoardWidget({
    this.date = false,
    this.sort = false,
  });

  @override
  State createState() {
    return _State(
      date: date,
      sort: sort,
    );
  }
}

class _State extends State {
  final bool date;
  final bool sort;

  _State({
    this.date,
    this.sort,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // 카테고리 버튼
        leading: IconButton(
          icon: Icon(Icons.list),
          onPressed: () {},
        ),
        // 카테고리
        title: Text('비만'),
        // 검색 버튼
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      // 중앙에 배치
      body: Center(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.centerLeft,
              children: [
                // 날짜
                Visibility(
                  visible: date,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 0, 12),
                    child: Text(
                      '2020년 10월',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                ),
                // 정렬
                Visibility(
                  visible: sort,
                  child: ButtonBar(
                    alignment:
                        date ? MainAxisAlignment.end : MainAxisAlignment.center,
                    children: [
                      FlatButton(
                        child: const Text('인기순'),
                        onPressed: () {},
                      ),
                      FlatButton(
                        child: const Text('최신순'),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // 게시글 목록
            GridView.count(
              shrinkWrap: true,
              padding: const EdgeInsets.all(16),
              crossAxisCount: 2,
              childAspectRatio: 6.0 / 9.0,
              children: [
                Card(
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 썸네일
                      AspectRatio(
                        aspectRatio: 17 / 16,
                        child: Image.network(
                          'http://image.fomos.kr/contents/images/board/2019/1103/1572743242649190.jpg',
                          fit: BoxFit.fill,
                        ),
                      ),
                      // 제목
                      Container(
                        padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                        child: Text(
                          '가을 다이어트 "이것"이 최고!',
                          style: Theme.of(context).textTheme.subtitle2,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // 찜 버튼
                      Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Icon(Icons.favorite),
                              onPressed: () {},
                            ),
                            Text('3,026'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

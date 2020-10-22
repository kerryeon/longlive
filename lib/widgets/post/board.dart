import 'package:flutter/material.dart';
import 'package:longlive/models/post.dart';
import 'package:longlive/widgets/post/post.dart';

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
    this.sort = true,
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

  List<PostInfo> infos = [
    PostInfo(
      title: '가을 다이어트 "이것"이 최고!',
      desc: '''가을 다이어트에는 무엇이 좋을까?
          
안녕하세요, 호야TV입니다.
이번에는 가을에 다이어트에는 무엇이 좋을지에 대해 알아봅시다~!

바로, 야식 끊고 운동하는 방법이 전문가들이 추천하는 가장 좋은 가을 다이어트 방법이라고 합니다!

도움이 되셨다면 아래의 ❤️를 눌러주세요~!''',
      ownerId: 123,
      date: 123123123,
      numLikes: 3026,
      images: [
        'http://image.fomos.kr/contents/images/board/2019/1103/1572743242649190.jpg',
        'http://image.fomos.kr/contents/images/board/2019/1103/1572743242649190.jpg',
        'http://image.fomos.kr/contents/images/board/2019/1103/1572743242649190.jpg',
        'http://image.fomos.kr/contents/images/board/2019/1103/1572743242649190.jpg',
      ],
      tags: ['가을', '다이어트', '가을다이어트', '전문가추천', '썸네일낚시'],
    ),
    PostInfo(
      title: '안되는 줄 알면서 왜 그랬을까',
      desc: '^^',
      ownerId: 124,
      date: 123123124,
      numLikes: 2931,
      images: [
        'https://i.ytimg.com/vi/lKE0ypSBd2g/sddefault.jpg',
      ],
      tags: [],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // 카테고리 버튼
        leading: IconButton(
          icon: Icon(Icons.list),
          tooltip: '카테고리',
          onPressed: () {},
        ),
        // 카테고리
        title: Text('비만'),
        // 검색 버튼
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            tooltip: '검색',
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
            PostBoardContentsWidget(infos),
          ],
        ),
      ),
    );
  }
}

class PostBoardContentsWidget extends StatelessWidget {
  final List<PostInfo> infos;

  final bool primary;

  const PostBoardContentsWidget(this.infos, {this.primary = true});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      primary: primary,
      padding: const EdgeInsets.all(16),
      crossAxisCount: 2,
      childAspectRatio: 5.9 / 9.0,
      children: infos
          .map(
            (e) => InkWell(
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 썸네일
                    AspectRatio(
                      aspectRatio: 17 / 16,
                      child: Image.network(
                        e.thumb,
                        fit: BoxFit.fill,
                      ),
                    ),
                    // 제목
                    Container(
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                      child: Text(
                        e.title,
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
                            tooltip: '찜하기',
                            onPressed: () {},
                          ),
                          Text(e.numLikesFormat),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () => _moveToPage(context, e),
            ),
          )
          .toList(),
    );
  }

  /// 주어진 게시글을 보여주는 화면으로 이동합니다.
  void _moveToPage(BuildContext context, PostInfo info) async {
    // 작성자의 다른 글 목록
    final List<PostInfo> relatives = [
      PostInfo(
        title: '안되는 줄 알면서 왜 그랬을까',
        desc: '^^',
        ownerId: 124,
        date: 123123124,
        numLikes: 2931,
        images: [
          'https://i.ytimg.com/vi/lKE0ypSBd2g/sddefault.jpg',
        ],
        tags: [],
      ),
      PostInfo(
        title: '안되는 줄 알면서 왜 그랬을까',
        desc: '^^',
        ownerId: 124,
        date: 123123124,
        numLikes: 2931,
        images: [
          'https://i.ytimg.com/vi/lKE0ypSBd2g/sddefault.jpg',
        ],
        tags: [],
      ),
      PostInfo(
        title: '안되는 줄 알면서 왜 그랬을까',
        desc: '^^',
        ownerId: 124,
        date: 123123124,
        numLikes: 2931,
        images: [
          'https://i.ytimg.com/vi/lKE0ypSBd2g/sddefault.jpg',
        ],
        tags: [],
      ),
    ];

    Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) => PostWidget(info, relatives),
    ));
  }
}

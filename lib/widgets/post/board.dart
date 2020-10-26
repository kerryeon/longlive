import 'package:flutter/material.dart';
import 'package:longlive/models/habit.dart';
import 'package:longlive/models/post.dart';
import 'package:longlive/widgets/board/core.dart';
import 'package:longlive/widgets/post/like.dart';
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
  final PostBoardController _controller;

  final String url;

  const PostBoardWidget(this._controller, this.url);

  /// 오늘의 년/월 문자열
  String get dateFormat {
    final now = new DateTime.now();
    return '${now.year}년 ${now.month}월';
  }

  @override
  State createState() => _State(_controller, url, dateFormat);
}

class _State extends BoardState<PostInfo, PostQuery> {
  final PostBoardController _controller;

  final String url;
  final String dateFormat;

  _State(
    this._controller,
    this.url,
    this.dateFormat,
  ) : super(
          url: url,
          query: PostQuery(_controller.category),
        );

  Future<void> reload({
    String title,
    Habit ty,
    List<String> tags,
    PostQueryOrder order,
  }) async {
    _controller.category = ty;
    if (_controller.category != null && _controller.category.id == 0)
      _controller.category = null;

    if (order != null) {
      query.order = order;
    }

    return super.reload(title: title, ty: ty, tags: tags);
  }

  @override
  Widget buildBody(BuildContext context) {
    return Center(
      child: ListView(
        children: [
          Stack(
            alignment: Alignment.centerLeft,
            children: [
              // 날짜
              Visibility(
                visible: _controller.date,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 0, 12),
                  child: Text(
                    dateFormat,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
              ),
              // 정렬
              Visibility(
                visible: _controller.sort,
                child: ButtonBar(
                  alignment: _controller.date
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.center,
                  children: [
                    FlatButton(
                      child: const Text('인기순'),
                      onPressed: () => reload(order: PostQueryOrder.Popular),
                    ),
                    FlatButton(
                      child: const Text('최신순'),
                      onPressed: () => reload(order: PostQueryOrder.Latest),
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
    );
  }
}

class PostBoardContentsWidget extends StatelessWidget {
  final List<PostInfo> infos;

  const PostBoardContentsWidget(this.infos);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      primary: false,
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
                    LikeButtonWidget(e),
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

class PostBoardController {
  /// 날짜 표시
  final bool date;

  /// 정렬 기능
  final bool sort;

  Habit category;

  PostBoardController({
    this.date = false,
    this.sort = true,
    this.category,
  });
}

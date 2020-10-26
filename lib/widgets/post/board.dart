import 'package:flutter/material.dart';
import 'package:longlive/models/post.dart';
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

class _State extends State {
  final PostBoardController _controller;

  final String url;
  final String dateFormat;

  _State(
    this._controller,
    this.url,
    this.dateFormat,
  );

  List<PostInfo> infos = [];

  // 쿼리
  PostQuery query = PostQuery(
    tags: [],
    order: PostQueryOrder.Popular,
  );

  // 쿼리 갱신중
  bool _isLoading = false;

  Future<void> _reload({
    String title,
    List<String> tags,
    PostQueryOrder order,
  }) async {
    if (!mounted || _isLoading) return;
    _isLoading = true;
    setState(() => _controller._category = '비만');

    // 쿼리 갱신
    if (title != null) {
      query.title = title;
    }
    if (tags != null) {
      query.tags = tags;
    }
    if (order != null) {
      query.order = order;
    }

    // 쿼리 요청
    final infos = await query.getList(context, url);

    // 화면 갱신
    if (!mounted) return;
    _isLoading = false;
    setState(() => this.infos = infos);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _reload());
  }

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
                        onPressed: () => _reload(order: PostQueryOrder.Popular),
                      ),
                      FlatButton(
                        child: const Text('최신순'),
                        onPressed: () => _reload(order: PostQueryOrder.Latest),
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

  String _category;

  PostBoardController({
    this.date = false,
    this.sort = true,
    String category,
  }) {
    this._category = category;
  }

  String get category => _category;
}

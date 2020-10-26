import 'package:flutter/material.dart';
import 'package:longlive/models/habit.dart';
import 'package:longlive/models/video.dart';
import 'package:longlive/widgets/board/menu.dart';
import 'package:longlive/widgets/video/post.dart';

/// ## 추천영상 목록 위젯
/// ### 생김새
/// - 상단
///   - (좌) 카테고리 선택 버튼
///   - 카테고리 이름
///   - (우) 검색 버튼
/// - 중앙
///   - 게시글 목록
///
/// ### 기능
/// - 탭을 눌러 컨텐츠 전환
class VideoBoardWidget extends StatefulWidget {
  @override
  State createState() => _State();
}

class _State extends State {
  List<VideoInfo> infos = [];

  // 쿼리
  VideoQuery query = VideoQuery(
    tags: [],
  );

  // 쿼리 갱신중
  bool _isLoading = false;

  Future<void> _reload({
    String title,
    Habit ty,
    List<String> tags,
  }) async {
    if (!mounted || _isLoading) return;
    _isLoading = true;

    // 쿼리 갱신
    if (title != null) {
      query.title = title;
    }
    if (ty != null) {
      if (ty.id == 0) ty = null;
      query.ty = ty;
    }
    if (tags != null) {
      query.tags = tags;
    }

    // 쿼리 요청
    final infos = await query.getList(context);

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
        // 카테고리
        title: Text(
          query.ty != null ? query.ty.name : '모두',
        ),
        // 검색 버튼
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            tooltip: '검색',
            onPressed: () {},
          ),
        ],
      ),
      // 카테고리 목록
      drawer: CategoryWidget(
        onTap: (ty) => _reload(ty: ty),
      ),
      // 중앙에 배치
      body: Center(
        child: GridView.count(
          padding: const EdgeInsets.all(16),
          crossAxisCount: 2,
          childAspectRatio: 6.8 / 9.0,
          children: infos
              .map(
                (e) => Stack(
                  children: [
                    Card(
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // 썸네일
                            AspectRatio(
                              aspectRatio: 17 / 16,
                              child: Image.network(
                                e.thumb,
                                fit: BoxFit.none,
                                scale: 0.4,
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
                          ],
                        ),
                        onTap: () => _moveToPage(e),
                      ),
                    ),
                    // 광고 태그
                    Visibility(
                      visible: e.ad,
                      child: IconButton(
                        icon: Icon(
                          Icons.star,
                          color: Colors.orange,
                        ),
                        tooltip: '광고 영상',
                        onPressed: null,
                      ),
                    ),
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  /// 주어진 동영상을 재생하는 화면으로 이동합니다.
  void _moveToPage(VideoInfo info) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) => VideoWidget(info),
    ));
  }
}

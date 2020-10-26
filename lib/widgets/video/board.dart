import 'package:flutter/material.dart';
import 'package:longlive/models/video.dart';
import 'package:longlive/widgets/board/core.dart';
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

class _State extends BoardState<VideoInfo, VideoQuery> {
  _State()
      : super(
          url: 'videos',
          query: VideoQuery(),
        );

  @override
  Widget buildBody(BuildContext context) {
    return Center(
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
    );
  }

  /// 주어진 동영상을 재생하는 화면으로 이동합니다.
  void _moveToPage(VideoInfo info) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) => VideoWidget(info),
    ));
  }
}

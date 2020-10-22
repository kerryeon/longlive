import 'package:flutter/material.dart';
import 'package:longlive/models/video.dart';

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
  @override
  Widget build(BuildContext context) {
    final List<VideoInfo> videos = [
      VideoInfo(
        title: '몸 좋아 보이려면 \'무조건\' 키워야 하는 근육 부위 TOP4',
        desc: '',
        owner: '헬창TV',
        thumb:
            'https://i.ytimg.com/an_webp/slZVJPxCqpQ/mqdefault_6s.webp?du=3000&sqp=CMThw_wF&rs=AOn4CLBhHiEOhGBSh7aJiCYCHvhDM6A2TQ',
        ad: true,
      ),
    ];

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
        child: GridView.count(
          padding: const EdgeInsets.all(16),
          crossAxisCount: 2,
          childAspectRatio: 6.8 / 9.0,
          children: videos
              .map(
                (e) => Stack(
                  children: [
                    Card(
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // 썸네일
                          AspectRatio(
                            aspectRatio: 17 / 16,
                            child: Image.network(e.thumb, fit: BoxFit.fill),
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
                    ),
                    // 광고 태그
                    IconButton(
                      icon: Icon(
                        Icons.star,
                        color: Colors.orange,
                      ),
                      tooltip: '광고 영상',
                      onPressed: null,
                    ),
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

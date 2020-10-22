import 'package:flutter/material.dart';
import 'package:longlive/models/video.dart';
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
  final List<VideoInfo> videos = [
    VideoInfo(
      title: '몸 좋아 보이려면 \'무조건\' 키워야 하는 근육 부위 TOP4',
      desc: '몸 좋아 보이려면 \'무조건\' 키워야 하는 근육 부위 TOP4',
      owner: '헬창TV',
      videoId: 'slZVJPxCqpQ',
      ad: true,
    ),
    VideoInfo(
      title: '당신이 \'절대\' 몰랐던 여자 체지방별 몸매 변화 (feat 핏블리)',
      desc: '당신이 \'절대\' 몰랐던 여자 체지방별 몸매 변화 (feat 핏블리)',
      owner: '헬창TV',
      videoId: 'tY42IlwahGU',
      ad: true,
    ),
    VideoInfo(
      title: '김계란이 알려주는 \'식단\'에 따른 운동방법',
      desc: '저탄고지와 고탄저지에 대한 정보영상 입니다.',
      owner: '피지컬갤러리',
      videoId: '4lEm4pDL8ns',
      ad: false,
    ),
  ];

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
                      child: InkWell(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // 썸네일
                            AspectRatio(
                              aspectRatio: 17 / 16,
                              child: Image.network(
                                'https://img.youtube.com/vi/${e.videoId}/3.jpg',
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

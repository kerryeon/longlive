import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:longlive/models/video.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

/// ## 영상 위젯
/// ### 생김새
/// - 상단
///   - 영상 제목
/// - 중앙
///   - YouTube 영상
///   - (우측) 크리에이터 이름
///   - 영상 설명
class VideoWidget extends StatefulWidget {
  final VideoInfo info;

  const VideoWidget(this.info);

  @override
  State createState() => _State(info);
}

class _State extends State {
  final VideoInfo info;

  YoutubePlayerController _controller;

  _State(this.info);

  /// 제목 표시
  bool appBar = true;

  @override
  Widget build(BuildContext context) {
    _controller = YoutubePlayerController(
      initialVideoId: info.videoId,
      flags: YoutubePlayerFlags(
        autoPlay: true,
      ),
    );

    return Scaffold(
      appBar: appBar
          ? AppBar(
              // 영상 제목
              title: Text(info.title),
            )
          : null,
      // 중앙에 배치
      body: Center(
        child: ListView(
          children: [
            YoutubePlayerBuilder(
              player: YoutubePlayer(
                controller: _controller,
              ),
              onEnterFullScreen: () => setState(() => appBar = false),
              onExitFullScreen: () => setState(() => appBar = true),
              builder: (context, player) {
                return Column(
                  children: [
                    // some widgets
                    player,
                    // some other widgets
                  ],
                );
              },
            ),
            // 크리에이터 이름
            Align(
              alignment: Alignment.centerRight,
              child: FlatButton(
                child: Text(
                  info.owner,
                  style: TextStyle(color: Colors.black45),
                ),
                onPressed: _moveToYouTube,
              ),
            ),
            // 설명
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
              child: Text(info.desc),
            ),
          ],
        ),
      ),
    );
  }

  /// YouTube 앱을 실행합니다.
  Future<void> _moveToYouTube() async {
    // 실행중인 영상을 정지합니다.
    _controller.pause();

    final url = 'https://www.youtube.com/watch?v=${info.videoId}';
    await launch(url);
  }

  @override
  void dispose() {
    _controller.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:longlive/widgets/content/base.dart';
import 'package:longlive/widgets/video/board.dart';

/// ## 추천영상 컨텐츠
class VideosWidget extends StatefulWidget implements ContentWidget {
  Icon get icon => Icon(Icons.video_collection);
  String get label => '추천영상';

  @override
  State createState() => _State();
}

class _State extends State {
  @override
  Widget build(BuildContext context) {
    return VideoBoardWidget();
  }
}

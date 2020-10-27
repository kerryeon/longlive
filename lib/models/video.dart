import 'package:longlive/models/base.dart';
import 'package:longlive/models/habit.dart';

class VideoInfo extends BoardEntity {
  final String desc;
  final String ownerId;
  final String ownerName;

  final String videoId;
  final bool ad;

  const VideoInfo({
    int id,
    String title,
    Habit ty,
    Set<String> tags,
    this.desc,
    this.ownerId,
    this.ownerName,
    this.videoId,
    this.ad,
  }) : super(id, title, ty, tags);

  String get thumb => 'https://img.youtube.com/vi/$videoId/default.jpg';
  String get url => 'https://www.youtube.com/watch?v=$videoId';

  static VideoInfo fromJson(Map<String, dynamic> map) {
    return VideoInfo(
      id: map['id'],
      title: map['title'],
      desc: map['desc'],
      ownerId: map['owner']['id'],
      ownerName: map['owner']['name'],
      ty: Habit.all[map['ty']],
      videoId: map['video_id'],
      ad: map['ad'],
      tags: Set<String>.from(map['tags']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'desc': desc,
      'ty': ty.id,
      'tags': tags,
    };
  }
}

class VideoQuery extends DBQuery<VideoInfo> {
  VideoQuery() : super(tags: []);

  VideoInfo Function(Map<String, dynamic>) get generator => VideoInfo.fromJson;
}

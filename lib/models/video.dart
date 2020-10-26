import 'package:flutter/material.dart';
import 'package:longlive/models/base.dart';
import 'package:longlive/models/habit.dart';
import 'package:longlive/models/net.dart';

class VideoInfo extends DBTable {
  final String title;
  final String desc;
  final String ownerId;
  final String ownerName;
  final Habit ty;

  final String videoId;
  final bool ad;

  final List<String> tags;

  const VideoInfo({
    int id,
    this.title,
    this.desc,
    this.ownerId,
    this.ownerName,
    this.ty,
    this.videoId,
    this.ad,
    this.tags,
  }) : super(id);

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
      tags: List<String>.from(map['tags']),
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

class VideoQuery {
  String title;
  List<String> tags;

  VideoQuery({
    this.title,
    this.tags,
  });

  Map<String, String> toJson() {
    final Map<String, String> map = {};
    if (title != null && title.isNotEmpty) {
      map['title__contains'] = title;
    }
    if (tags != null && tags.isNotEmpty) {
      map['tags'] = tags.join(',');
    }

    return map;
  }

  Future<List<VideoInfo>> getList(BuildContext context) async {
    return Net().getList(
      context: context,
      url: 'videos',
      generator: VideoInfo.fromJson,
      queries: toJson(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:longlive/models/base.dart';
import 'package:longlive/models/habit.dart';
import 'package:longlive/models/net.dart';

class PostInfo extends DBTable {
  final String title;
  final String desc;
  final int ownerId;
  final Habit ty;

  final List<String> tags;

  /// UTC 시간
  final DateTime dateCreate;
  final DateTime dateModify;

  final int numLikes;
  final List<String> images;

  // 찜 상태
  bool isLiked;

  PostInfo({
    int id,
    this.title,
    this.desc,
    this.ownerId,
    this.ty,
    this.tags,
    this.dateCreate,
    this.dateModify,
    this.numLikes,
    this.images,
    this.isLiked = false,
  }) : super(id);

  String get thumb => images.isNotEmpty
      ? images[0]
      // 기본 이미지
      : 'https://upload.wikimedia.org/wikipedia/en/4/48/Blank.JPG';

  String get numLikesFormat {
    return NumberFormat('#,###').format(numLikes);
  }

  static PostInfo fromJson(Map<String, dynamic> map) {
    return PostInfo(
      id: map['id'],
      title: map['title'],
      desc: map['desc'],
      ownerId: map['user'],
      ty: Habit.all[map['ty']],
      dateCreate: DateTime.parse(map['date_create']),
      dateModify: DateTime.parse(map['date_modify']),
      numLikes: map['likes'],
      images: List<String>.from(map['images'].map((e) => e['image']).toList()),
      tags: List<String>.from(map['tags']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'desc': desc,
      'ty': ty.id,
      'tags': tags,
      'images': images,
    };
  }
}

class PostQuery {
  String title;
  Habit ty;
  List<String> tags;
  PostQueryOrder order;

  PostQuery({
    this.title,
    this.ty,
    this.tags,
    this.order,
  });

  Map<String, String> toJson() {
    final Map<String, String> map = {};
    if (title != null && title.isNotEmpty) {
      map['title__contains'] = title;
    }
    if (ty != null) {
      map['ty'] = ty.id.toString();
    }
    if (tags != null && tags.isNotEmpty) {
      map['tags'] = tags.join(',');
    }
    if (order != null) {
      map['order'] = order.toJson();
    }

    final now = DateTime.now();
    final year = now.year;
    final month = now.month;

    // 현재 년/월을 기준으로 로드
    final dateBegin = DateTime.utc(year, month);
    final dateEnd = DateTime.utc(year, month + 1);
    map['date_create__gt'] = dateBegin.toIso8601String();
    map['date_create__lt'] = dateEnd.toIso8601String();
    return map;
  }

  Future<List<PostInfo>> getList(BuildContext context, String url) async {
    return Net().getList(
      context: context,
      url: url,
      generator: PostInfo.fromJson,
      queries: toJson(),
    );
  }
}

enum PostQueryOrder {
  Popular,
  Latest,
}

extension PostQueryOrderExtension on PostQueryOrder {
  String toJson() {
    switch (this) {
      case PostQueryOrder.Popular:
        return '-likes';
      case PostQueryOrder.Latest:
      default:
        return '-date';
    }
  }
}

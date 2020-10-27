import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:longlive/models/base.dart';
import 'package:longlive/models/habit.dart';
import 'package:longlive/models/net.dart';
import 'package:longlive/widgets/dialog/simple.dart';

class PostInfo extends BoardEntity {
  final String desc;
  final int ownerId;

  /// UTC 시간
  final DateTime dateCreate;
  final DateTime dateModify;

  int numLikes;
  bool isLiked;

  final List<String> images;

  PostInfo({
    int id,
    String title,
    Habit ty,
    Set<String> tags,
    this.desc,
    this.ownerId,
    this.dateCreate,
    this.dateModify,
    this.numLikes,
    this.isLiked = false,
    this.images,
  }) : super(id, title, ty, tags);

  String get thumb => images.isNotEmpty
      ? images[0]
      // 기본 이미지
      : 'https://upload.wikimedia.org/wikipedia/en/4/48/Blank.JPG';

  String get numLikesFormat {
    return NumberFormat('#,###').format(numLikes);
  }

  Future<void> toggleLike(BuildContext context) async {
    isLiked = !isLiked;
    numLikes += isLiked ? 1 : -1;

    return Net().createOneWithQuery(
      context: context,
      url: 'user/posts/liked/mut',
      queries: {
        'post': id,
        'enabled': isLiked,
      },
    );
  }

  Future<bool> create(BuildContext context, List<File> images) async {
    final result = await Net().createOne(
      context: context,
      url: 'posts/mut',
      object: this,
      files: images,
    );

    // 등록 성공
    if (result) {
      await showMessageDialog(
        context: context,
        content: '등록되었습니다.',
      );
    }
    return result;
  }

  Future<bool> report(BuildContext context, String desc) async {
    var result = false;

    final netResult = await Net().createOneWithQuery(
      context: context,
      url: 'user/posts/report',
      queries: {
        'post': id,
        'desc': desc,
      },
      // 중복 신고됨
      onInternalFailure: () async {
        result = true;
        await showMessageDialog(
          context: context,
          content: '이미 신고한 게시글입니다.',
        );
      },
    );

    // 신고 성공
    if (netResult) {
      result = true;
      await showMessageDialog(
        context: context,
        content: '신고해주셔서 감사합니다.',
      );
    }
    return result;
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
      isLiked: map['liked'],
      images: List<String>.from(map['images'].map((e) => e['image']).toList()),
      tags: Set<String>.from(map['tags']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'desc': desc,
      'ty': ty.id,
      'tags': tags.join(','),
    };
  }
}

class PostQuery extends DBQuery<PostInfo> {
  int user;
  PostQueryOrder order;

  PostQuery(
    Habit ty, {
    this.order = PostQueryOrder.Latest,
    int pageSize = 16,
  }) : super(ty: ty, tags: [], pageSize: pageSize);

  Map<String, String> toJson() {
    final map = super.toJson();
    if (user != null) {
      map['user'] = user.toString();
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

  PostInfo Function(Map<String, dynamic>) get generator => PostInfo.fromJson;
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

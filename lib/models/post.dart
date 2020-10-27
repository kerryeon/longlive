import 'package:intl/intl.dart';
import 'package:longlive/models/base.dart';
import 'package:longlive/models/habit.dart';

class PostInfo extends BoardEntity {
  final String desc;
  final int ownerId;

  /// UTC 시간
  final DateTime dateCreate;
  final DateTime dateModify;

  final int numLikes;
  final List<String> images;

  // 찜 상태
  bool isLiked;

  PostInfo({
    int id,
    String title,
    Habit ty,
    List<String> tags,
    this.desc,
    this.ownerId,
    this.dateCreate,
    this.dateModify,
    this.numLikes,
    this.images,
    this.isLiked = false,
  }) : super(id, title, ty, tags);

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
      isLiked: map['liked'],
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

class PostQuery extends DBQuery<PostInfo> {
  int user;
  PostQueryOrder order;

  PostQuery(Habit ty, {this.order, int pageSize = 16})
      : super(ty: ty, tags: [], pageSize: pageSize);

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

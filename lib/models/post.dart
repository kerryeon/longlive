import 'package:intl/intl.dart';
import 'package:longlive/models/base.dart';
import 'package:longlive/models/habit.dart';

// 태그 구분자(delimiter)
final String _tagDelim = '\n';

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
      ownerId: map['owner_id'],
      ty: Habit.all[map['ty']],
      dateCreate: DateTime.parse(map['date_create']),
      dateModify: DateTime.parse(map['date_modify']),
      numLikes: map['likes'],
      images: List<String>.from(map['images'].map((e) => e['image']).toList()),
      tags: map['tags']
          .split(_tagDelim)
          .where((e) => e.isNotEmpty as bool)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'desc': desc,
      'ty': ty.id,
      'tags': tags.join(_tagDelim),
      'images': images,
    };
  }
}

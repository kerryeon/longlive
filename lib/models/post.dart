import 'package:intl/intl.dart';

class PostInfo {
  final String title;
  final String desc;
  final int ownerId;

  /// UTC 시간
  final int date;

  final int numLikes;

  final List<String> images;
  final List<String> tags;

  const PostInfo({
    this.title,
    this.desc,
    this.ownerId,
    this.date,
    this.numLikes,
    this.images,
    this.tags,
  });

  String get thumb => images[0];

  String get numLikesFormat {
    return NumberFormat('#.###').format(numLikes);
  }
}

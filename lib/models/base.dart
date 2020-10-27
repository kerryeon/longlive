import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:longlive/models/habit.dart';
import 'package:longlive/models/net.dart';

/// 데이터베이스 테이블을 구성하는 추상 클래스입니다.
abstract class DBTable {
  final int id;

  const DBTable(this.id);

  Map<String, dynamic> toJson();

  String toJsonEncoded() => json.encode(toJson());

  @override
  String toString() {
    return toJson().toString();
  }
}

/// 목록을 구성하는 추상 클래스입니다.
abstract class BoardEntity extends DBTable {
  final String title;
  final Habit ty;
  final List<String> tags;

  const BoardEntity(
    int id,
    this.title,
    this.ty,
    this.tags,
  ) : super(id);

  String get thumb;
}

/// 데이터베이스 쿼리를 구성하는 추상 클래스입니다.
abstract class DBQuery<T extends BoardEntity> {
  final int pageSize;

  int page;
  bool hasNextPage = false;

  String title;
  Habit ty;
  List<String> tags;

  DBQuery({
    this.pageSize = 16,
    this.page = 1,
    this.title,
    this.ty,
    this.tags,
  });

  Map<String, String> toJson() {
    final Map<String, String> map = {};
    map['page_size'] = pageSize.toString();
    map['page'] = page.toString();
    if (title != null && title.isNotEmpty) {
      map['title__contains'] = title;
    }
    if (ty != null) {
      map['ty'] = ty.id.toString();
    }
    if (tags != null && tags.isNotEmpty) {
      map['tags'] = tags.join(',');
    }

    return map;
  }

  Future<List<T>> getList(BuildContext context, String url) async {
    return Net().getList(
      context: context,
      url: url,
      preprocess: (e) {
        // 다음 페이지가 있는가?
        hasNextPage = e['next'] != null;
        return e['results'];
      },
      generator: generator,
      queries: toJson(),
    );
  }

  T Function(Map<String, dynamic>) get generator;
}

import 'dart:convert';

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

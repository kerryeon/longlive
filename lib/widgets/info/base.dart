import 'package:flutter/material.dart';

/// 내 정보 추상 클래스
/// 내 정보 기능 목록에 표시하기 위한 정보를 담고 있습니다.
abstract class UserInfo {
  String get label;

  Future<void> onPressed(BuildContext context);
}

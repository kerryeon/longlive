import 'package:flutter/material.dart';

/// 컨텐츠 추상 클래스
/// 메인화면의 하단 바에 표시하기 위한 정보를 담고 있습니다.
abstract class ContentWidget implements Widget {
  Icon get icon;
  String get label;
}

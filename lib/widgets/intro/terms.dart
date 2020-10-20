import 'package:flutter/material.dart';

/// ## 약관화면
/// ### 생김새
/// - 중앙에 약관
/// - 맨 아래에 동의 버튼
///
/// ### 기능
/// - 맨 아래에 동의 버튼을 눌러 가입
class TermsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('약관'),
      ),
      // 중앙에 배치
      body: Center(
        // 로고
        child: Text('약관 화면 제작중'),
      ),
    );
  }
}

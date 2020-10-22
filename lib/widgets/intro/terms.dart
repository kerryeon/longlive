import 'package:flutter/material.dart';
import 'package:longlive/widgets/dialog/simple.dart';
import 'package:longlive/widgets/info/terms.dart';

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
        child: ListView(
          children: [
            // 약관 텍스트
            TermsContentWidget(),
            // 동의 버튼
            Container(
              padding: const EdgeInsets.fromLTRB(60, 12, 60, 14),
              child: FlatButton(
                color: Colors.amber,
                padding: const EdgeInsets.all(10),
                child: Text(
                  '동의합니다',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                onPressed: () => _onAgree(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 사용자가 약관에 동의했습니다.
  /// 가입을 마무리하고, 메인화면으로 이동합니다.
  void _onAgree(BuildContext context) {
    // 회원 정보를 저장합니다.

    // 환영 메세지
    showMessageDialog(
      context: context,
      content: '가입을 환영합니다 ^^',
      onConfirm: () => _moveToMainWidget(context),
    );
  }

  /// 메인 화면으로 이동합니다.
  void _moveToMainWidget(BuildContext context) {}
}

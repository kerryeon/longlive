import 'package:flutter/material.dart';
import 'package:longlive/models/login/core.dart';
import 'package:longlive/models/user.dart';
import 'package:longlive/widgets/dialog/simple.dart';
import 'package:longlive/widgets/info/terms.dart';
import 'package:longlive/widgets/main.dart';

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
  Future<void> _onAgree(BuildContext context) async {
    // 서버에 회원가입을 요청합니다.
    final result = await User.getInstance().register(context);

    // 환영 메세지를 띄우고, 메인화면으로 이동합니다.
    if (result) {
      showMessageDialog(
        context: context,
        content: '가입을 환영합니다 ^^',
        onConfirm: () => _moveToMainWidget(context),
      );
    }
  }

  /// 다시 로그인 후, 메인 화면으로 이동합니다.
  Future<void> _moveToMainWidget(BuildContext context) async {
    if (await UserLogin().tryLogin(context)) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => MainWidget(),
        ),
      );
    }
  }
}

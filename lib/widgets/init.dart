import 'package:flutter/material.dart';
import 'package:longlive/models/user.dart';
import 'package:longlive/widgets/register.dart';

/// ## 초기화면
/// ### 생김새
/// - 중앙에 앱 로고
///
/// ### 기능
/// - 잠시 후, 메인화면으로 이동
/// - 첫 사용자는, 첫 사용자 화면으로 이동
class InitWidget extends StatefulWidget {
  @override
  State createState() => _State();
}

class _State extends State {
  @override
  Widget build(BuildContext context) {
    _waitAndMove();
    return Scaffold(
      // 중앙에 배치
      body: Center(
        // 로고
        child: Image.network(
          'https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png',
        ),
      ),
    );
  }

  /// 잠시 후 다음 화면으로 이동합니다.
  void _waitAndMove() {
    Future.delayed(const Duration(seconds: 2), _moveToNextPage);
  }

  /// 다음 화면으로 이동합니다.
  /// 이때, 첫 사용자는 첫 사용자 화면으로 이동합니다. [RegisterWidget]
  /// 기존 사용자는 메인 화면으로 이동합니다. [MainWidget]
  void _moveToNextPage() {
    if (!User().isLoggedIn) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => RegisterWidget(),
        ),
      );
    }
  }
}

import 'package:flutter/material.dart';
import 'package:longlive/models/login/core.dart';
import 'package:longlive/models/user.dart';
import 'package:longlive/widgets/intro/register.dart';
import 'package:longlive/widgets/main.dart';

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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _tryLogin());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Image.asset(
        'assets/icons/logo.png',
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
        alignment: Alignment.center,
      ),
    );
  }

  /// 로그인을 시도합니다.
  /// 이후, 적절한 화면으로 이동합니다.
  Future<void> _tryLogin() async {
    final userLogin = UserLogin();

    // 변수를 초기화합니다.
    await userLogin.initialize(context);

    // 로그인을 시도합니다.
    final result = await userLogin.tryLogin(context);

    // 로그인에 성공하면, 다음 화면으로 이동합니다.
    if (result) _moveToNextWidget();
  }

  /// 다음 화면으로 이동합니다.
  /// 이때, 첫 사용자는 첫 사용자 화면으로 이동합니다. [RegisterWidget]
  /// 기존 사용자는 메인 화면으로 이동합니다. [MainWidget]
  void _moveToNextWidget() {
    final widget = User.getInstance() != null ? MainWidget() : RegisterWidget();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (BuildContext context) => widget,
      ),
    );
  }
}

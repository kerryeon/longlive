import 'package:flutter/material.dart';
import 'package:longlive/widgets/dialog/simple.dart';
import 'package:longlive/widgets/info/base.dart';

/// ## 회원탈퇴 기능
class WithdrawalInfo implements UserInfo {
  String get label => '회원탈퇴';

  Future<void> onPressed(BuildContext context) async {
    return await showYesNoDialog(
      context: context,
      content: '정말 회원탈퇴 하시겠습니까? 계정은 이후 영구히 복구될 수 없습니다.',
      onAccept: () async => _onAccept(context),
    );
  }

  Future<void> _onAccept(BuildContext context) async {
    return await showMessageDialog(
      context: context,
      content: '저희 Longlive를 이용해주셔서 감사했습니다!',
      onConfirm: exitApp,
    );
  }
}

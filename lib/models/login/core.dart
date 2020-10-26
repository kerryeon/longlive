import 'package:flutter/material.dart';
import 'package:longlive/models/login/base.dart';
import 'package:longlive/models/login/kakao.dart';

class UserLogin extends AbstractUserLogin {
  const UserLogin();

  int get loginType => null;

  static const AbstractUserLogin _instance = KakaoUserLogin();

  Future<void> initialize(BuildContext context) async =>
      _instance.initialize(context);

  Future<bool> tryLogin(BuildContext context) async =>
      _instance.tryLogin(context);

  Future<String> tryGetToken(BuildContext context) async =>
      _instance.tryGetToken(context);

  Future<Map<String, dynamic>> toJson(BuildContext context) async =>
      _instance.toJson(context);
}

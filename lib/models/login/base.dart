import 'package:flutter/material.dart';
import 'package:longlive/models/habit.dart';
import 'package:longlive/models/net.dart';
import 'package:longlive/models/term.dart';
import 'package:longlive/models/user.dart';

/// 로그인 부분 기능을 구현합니다.
abstract class AbstractUserLogin {
  const AbstractUserLogin();

  int get loginType;

  Future<void> initialize(BuildContext context) async {
    await HabitType.initialize(context);
    await Habit.initialize(context);
    await Gender.initialize(context);
    await Term.initialize(context);
  }

  Future<bool> tryLogin(BuildContext context) async {
    final token = await tryGetToken(context);
    if (token == null) return false;

    var result = false;

    final user = await Net.postOne(
      context: context,
      url: 'user/session/login',
      queries: {'ty': loginType, 'token': token},
      generator: User.fromJson,
      onInternalFailure: () async => result = true,
    );
    if (!result && user == null) return false;

    if (user != null) {
      user.initialize();
    }
    return true;
  }

  Future<String> tryGetToken(BuildContext context);

  Future<Map<String, dynamic>> toJson(BuildContext context) async {
    return {
      'ty': loginType,
      'token': await tryGetToken(context) ?? 'undefined',
    };
  }
}

import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/all.dart' as Kakao;
import 'package:longlive/models/habit.dart';
import 'package:longlive/models/net.dart';
import 'package:longlive/models/term.dart';
import 'package:longlive/models/user.dart';
import 'package:longlive/res/net.dart';
import 'package:longlive/widgets/dialog/simple.dart';

class UserLogin {
  static final _loginType = 1;

  const UserLogin();

  Future<void> initialize(BuildContext context) async {
    await HabitType.initialize(context);
    await Habit.initialize(context);
    await Gender.initialize(context);
    await Term.initialize(context);

    // KakaoTalk Native App Key 등록
    Kakao.KakaoContext.clientId = 'b5a5548ad6ff25d145583cc22d0e9846';
  }

  Future<bool> tryLogin(BuildContext context) async {
    final token = await tryGetToken(context);
    if (token == null) return false;

    var result = false;

    final user = await Net.postOne(
      context: context,
      url: 'user/session/login',
      queries: {'ty': _loginType, 'token': token},
      generator: User.fromJson,
      onInternalFailure: () async => result = true,
    );
    if (!result && user == null) return false;

    if (user != null) {
      user.initialize();
    }
    return true;
  }

  Future<String> tryGetToken(BuildContext context) async {
    return 'YKHN5_CaxGQOoDYNSEJ4GvMM_S_swsjIikny4Qo9cpcAAAF1VgvcQg';

    try {
      final tokenStored = await Kakao.AccessTokenStore.instance.fromStore();
      if (tokenStored.refreshToken != null) {
        return tokenStored.accessToken;
      }

      final installed = await Kakao.isKakaoTalkInstalled();
      final authCode = installed
          ? await Kakao.AuthCodeClient.instance.requestWithTalk()
          : await Kakao.AuthCodeClient.instance.request();

      // Access Token 부여 및 저장
      final token = await Kakao.AuthApi.instance.issueAccessToken(authCode);
      Kakao.AccessTokenStore.instance.toStore(token);

      return token.accessToken;
    } on Kakao.KakaoAuthException catch (_) {
      await showMessageDialog(
        context: context,
        content: NetMessage.loginFailure,
        onConfirm: exitApp,
      );
    } catch (_) {
      await showMessageDialog(
        context: context,
        content: NetMessage.internalFailure,
        onConfirm: exitApp,
      );
    }
  }

  Future<Map<String, dynamic>> toJson(BuildContext context) async {
    return {
      'ty': _loginType,
      'token': await tryGetToken(context),
    };
  }
}

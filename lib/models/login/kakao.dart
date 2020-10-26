import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/all.dart' as Kakao;
import 'package:longlive/models/login/base.dart';
import 'package:longlive/res/net.dart';
import 'package:longlive/widgets/dialog/simple.dart';

class KakaoUserLogin extends AbstractUserLogin {
  const KakaoUserLogin();

  int get loginType => 1;

  Future<void> initialize(BuildContext context) async {
    await super.initialize(context);

    // KakaoTalk Native App Key 등록
    Kakao.KakaoContext.clientId = 'b5a5548ad6ff25d145583cc22d0e9846';
  }

  Future<String> tryGetToken(BuildContext context) async {
    try {
      final tokenStored = await Kakao.AccessTokenStore.instance.fromStore();
      if (tokenStored.refreshToken != null ||
          tokenStored.refreshTokenExpiresAt.isAfter(DateTime.now())) {
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
      return null;
    } catch (_) {
      await showMessageDialog(
        context: context,
        content: NetMessage.internalFailure,
        onConfirm: exitApp,
      );
      return null;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:longlive/res/app.dart';
import 'package:longlive/widgets/intro/init.dart';
import 'package:longlive/widgets/main.dart';

// 초기 화면에서 앱이 시작합니다.
void main() => runApp(AppWidget());

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // 앱 이름
      title: App.appName,
      theme: ThemeData(
        // 앱의 색상 / 색감
        primarySwatch: Colors.brown,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainWidget(),
      // home: InitWidget(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:longlive/res/app.dart';

class InitWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // 앱 이름
      title: App.appName,
      theme: ThemeData(
        // 앱의 색상 / 색감
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        body: Center(
          // 세로로 배치
          child: Column(
            // 가운데 정렬
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.network(
                  'https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png'),
              Text(
                '오래살자',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

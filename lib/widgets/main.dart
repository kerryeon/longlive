import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:longlive/widgets/content/base.dart';
import 'package:longlive/widgets/content/favorites.dart';
import 'package:longlive/widgets/content/leader_board.dart';
import 'package:longlive/widgets/content/user_info.dart';
import 'package:longlive/widgets/content/videos.dart';

/// ## 메인화면
/// ### 생김새
/// - 중앙
///   - 컨텐츠
/// - 하단
///   - 탭
///
/// ### 기능
/// - 탭을 눌러 컨텐츠 전환
class MainWidget extends StatefulWidget {
  @override
  State createState() => _State();
}

class _State extends State {
  final List<ContentWidget> contents = [
    LeaderBoardWidget(),
    FavoritesWidget(),
    VideosWidget(),
    UserInfoWidget(),
  ];

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 컨텐츠
      body: DoubleBackToCloseApp(
        child: contents[_currentIndex],
        snackBar: const SnackBar(
          content: Text('\'뒤로\' 버튼을 한번 더 누르시면 종료됩니다.'),
        ),
      ),
      // 하단 바 (탭)
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _currentIndex = index),
        currentIndex: _currentIndex,
        items: contents
            .map(
              (c) => BottomNavigationBarItem(
                icon: c.icon,
                label: c.label,
              ),
            )
            .toList(),
      ),
    );
  }
}

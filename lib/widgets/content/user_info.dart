import 'package:flutter/material.dart';
import 'package:longlive/widgets/content/base.dart';
import 'package:longlive/widgets/info/base.dart';
import 'package:longlive/widgets/info/habits.dart';
import 'package:longlive/widgets/info/licenses.dart';
import 'package:longlive/widgets/info/posts.dart';
import 'package:longlive/widgets/info/terms.dart';
import 'package:longlive/widgets/info/withdrawal.dart';

/// ## 내 정보 컨텐츠
/// ### 생김새
/// - 상단: "내 정보" AppBar
/// - 중앙
///   - 기능 목록
///
/// ### 기능
/// - 기능을 눌러 활성화
class UserInfoWidget extends StatefulWidget implements ContentWidget {
  Icon get icon => Icon(Icons.person);
  String get label => '내 정보';

  @override
  State createState() => _State();
}

class _State extends State {
  final List<UserInfo> infos = [
    MyPostsInfo(),
    HabitsInfo(),
    TermsInfo(),
    LicensesInfo(),
    WithdrawalInfo(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('내 정보'),
      ),
      // 중앙에 배치
      body: Center(
        // 로고
        child: ListView(
          padding: const EdgeInsets.all(12),
          children: infos
              .map(
                (i) => Card(
                  child: ListTile(
                    title: Text(i.label),
                    onTap: () => i.onPressed(context),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

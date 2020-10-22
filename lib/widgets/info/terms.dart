import 'package:flutter/material.dart';
import 'package:longlive/widgets/info/base.dart';

/// ## 약관 보기 기능
class TermsInfo implements UserInfo {
  String get label => '약관';

  Future<void> onPressed(BuildContext context) async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => _Widget(),
      ),
    );
  }
}

class TermsContentWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Container(
        alignment: Alignment.topLeft,
        color: Color(0xFFFFE0B2),
        padding: const EdgeInsets.all(18),
        child: Text('약관을 집어넣으면 됩니다.\n\n'),
      ),
    );
  }
}

class _Widget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('약관'),
      ),
      // 중앙에 배치
      body: SingleChildScrollView(
        child: TermsContentWidget(),
      ),
    );
  }
}

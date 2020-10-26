import 'package:flutter/material.dart';
import 'package:longlive/models/license.dart';
import 'package:longlive/models/net.dart';
import 'package:longlive/widgets/info/base.dart';

/// ## 오픈소스 라이센스 보기 기능
class LicensesInfo implements UserInfo {
  String get label => '오픈소스 라이센스';

  Future<void> onPressed(BuildContext context) async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => _BoardWidget(),
      ),
    );
  }
}

class _BoardWidget extends StatelessWidget {
  final List<LicenseInfo> infos = [
    LicenseInfo(
      name: 'flutter_carousel_slider',
      url:
          'https://raw.githubusercontent.com/serenader2014/flutter_carousel_slider/master/LICENSE',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('약관'),
      ),
      // 중앙에 배치
      body: Center(
        child: ListView(
          padding: const EdgeInsets.all(12),
          children: infos
              .map(
                (i) => Card(
                  color: Colors.lightGreen,
                  child: ListTile(
                    title: Text(i.name),
                    onTap: () => _moveToPage(context, i),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  /// 선택한 라이센스를 명세합니다.
  Future<void> _moveToPage(BuildContext context, LicenseInfo info) async {
    var desc = info.url;

    try {
      final dio = await Net().dio();
      final response = await dio.get(info.url);

      if (response.statusCode == 200) {
        desc = response.data;
      }
    } catch (_) {}

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => _PageWidget(info, desc),
      ),
    );
  }
}

class _PageWidget extends StatelessWidget {
  final LicenseInfo info;
  final String desc;

  const _PageWidget(this.info, this.desc);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(info.name),
      ),
      // 중앙에 배치
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Container(
            alignment: Alignment.topLeft,
            color: Color(0xFFDCEDC8),
            padding: const EdgeInsets.all(18),
            child: Text(desc),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:longlive/models/base.dart';
import 'package:longlive/models/net.dart';

class LicenseInfo extends DBTable {
  final String name;
  final String git;

  const LicenseInfo({
    this.name,
    this.git,
  }) : super(null);

  String get url {
    final tokens = git.split('/');
    final maintainer = tokens[3];
    final package = tokens[4];

    return 'https://raw.githubusercontent.com/$maintainer/$package/master/LICENSE';
  }

  static List<LicenseInfo> _all = [];
  static List<LicenseInfo> get all => _all;

  static Future<void> initialize(BuildContext context) async {
    _all = await Net().getList(
      context: context,
      url: "licenses",
      generator: fromJson,
    )
      // 이름 순으로 정렬
      ..sort((a, b) => a.name.compareTo(b.name));
  }

  static LicenseInfo fromJson(Map<String, dynamic> json) {
    return LicenseInfo(
      name: json['name'],
      git: json['git'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'git': git,
    };
  }

  @override
  String toString() {
    return name;
  }
}

import 'package:flutter/material.dart';
import 'package:longlive/models/base.dart';
import 'package:longlive/models/net.dart';

class Term extends DBTable {
  final String desc;
  final DateTime dateCreate;
  final DateTime dateModify;

  const Term({
    int id,
    this.desc,
    this.dateCreate,
    this.dateModify,
  }) : super(id);

  static Term _instance;
  static Term getInstance() => _instance;

  static Future<void> initialize(BuildContext context) async {
    final terms = await Net().getList(
      context: context,
      url: "term",
      generator: fromJson,
    );
    _instance = terms.values.last;
  }

  static Term fromJson(Map<String, dynamic> json) {
    return Term(
      id: json['id'],
      desc: json['desc'],
      dateCreate: DateTime.parse(json['date_create']),
      dateModify: DateTime.parse(json['date_modify']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'desc': desc,
      'date_create': dateCreate,
      'date_modify': dateModify,
    };
  }

  @override
  String toString() {
    return desc;
  }
}

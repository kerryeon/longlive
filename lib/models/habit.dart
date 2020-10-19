import 'package:flutter/material.dart';
import 'package:longlive/models/db.dart';

enum HabitType {
  Unknown,
  Interest,
  FaceAndSkin,
  Disease,
  Mental,
  Eating,
}

extension HabitTypeExtension on HabitType {
  String get description {
    switch (this) {
      case HabitType.Interest:
        return '흥미';
      case HabitType.FaceAndSkin:
        return '얼굴/피부';
      case HabitType.Disease:
        return '지병';
      case HabitType.Mental:
        return '정신';
      case HabitType.Eating:
        return '영양/식습관';
      case HabitType.Unknown:
      default:
        return '알 수 없음';
    }
  }

  static HabitType fromDescription(String description) {
    switch (description) {
      case '흥미':
        return HabitType.Interest;
      case '얼굴/피부':
        return HabitType.FaceAndSkin;
      case '지병':
        return HabitType.Disease;
      case '정신':
        return HabitType.Mental;
      case '영양/식습관':
        return HabitType.Eating;
      case '알 수 없음':
      default:
        return HabitType.Unknown;
    }
  }

  Color get primaryColor {
    switch (this) {
      case HabitType.Interest:
        return Colors.red;
      case HabitType.FaceAndSkin:
        return Colors.orange;
      case HabitType.Disease:
        return Colors.pink;
      case HabitType.Mental:
        return Colors.purple;
      case HabitType.Eating:
        return Colors.lightGreen;
      case HabitType.Unknown:
      default:
        return Colors.white30;
    }
  }

  Color get primaryAccentColor {
    switch (this) {
      case HabitType.Interest:
        return Colors.redAccent;
      case HabitType.FaceAndSkin:
        return Colors.orangeAccent;
      case HabitType.Disease:
        return Colors.pinkAccent;
      case HabitType.Mental:
        return Colors.purpleAccent;
      case HabitType.Eating:
        return Colors.lightGreenAccent;
      case HabitType.Unknown:
      default:
        return Colors.white;
    }
  }
}

class Habit extends DBTable {
  // --------------
  //  Table Fields
  // --------------

  final String name;
  final HabitType ty;

  bool enabled;

  // -------------------
  //  Table Constructor
  // -------------------

  Habit({
    int id,
    this.name,
    this.ty,
    this.enabled = false,
  }) : super(id);

  // ----------------
  //  Object Methods
  // ----------------

  // -----------------------
  //  Object Static Methods
  // -----------------------

  static List<Habit> all() => [
        Habit(ty: HabitType.Interest, name: '자전거/킥보드'),
        Habit(ty: HabitType.Interest, name: '오토바이'),
        Habit(ty: HabitType.FaceAndSkin, name: '탈모'),
        Habit(ty: HabitType.FaceAndSkin, name: '여드름'),
        Habit(ty: HabitType.FaceAndSkin, name: '라식'),
        Habit(ty: HabitType.FaceAndSkin, name: '라섹'),
        Habit(ty: HabitType.FaceAndSkin, name: '시력 (근시)'),
        Habit(ty: HabitType.FaceAndSkin, name: '체형'),
        Habit(ty: HabitType.Disease, name: '고혈압'),
        Habit(ty: HabitType.Disease, name: '당뇨'),
        Habit(ty: HabitType.Mental, name: '우울증'),
        Habit(ty: HabitType.Eating, name: '야식'),
        Habit(ty: HabitType.Eating, name: '불규칙적 식사'),
        Habit(ty: HabitType.Eating, name: '음주'),
        Habit(ty: HabitType.Eating, name: '흡연'),
        Habit(ty: HabitType.Eating, name: '배달음식'),
        Habit(ty: HabitType.Eating, name: '라면'),
        Habit(ty: HabitType.Eating, name: '인스턴트'),
      ];

  //------------------------------------------------------------------------//
  // ---------------
  //  Table Methods
  // ---------------

  static String get tableName => 'habits';
  static Map<String, String> get types {
    return {
      'id': 'INTEGER PRIMARY KEY AUTOINCREMENT',
      'name': 'TEXT',
      'ty': 'TEXT',
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'ty': ty.description,
    };
  }

  static Habit fromMap(Map<String, dynamic> map) {
    return Habit(
      id: map['id'],
      name: map['name'],
      ty: HabitTypeExtension.fromDescription(map['ty']),
    );
  }

  // ----------------------
  //  Table Static Methods
  // ----------------------

  String get getTableName => tableName;

  static Future<List<Habit>> getList() async {
    final db = await DB.getInstance();
    final List<Map<String, dynamic>> maps = await db.inner.query(tableName);
    return List.generate(maps.length, (i) => Habit.fromMap(maps[i]));
  }

  //------------------------------------------------------------------------//
}

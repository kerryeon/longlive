import 'package:flutter/material.dart';

enum HabitType {
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
      default:
        return '알 수 없음';
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
      default:
        return Colors.white;
    }
  }
}

class Habit {
  final String name;
  final HabitType ty;

  bool enabled;

  Habit({
    this.name,
    this.ty,
    this.enabled = false,
  });

  static List<Habit> all() => [
        Habit(ty: HabitType.Interest, name: '킥보드'),
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
        Habit(ty: HabitType.Mental, name: '아싸'),
        Habit(ty: HabitType.Mental, name: '무교'),
        Habit(ty: HabitType.Eating, name: '야식'),
        Habit(ty: HabitType.Eating, name: '3끼X'),
        Habit(ty: HabitType.Eating, name: '음주'),
        Habit(ty: HabitType.Eating, name: '흡연'),
        Habit(ty: HabitType.Eating, name: '배달음식'),
        Habit(ty: HabitType.Eating, name: '라면'),
        Habit(ty: HabitType.Eating, name: '인스턴트'),
      ];
}

import 'package:flutter/material.dart';
import 'package:longlive/models/base.dart';
import 'package:longlive/models/net.dart';

class HabitType extends DBTable {
  final String name;
  final Color color;

  const HabitType({
    int id,
    this.name,
    this.color,
  }) : super(id);

  static Map<int, HabitType> _all = {};
  static Map<int, HabitType> get all => _all;

  static Future<void> initialize(BuildContext context) async {
    _all = await Net.getList(
      context: context,
      url: "habits/types",
      generator: fromJson,
    );
  }

  static HabitType fromJson(Map<String, dynamic> json) {
    return HabitType(
      id: json['id'],
      name: json['name'],
      color: Color(
        0xFF000000 +
            int.parse(
              json['color'].substring(1, 7),
              radix: 16,
            ),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'color': '#${color.toString().substring(2, 8)}',
    };
  }

  @override
  String toString() {
    return name;
  }
}

class Habit extends DBTable {
  final String name;
  final HabitType ty;

  Habit({
    int id,
    this.name,
    this.ty,
  }) : super(id);

  static Map<int, Habit> _all = {};
  static Map<int, Habit> get all => _all;

  static Future<void> initialize(BuildContext context) async {
    _all = await Net.getList(
      context: context,
      url: "habits/all",
      generator: fromJson,
    );
  }

  static Habit fromJson(Map<String, dynamic> map) {
    return Habit(
      id: map['id'],
      name: map['name'],
      ty: HabitType.all[map['ty']],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'ty': ty.toJson(),
    };
  }
}

class HabitToggle {
  final Habit habit;
  bool enabled;

  HabitToggle({
    this.habit,
    this.enabled = false,
  });

  static List<HabitToggle> all() {
    return Habit.all.values.map((e) => HabitToggle(habit: e)).toList();
  }
}

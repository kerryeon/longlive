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

  static final Map<int, IconData> _icons = {
    0: Icons.all_inbox_rounded,
    1: Icons.help_rounded,
    2: Icons.whatshot_rounded,
    3: Icons.emoji_people_rounded,
    4: Icons.coronavirus_rounded,
    5: Icons.self_improvement_rounded,
    6: Icons.fastfood_rounded,
  };

  /// 대표 아이콘
  IconData get icon {
    if (_icons.containsKey(id)) {
      return _icons[id];
    }
    return fallBackIcon;
  }

  /// "모두" 아이콘
  static IconData get allIcon => _icons[0];

  /// 예외 아이콘
  static IconData get fallBackIcon => _icons[1];

  static Future<void> initialize(BuildContext context) async {
    _all = await Net().getDict(
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

  /// 대표 아이콘
  IconData get icon => ty.icon;

  static Future<void> initialize(BuildContext context) async {
    _all = await Net().getDict(
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

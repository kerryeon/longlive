import 'package:flutter/material.dart';
import 'package:longlive/models/base.dart';
import 'package:longlive/models/habit.dart';
import 'package:longlive/models/login/core.dart';
import 'package:longlive/models/net.dart';

class Gender extends DBTable {
  final String name;

  const Gender({
    int id,
    this.name,
  }) : super(id);

  static Map<int, Gender> _all = {};
  static Map<int, Gender> get all => _all;

  static Future<void> initialize(BuildContext context) async {
    _all = await Net().getDict(
      context: context,
      url: "user/genders",
      generator: fromJson,
    );
  }

  static Gender fromJson(Map<String, dynamic> json) {
    return Gender(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  @override
  String toString() {
    return name;
  }
}

class User extends DBTable {
  final int age;
  final Gender gender;

  final int term;

  List<Habit> habits = [];

  User({
    int id,
    this.age,
    this.gender,
    this.term,
    this.habits,
  }) : super(id);

  static User _instance;
  static User getInstance() => _instance;

  void initialize() => _instance = this;

  Future<bool> register(BuildContext context) async {
    final user = toJson();
    final habits = user.remove('habits');

    return Net().createOneWithQuery(
      context: context,
      url: 'user/session/register',
      queries: {
        'session': await UserLogin().toJson(context),
        'user': user,
        'habits': habits,
      },
    );
  }

  static User fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      age: json['age'],
      gender: Gender.all[json['gender']],
      term: json['term'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'age': age,
      'gender': gender.id,
      'term': term,
      'habits': habits.map((e) => e.id).toList(),
    };
  }
}

import 'package:longlive/models/habit.dart';

enum Gender {
  Male,
  Female,
}

extension GenderExtension on Gender {
  String get description {
    switch (this) {
      case Gender.Male:
        return '남성';
      case Gender.Female:
        return '여성';
      default:
        return '알 수 없음';
    }
  }
}

class User {
  final Gender gender;
  final int age;
  final List<Habit> habits;

  User({
    this.gender,
    this.age,
    this.habits,
  });

  static User _instance;

  /// 유저 인스턴스를 가져옵니다.
  /// 정보가 초기화되지 않았다면, 이를 초기화합니다.
  static Future<User> getInstance() async {
    return null;
  }

  /// 유저 인스턴스를 임의로 초기화합니다.
  /// 단, 저장은 수동으로 진행됩니다.
  void initialize() {
    _instance = this;
  }
}

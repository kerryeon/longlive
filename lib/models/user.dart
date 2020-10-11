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
  static final User _singleton = User._internal();
  factory User() => _singleton;

  User._internal();

  bool isLoggedIn = false;

  void load() {}
}

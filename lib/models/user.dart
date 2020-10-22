import 'package:longlive/models/db.dart';
import 'package:longlive/models/habit.dart';

enum Gender {
  Unknown,
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
      case Gender.Unknown:
      default:
        return '알 수 없음';
    }
  }

  static Gender fromDescription(String description) {
    switch (description) {
      case '남성':
        return Gender.Male;
      case '여성':
        return Gender.Unknown;
      case '알 수 없음':
      default:
        return Gender.Unknown;
    }
  }
}

class UserInform extends DBTable {
  // --------------
  //  Table Fields
  // --------------

  final Gender gender;
  final int age;

  // -------------------
  //  Table Constructor
  // -------------------

  const UserInform({
    int id,
    this.gender,
    this.age,
  }) : super(id);

  // ----------------
  //  Object Methods
  // ----------------

  // -----------------------
  //  Object Static Methods
  // -----------------------

  //------------------------------------------------------------------------//
  // ---------------
  //  Table Methods
  // ---------------

  static String get tableName => 'users';
  static Map<String, String> get types {
    return {
      'id': 'INTEGER PRIMARY KEY AUTOINCREMENT',
      'gender': 'TEXT',
      'age': 'INTEGER',
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'gender': gender.description,
      'age': age,
    };
  }

  static UserInform fromMap(Map<String, dynamic> map) {
    return UserInform(
      id: map['id'],
      gender: GenderExtension.fromDescription(map['gender']),
      age: map['age'],
    );
  }

  // ----------------------
  //  Table Static Methods
  // ----------------------

  String get getTableName => tableName;

  static Future<UserInform> getUnique() async {
    final db = await DB.getInstance();
    final List<Map<String, dynamic>> maps = await db.inner.query(tableName);
    return UserInform.fromMap(maps[0]);
  }

  //------------------------------------------------------------------------//
}

class User extends UserInform {
  // --------------
  //  Table Fields
  // --------------

  final List<Habit> habits;

  // -------------------
  //  Table Constructor
  // -------------------

  User({
    int id,
    Gender gender,
    int age,
    this.habits,
  }) : super(id: id, gender: gender, age: age);

  // ----------------
  //  Object Methods
  // ----------------

  /// 유저 인스턴스를 임의로 초기화합니다.
  /// 단, 저장은 수동으로 진행됩니다.
  void initialize() {
    _instance = this;
  }

  // -----------------------
  //  Object Static Methods
  // -----------------------

  static User _instance;

  /// 유저 인스턴스를 가져옵니다.
  /// 정보가 초기화되지 않았다면, 이를 초기화합니다.
  static Future<User> getInstance() async {
    return null;
  }

  //------------------------------------------------------------------------//
  // ---------------
  //  Table Methods
  // ---------------

  /// 데이터베이스에 값을 추가합니다.
  @override
  Future<void> insert() async {
    super.insert();
    final db = await DB.getInstance();
    for (final habit in habits) {
      db.insert(habit);
    }
  }

  /// 값을 갱신합니다.
  @override
  Future<void> update() async {
    super.update();
    final db = await DB.getInstance();
    for (final habit in habits) {
      db.update(habit);
    }
  }

  //------------------------------------------------------------------------//
}

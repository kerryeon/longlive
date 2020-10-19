import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'habit.dart';

/// 데이터베이스에 접근할 수 있는 클래스입니다.
class DB {
  static String get _dbName => 'database.db';

  /// 데이터베이스 테이블 정보
  static Map<String, Map<String, String>> get _tables {
    return {
      Habit.tableName: Habit.types,
    };
  }

  static DB _instance;

  /// 데이터베이스 인스턴스를 가져옵니다.
  /// 데이터베이스가 초기화되지 않았다면, 이를 초기화합니다.
  static Future<DB> getInstance() async {
    if (_instance == null) {
      final db = await openDatabase(
        // db 경로
        join(await getDatabasesPath(), _dbName),
        // db 생성자
        onCreate: (db, version) async {
          for (final entry in _tables.entries) {
            await _createTable(db, entry.key, entry.value);
          }
        },
        // db 버전
        version: 1,
      );
      _instance = DB(db);
    }
    return _instance;
  }

  static Future<void> _createTable(
    Database db,
    String tableName,
    Map<String, String> types,
  ) async {
    final params = types.entries
        .map(
          (entry) => '${entry.key} ${entry.value}',
        )
        .join(', ');
    await db.execute(
      'CREATE TABLE $tableName($params)',
    );
  }

  /// 데이터베이스를 제거하고, 인스턴스를 초기화합니다.
  Future<void> deleteAll() async {
    await deleteDatabase(
      join(await getDatabasesPath(), _dbName),
    );
    _instance = null;
  }

  final Database _db;

  const DB(this._db);

  /// SQLite Database 인스턴스를 가져옵니다.
  Database get inner => _db;

  /// 데이터베이스에 값을 추가합니다.
  Future<void> insert(DBTable object) async {
    await _db.insert(
      object.getTableName,
      object.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// 값을 갱신합니다.
  Future<void> update(DBTable object) async {
    await _db.update(
      object.getTableName,
      object.toMap(),
      where: 'id = ?',
      whereArgs: [object.id],
    );
  }

  /// 값을 삭제합니다.
  Future<void> delete(DBTable object) async {
    await _db.delete(
      object.getTableName,
      where: 'id = ?',
      whereArgs: [object.id],
    );
  }
}

/// 데이터베이스 테이블을 구성하는 추상 클래스입니다.
abstract class DBTable {
  final int id;

  const DBTable(this.id);

  String get getTableName;
  Map<String, dynamic> toMap();

  /// 데이터베이스에 값을 추가합니다.
  Future<void> insert() async => (await DB.getInstance()).insert(this);

  /// 값을 갱신합니다.
  Future<void> update() async => (await DB.getInstance()).update(this);

  /// 값을 갱신합니다.
  Future<void> delete() async => (await DB.getInstance()).delete(this);

  @override
  String toString() {
    return toMap().toString();
  }
}

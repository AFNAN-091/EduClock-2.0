import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _databaseName = "data.db";
  static const _databaseVersion = 1;

  static const table = 'data';

  static const columnId = 'id';
  static const columnCourseName = 'courseName';
  static const columnCredit = 'credit';
  static const columnTT1 = 'tt1';
  static const columnTT2 = 'tt2';
  static const columnTT3 = 'tt3';
  static const columnQuiz = 'quiz';
  static const columnFinal = 'final';
  static const columnTotal = 'total';
  static const columnCGPA = 'cgpa';
  static const columnGrade = 'grade';

  // Singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        $columnId INTEGER PRIMARY KEY,
        $columnCourseName TEXT NOT NULL,
        $columnCredit INTEGER NOT NULL,
        $columnTT1 INTEGER NOT NULL,
        $columnTT2 INTEGER NOT NULL,
        $columnTT3 INTEGER NOT NULL,
        $columnQuiz INTEGER NOT NULL,
        $columnFinal INTEGER NOT NULL,
        $columnTotal INTEGER NOT NULL,
        $columnCGPA REAL NOT NULL,
        $columnGrade TEXT NOT NULL
      )
    ''');
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    // int id = row[columnId];
    return await db.update(table, row,  where: 'id = ?', whereArgs: [row['id']],);
  }

  Future<void> updateRowId(int newId, int oldId) async {
    final db = await instance.database;
    await db.update(
      table,
      {'id': newId},
      where: 'id = ?',
      whereArgs: [oldId],
    );
  }

}

// import 'package:sqflite/sqflite.dart';
//
// import '../models/task.dart';
//
// class DBHelper {
//   static Database? _db;
//   static final int _version = 1;
//   static final String _tableNamse = 'Routine';
//
//   static Future<void> init() async {
//     // implementation
//     if (_db != null) {
//       return;
//     }
//     try {
//       String _path = await getDatabasesPath() + 'routineManagement.db';
//       _db = await openDatabase(_path, version: _version,
//
//           onCreate: (db, version) {
//           print('Creating table');
//           return  db.execute(
//             "CREATE TABLE $_tableNamse("
//                 "id INTEGER PRIMARY KEY AUTOINCREMENT,"
//                  " courseName STRING, courseCode STRING, roomNo STRING,"
//               "date STRING, startTime STRING, endTime STRING,"
//               "description TEXT, remind INTEGER, color INTEGER)"
//           );
//           },
//       );
//     } catch (e) {
//       print(e);
//     }
//   }
//
//   static Future<int> insert(Task? task) async {
//     // implementation
//       print('Inserting data');
//       return await _db!.insert(_tableNamse, task!.toJson());
//
//   }
//
//
//   static Future<List<Map<String, dynamic>>> query() async {
//     // implementation
//     print('Querying data');
//     return await _db!.query(_tableNamse);
//   }
//
//
//   static update(Task task) async{
//     // implementation
//
//     await _db!.update(_tableNamse, task.toJson(), where: 'id = ?', whereArgs: [task.id]);
//
//   }
//
//   // static Future<void> update(String table, Map<String, Object> data) async {
//   //   // implementation
//   // }
//
//   static delete(Task task) async {
//     // implementation
//     await _db!.delete(_tableNamse, where: 'id = ?', whereArgs: [task.id]);
//   }
//
//   // static Future<List<Map<String, dynamic>>> getData(String table) async {
//   //   // implementation
//   // }
// }

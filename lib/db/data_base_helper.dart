import 'package:firebase_database/firebase_database.dart';
import '../models/exam_model.dart';
import '../models/notice_model.dart';
import '../models/task.dart';
import 'package:shared_preferences/shared_preferences.dart';


class FirebaseService {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  // Helper method to get department and semester from SharedPreferences
  Future<Map<String, String>> _getDepartmentAndSemester() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? department = prefs.getString('department');
    String? semester = prefs.getString('semester');

    if (department != null && semester != null) {
      return {'department': department, 'semester': semester};
    } else {
      throw Exception('Department or Semester not set in preferences');
    }
  }

  // CRUD operations for Exam
  Future<void> addExam(Exam exam) async {
    final prefs = await _getDepartmentAndSemester();
    await _database
        .child('departments/${prefs['department']}/${prefs['semester']}/exams')
        .push()
        .set(exam.toJson());
  }

  Future<DataSnapshot> getExams() async {
    final prefs = await _getDepartmentAndSemester();
    DatabaseEvent event = await _database
        .child('departments/${prefs['department']}/${prefs['semester']}/exams')
        .once();
    return event.snapshot;
  }

  Future<void> updateExam(String id, Exam exam) async {
    final prefs = await _getDepartmentAndSemester();
    await _database
        .child('departments/${prefs['department']}/${prefs['semester']}/exams/$id')
        .set(exam.toJson());
  }

  Future<void> deleteExam(String id) async {
    final prefs = await _getDepartmentAndSemester();
    await _database
        .child('departments/${prefs['department']}/${prefs['semester']}/exams/$id')
        .remove();
  }

  // CRUD operations for Notice
  Future<void> addNotice(Notice notice) async {
    final prefs = await _getDepartmentAndSemester();
    final DatabaseReference _dbRef = _database.child('departments/${prefs['department']}/${prefs['semester']}/notices');

    DatabaseReference newNoticeRef = _dbRef.push();
    notice.id = newNoticeRef.key;  // Assign the auto-generated key to the notice
    await newNoticeRef.set(notice.toJson());
  }

  Future<DataSnapshot> getNotices() async {
    final prefs = await _getDepartmentAndSemester();
    DatabaseEvent event = await _database
        .child('departments/${prefs['department']}/${prefs['semester']}/notices')
        .once();
    return event.snapshot;
  }

  Future<void> updateNotice(String id, Notice notice) async {
    final prefs = await _getDepartmentAndSemester();
    await _database
        .child('departments/${prefs['department']}/${prefs['semester']}/notices/$id')
        .set(notice.toJson());
  }

  Future<void> deleteNotice(String id) async {
    final prefs = await _getDepartmentAndSemester();
    await _database
        .child('departments/${prefs['department']}/${prefs['semester']}/notices/$id')
        .remove();
  }

  // CRUD operations for Task
  Future<void> addTask(Task task) async {
    final prefs = await _getDepartmentAndSemester();
    final DatabaseReference _dbRef = _database.child('departments/${prefs['department']}/${prefs['semester']}/tasks');

    DatabaseReference newTaskRef = _dbRef.push();
    task.id = newTaskRef.key;  // Assign the auto-generated key to the task
    await newTaskRef.set(task.toJson());
  }

  Future<DataSnapshot> getTasks() async {
    final prefs = await _getDepartmentAndSemester();
    DatabaseEvent event = await _database
        .child('departments/${prefs['department']}/${prefs['semester']}/tasks')
        .once();
    return event.snapshot;
  }

  Future<void> updateTask(String id, Task task) async {
    final prefs = await _getDepartmentAndSemester();
    await _database
        .child('departments/${prefs['department']}/${prefs['semester']}/tasks/$id')
        .set(task.toJson());
  }

  Future<void> deleteTask(String id) async {
    final prefs = await _getDepartmentAndSemester();
    await _database
        .child('departments/${prefs['department']}/${prefs['semester']}/tasks/$id')
        .remove();
  }
}

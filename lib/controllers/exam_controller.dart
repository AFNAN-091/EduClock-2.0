import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../db/data_base_helper.dart';
import '../models/exam_model.dart';
import '../models/notice_model.dart';
import '../models/task.dart';

//Exam Controller

class ExamController with ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  List<Exam> examList = [];
  bool isLoading = false;


  List<Exam> get exams => examList;

  Future<void> fetchExams() async {

    isLoading = true;
    notifyListeners();
    try{
      DataSnapshot snapshot = await _firebaseService.getExams();
      if(snapshot.value != null)
      {
          examList = (snapshot.value as Map).entries
              .map((e) => Exam.fromJson(Map<String, dynamic>.from(e.value)))
              .toList();
      }
      else{
        examList = [];
      }
    } catch (e) {
      print("Error fetching exams: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }


  Future<void> addExam(Exam exam) async {
    await _firebaseService.addExam(exam);
    fetchExams();
  }

  Future<void> updateExam(String id, Exam exam) async {
    await _firebaseService.updateExam(id, exam);
    fetchExams();
  }

  Future<void> deleteExam(String id) async {
    await _firebaseService.deleteExam(id);
    fetchExams();
  }
}

// Notice Controller
class NoticeController with ChangeNotifier {

  final FirebaseService _firebaseService = FirebaseService();
  List<Notice> noticeList = [];
  bool isLoading = false;


  // List<Notice> get notices => _notices;

  Future<void> fetchNotices() async {
    // Set loading to true before starting the fetch
    isLoading = true;
    notifyListeners(); // Notify listeners about the loading state

    try {
      DataSnapshot snapshot = await _firebaseService.getNotices();
      if(snapshot.value != null)
      {
        noticeList = (snapshot.value as Map).entries
            .map((e) => Notice.fromJson(Map<String, dynamic>.from(e.value)))
            .toList();
      }
      else{
        noticeList = [];
      }

    } catch (e) {
      print("Error fetching notices: $e");
      // Handle any errors if needed
    } finally {
      // Set loading to false once fetching is done
      isLoading = false;
      notifyListeners(); // Notify listeners that loading has finished
    }
  }

  Future<void> addNotice(Notice notice) async {
    await _firebaseService.addNotice(notice);
    fetchNotices();
  }

  Future<void> updateNotice(String id, Notice notice) async {
    await _firebaseService.updateNotice(id, notice);
    fetchNotices();
  }

  Future<void> deleteNotice(String id) async {
    await _firebaseService.deleteNotice(id);
    fetchNotices();
  }
}


// Task Controller
class TaskController with ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  List<Task> taskList = [];

  // List<Task> get tasks => taskList;

  Future<void> fetchTasks() async {
    DataSnapshot snapshot = await _firebaseService.getTasks();

    if (snapshot.value != null) {
      taskList = (snapshot.value as Map<dynamic, dynamic>).entries
          .map((e) => Task.fromJson(Map<String, dynamic>.from(e.value)))
          .toList();
    } else {
      // Handle the case where there are no tasks
      taskList = [];
    }

    notifyListeners();
  }


  Future<void> addTask(Task task) async {
    await _firebaseService.addTask(task);
    fetchTasks();
  }

  Future<void> updateTask(String id, Task task) async {
    await _firebaseService.updateTask(task.id!, task);
    fetchTasks();
  }

  Future<void> deleteTask(String id) async {
    await _firebaseService.deleteTask(id);
    fetchTasks();
  }
}

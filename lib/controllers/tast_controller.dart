// import 'package:get/get.dart';
// import 'package:routine_management/db/db_helper.dart';
//
// import '../models/task.dart';
//
// class TaskController extends GetxController {
//   var taskList =  <Task>[].obs;
//
//   @override
//   void onReady() {
//     getTasks();
//     super.onReady();
//   }
//
//   Future<int>addTask({Task? task}) async{
//     print(task!.courseCode);
//     return await DBHelper.insert(task);
//   }
//
//   void getTasks() async {
//     List<Map<String, dynamic>> tasks = await DBHelper.query();
//     taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
//   }
//
//   // void addTask(String title, String description) {
//   //   taskList.add({
//   //
//   //     'description': description,
//   //   });
//   // }
//   void updateTask(Task task) {
//     DBHelper.update(task);
//     getTasks();
//   }
//
//   void removeTask(Task task) {
//     DBHelper.delete(task);
//     getTasks();
//   }
// }
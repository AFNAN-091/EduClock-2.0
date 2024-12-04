import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:routine_management/ui/theme.dart';
import 'package:routine_management/ui/widget/update_task.dart';
import '../db/data_base_helper.dart';
import '../models/task.dart';

class TaskTile extends StatelessWidget {
  final Task? task;
  TaskTile(this.task, {super.key});

  final FirebaseService _firebaseService = FirebaseService();


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;



    return Container(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
      width: screenWidth,
      margin: EdgeInsets.only(bottom: screenHeight * 0.01, top: screenHeight * 0.01),
      child: Container(
        padding: EdgeInsets.fromLTRB(screenWidth * 0.04, screenHeight * 0.01,
            screenWidth * 0.04, screenHeight * 0.01),
        //  width: SizeConfig.screenWidth * 0.78,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: _getBGClr(task?.color ?? 0),
        ),
        child: Row(children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task?.courseName ?? "",
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                SizedBox(height: screenHeight * 0.005),
                Text(
                  task?.courseCode?.toUpperCase() ?? "",
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(fontSize: screenWidth * 0.04, color: Colors.grey[100]),
                  ),
                ),
                SizedBox(
                  height:screenHeight * 0.01,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      color: Colors.grey[200],
                      size: screenWidth * 0.04,
                    ),
                    SizedBox(width: screenWidth * 0.02),
                    Text(
                      "${task!.startTime} - ${task!.endTime}",
                      style: GoogleFonts.lato(
                        textStyle:
                            TextStyle(fontSize: screenWidth * 0.035, color: Colors.grey[100]),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.005),
                Text(
                  task?.description ?? "",
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(fontSize: screenWidth * 0.04, color: Colors.grey[100]),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
            height: screenHeight * 0.06,
            width: screenWidth * 0.005,
            color: Colors.grey[200]!.withOpacity(0.7),
          ),
          Column(
            children: [

              Text(
                "Room No.",
                style: GoogleFonts.lato(
                  textStyle: TextStyle(fontSize: screenWidth * 0.04, color: Colors.grey[100]),
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              Text(
                task?.roomNo ?? "",
                style: GoogleFonts.lato(
                  textStyle: TextStyle(fontSize:  screenWidth * 0.04, color: Colors.grey[100]),
                ),
              ),
            ],
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,

            children: [
              _popup(context,task),
            ],
          )

        ]),
      ),
    );
  }

  _popup(BuildContext context, task ){
    return Center(
      child: PopupMenuButton<String>(
        icon: const Icon(Icons.more_vert_rounded),
        onSelected: (String result) {
          _onMenuItemSelected(context, result);
          print(result);
        },
        itemBuilder: (BuildContext context) {
          return [
            const PopupMenuItem(
              value: "Edit",
              child: ListTile(
                title: Text("Edit"),
                leading: Icon(Icons.edit),
              ),
            ),
            const PopupMenuItem(
              value: "Delete",
              child: ListTile(
                title: Text("Delete"),
                leading: Icon(Icons.delete),
              ),
            ),
          ];

        }
      )
    );
  }

  void _onMenuItemSelected(BuildContext context, String value) async {
    // final _taskController = Get.put(TaskController());

    if (value == 'Edit') {
      // print('Task id: ${task.id}');
      // Add your edit logic here
      Get.to(() => UpdateTask(task: task));


    } else if (value == 'Delete') {
      // Add your delete logic here
      // _taskController.removeTask(task!);
      // _taskController.getTasks();
      if(task?.id != null)
        {
          await _firebaseService.deleteTask(task!.id!);
          Get.snackbar('Class', 'Deleted!',
            backgroundColor: Colors.white,
            snackPosition: SnackPosition.TOP,
            icon: const Icon(Icons.delete, color: Colors.red),
          );
        }
      else{
        Get.snackbar('Class', 'Error!',
          backgroundColor: Colors.white,
          snackPosition: SnackPosition.TOP,
          icon: const Icon(Icons.error, color: Colors.red),
        );
      }
    }
  }

  _getBGClr(int no) {
    switch (no) {
      case 0:
        return yellowDarkColor;
      case 1:
        return pinkishColor;
      case 2:
        return pink;
      case 3:
        return sky;
      case 4:
        return lightGreen;
      default:
        return light;
    }
  }
}

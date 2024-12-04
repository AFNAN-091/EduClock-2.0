import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:routine_management/controllers/exam_controller.dart';
import 'package:routine_management/ui/widget/button.dart';
import 'package:routine_management/ui/widget/input_field.dart';

import '../db/data_base_helper.dart';
import '../models/exam_model.dart';

class AddExam extends StatefulWidget {
  const AddExam({super.key});

  @override
  State<AddExam> createState() => _AddExamState();
}

class _AddExamState extends State<AddExam> {

  final FirebaseService _firebaseService = FirebaseService();

  late ExamController _examController;
  String _startTime = "8:00 AM";


  final TextEditingController _courseNameController = TextEditingController();
  final TextEditingController _courseCodeController = TextEditingController();
  final TextEditingController _examTypeController = TextEditingController();
  final TextEditingController _syllabusController = TextEditingController();
  final TextEditingController _roomNoController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _examHourController = TextEditingController();
  final  TextEditingController _dateController = TextEditingController();
  DateTime _selectedDate = DateTime.now();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('ADD EXAM',
            style: TextStyle(
                color: Colors.blueGrey,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        centerTitle: true,
        // backgroundColor: context.theme.primaryColorLight,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back,
            size: 20,
            color: Colors.blueGrey,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          // Text(
          //   "Add Class",
          //   style: headingStyle,
          // ),
          MyInputField(
              title: "Course Title",
              hint: "Enter Course Title",
              controller: _courseNameController, isRequired: true, isDescription: false,),
          // const SizedBox(height: 4,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: MyInputField(
                    title: "Course Code",
                    hint: "CSE 350",
                    controller: _courseCodeController, isRequired: false, isDescription: false),
              ),
              Expanded(
                child:MyInputField(
                    title: "Start Time",
                    hint: "10:00 AM",
                    controller: _startTimeController, isRequired: true, isDescription: false,
                    widget: IconButton(
                      icon: const Icon(Icons.access_time_outlined,
                          color: Colors.grey),
                      onPressed: () {
                        _getTimeFromUser(isStartTime: true);
                      },
                    )
                ),
              ),
            ],
          ),

          // const SizedBox(height: 4,),

          Row(
            children: [
              Expanded(
                child: MyInputField(
                  title: "Room No",
                  hint: "109",
                  controller: _roomNoController, isRequired: true, isDescription: false,),
              ),
              Expanded(
                child: MyInputField(
                  title: "Exam Hour",
                  hint: "3 hr",
                  controller: _examHourController, isRequired: true, isDescription: false,),
              ),

            ],
          ),
          // const SizedBox(height: 4,),
          MyInputField(
            title: "Exam Type",
            hint: "TT/ Lab/ Quiz/ Semester final",
            controller: _examTypeController, isRequired: true, isDescription: false,),
          MyInputField(
              title: "Date",
              hint: "Enter Date",
              controller: _dateController, isRequired: true, isDescription: false,
              widget: IconButton(
                icon: const Icon(Icons.calendar_today_outlined,
                    color: Colors.grey),
                onPressed: () {
                  _selectDate(context);
                },
              )
          ),
          MyInputField(
              title: "Syllabus",
              hint: "Enter Syllabus",
              controller: _syllabusController, isRequired: true, isDescription: true),
          const SizedBox(height: 20),
          MyButton(
            label: "POST EXAM",
            onTap: () {
              _validData();
              // _addTask();
            },
          ),
        ]),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text  = DateFormat.yMd().format(_selectedDate);
      });
    }
  }

  int getRandomInt(int min, int max) {
    final random = Random();
    return min + random.nextInt(max - min);
  }

  Future<void> _uploadNotice() async {
    int color = getRandomInt(0, 5);
    print("exam post");

      // Create exam data

      Exam exam = Exam(
          courseName: _courseNameController.text,
          courseCode: _courseCodeController.text,
          examType: _examTypeController.text,
          syllabus: _syllabusController.text,
          roomNo: _roomNoController.text,
          startTime: _startTimeController.text,
          examHour: _examHourController.text,
          date: _dateController.text,
          errorDate: _selectedDate.toString(),
          type: "exam",
          color: color
      );



      await _firebaseService.addExam(exam);

      Get.back(result: true);
    // if (mounted) {
    //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Notice Posted Successfully')));
    //   Get.back(result: true);
    // }

      // Get.back();


  }


  _validData() {
    if (_courseNameController.text.isNotEmpty && _dateController.text.isNotEmpty
          && _examHourController.text.isNotEmpty && _roomNoController.text.isNotEmpty
          && _startTimeController.text.isNotEmpty && _examTypeController.text.isNotEmpty
    ) {
      //add database

      _uploadNotice();

    } else if (_courseNameController.text.isEmpty) {
      Get.snackbar("Required", "Course name is required",
          backgroundColor: Colors.white,
          icon: const Icon(
            Icons.warning_amber_rounded,
            color: Colors.red,
          ));
    }
    else if (_courseCodeController.text.isEmpty) {
      Get.snackbar("Required", "Course code is required",
          backgroundColor: Colors.white,
          icon: const Icon(
            Icons.warning_amber_rounded,
            color: Colors.red,
          ));
    }
    else if (_examTypeController.text.isEmpty) {
      Get.snackbar("Required", "Exam Type is required",
          backgroundColor: Colors.white,
          icon: const Icon(
            Icons.warning_amber_rounded,
            color: Colors.red,
          ));
    }
    else if (_examHourController.text.isEmpty) {
      Get.snackbar("Required", "Exam Hour is required",
          backgroundColor: Colors.white,
          icon: const Icon(
            Icons.warning_amber_rounded,
            color: Colors.red,
          ));
    }
    else if (_startTimeController.text.isEmpty) {
      Get.snackbar("Required", "Start Time is required",
          backgroundColor: Colors.white,
          icon: const Icon(
            Icons.warning_amber_rounded,
            color: Colors.red,
          ));
    }
    else if (_dateController.text.isEmpty) {
      Get.snackbar("Required", "Date is required",
          backgroundColor: Colors.white,
          icon: const Icon(
            Icons.warning_amber_rounded,
            color: Colors.red,
          ));
    }
    else if (_roomNoController.text.isEmpty) {
      Get.snackbar("Required", "Course Title is required",
          backgroundColor: Colors.white,
          icon: const Icon(
            Icons.warning_amber_rounded,
            color: Colors.red,
          ));
    }
    else if (_syllabusController.text.isEmpty) {
      Get.snackbar("Required", "Syllabus is required",
          backgroundColor: Colors.white,
          icon: const Icon(
            Icons.warning_amber_rounded,
            color: Colors.red,
          ));
    }
  }


  _getTimeFromUser({required bool isStartTime}) async {
    TimeOfDay? timePicker = await _showTimePicker();

    if (timePicker != null) {
      String _formattedTime = timePicker.format(context);
      setState(() {
          _startTime = _formattedTime;
          _startTimeController.text = _formattedTime;
      });
    } else {
      print("Time is not selected");
    }
  }

  _showTimePicker() {
    return showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
      initialTime: TimeOfDay.now(),
    );
  }



}

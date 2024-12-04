import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'package:routine_management/ui/theme.dart';
import 'package:routine_management/ui/widget/button.dart';
import 'package:routine_management/ui/widget/input_field.dart';

import '../controllers/tast_controller.dart';
import '../db/data_base_helper.dart';
import '../models/task.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {

  // final TaskController _taskController = Get.put(TaskController());
  final FirebaseService _firebaseService = FirebaseService();

  DateTime _selectedDate = DateTime.now();
  String _startTime = "8:00 AM";
  String _endTime = "5:00 PM";
  final TextEditingController _courseController = TextEditingController();
  final TextEditingController _roomController = TextEditingController();
  final TextEditingController _courseCodeController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text('ADD CLASS',
            style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)
          ),
          centerTitle: true,
          // backgroundColor: context.theme.primaryColorLight,
          leading: IconButton(
            icon: const FaIcon(FontAwesomeIcons.angleLeft),
            color: Colors.black,
            onPressed: () {
              Navigator.pop(context);
            },
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
              controller: _courseController,
              isRequired: true,
              isDescription: false),
          Row(
            children: [
              Expanded(
                  child: MyInputField(
                      title: "Course Code",
                      hint: "CSE350",
                      controller: _courseCodeController,
                      isRequired: false,
                      isDescription: false)),
              Expanded(
                  child: MyInputField(
                      title: "Room no.",
                      hint: "Gallery-1",
                      controller: _roomController,
                      isRequired: true,
                      isDescription: false))
            ],
          ),
          MyInputField(
              title: "Date",
              hint: DateFormat.yMd().format(_selectedDate),
              controller: _dateController,
              isRequired: true,
              isDescription: false,
              widget: IconButton(
                icon: const Icon(Icons.calendar_today_outlined,
                    color: Colors.grey),
                onPressed: () {
                  _getDateFromUser();
                },
              )),
          Row(children: [
            Expanded(
              child: MyInputField(
                title: 'Start Time',
                hint: _startTime,
                isRequired: false,
                isDescription: false,
                controller: _startTimeController,
                widget: IconButton(
                  icon: const Icon(Icons.access_time, color: Colors.grey),
                  onPressed: () {
                    _getTimeFromUser(isStartTime: true);
                  },
                ),
              ),
            ),
            Expanded(
              child: MyInputField(
                title: 'Last Time',
                hint: _endTime,
                controller: _endTimeController,
                isRequired: false,
                isDescription: false,
                widget: IconButton(
                  icon: const Icon(Icons.access_time, color: Colors.grey),
                  onPressed: () {
                    _getTimeFromUser(isStartTime: false);
                  },
                ),
              ),
            ),
          ]),
              MyInputField(
              title: "Description",
              hint: "Description",
              controller: _descriptionController,
              isRequired: false,
              isDescription: true),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              MyButton(label: "Assign Class", onTap: (){
                _validData();
              }),
            ],
          )
        ])));
  }

  int getRandomInt(int min, int max) {
    final random = Random();
    return min + random.nextInt(max - min);
  }



  void _addTaskToDb() async {
    int repeat = 30;
    int color = getRandomInt(0, 5);
    print("hello");

    Task task = Task(
      // id: val,
      courseName: _courseController.text,
      courseCode: _courseCodeController.text,
      roomNo: _roomController.text,
      date: _dateController.text,
      startTime: _startTimeController.text,
      endTime: _endTimeController.text,
      description: _descriptionController.text,
      type: "class",
      color: color,
      remind: repeat,
    );

    await _firebaseService.addTask(task);
    print("Data inserted");
  }


  _validData() {
    if (_courseController.text.isNotEmpty &&
        _dateController.text.isNotEmpty &&
        _roomController.text.isNotEmpty) {
      //add database

      _addTaskToDb();
      Get.back();

    } else if (_courseController.text.isEmpty) {
      Get.snackbar("Required", "Course Title is required",
          backgroundColor: Colors.white,
          icon: const Icon(
            Icons.warning_amber_rounded,
            color: Colors.red,
          ));
    } else if (_dateController.text.isEmpty) {
      Get.snackbar("Required", "Date is required",
          backgroundColor: Colors.white,
          icon: const Icon(
            Icons.warning_amber_rounded,
            color: Colors.red,
          ));
    } else if (_roomController.text.isEmpty) {
      Get.snackbar("Required", "Room no. is required",
          backgroundColor: Colors.white,
          icon: const Icon(
            Icons.warning_amber_rounded,
            color: Colors.red,
          ));
    }
  }

  _getDateFromUser() async {
    DateTime? _pickedDate = await showDatePicker(
        context: context,
        firstDate: DateTime.now(),
        lastDate: DateTime(2050),
        initialDate: DateTime.now());

    if (_pickedDate != null) {
      setState(() {
        _selectedDate = _pickedDate;
        _dateController.text = DateFormat.yMd().format(_pickedDate);
        // print(_selectedDate);
      });
    } else {
      print("Date is not selected");
    }
  }

  _getTimeFromUser({required bool isStartTime}) async {
    TimeOfDay? timePicker = await _showTimePicker();

    if (timePicker != null) {
      String _formattedTime = timePicker.format(context);
      setState(() {
        if (isStartTime) {
          _startTime = _formattedTime;
          _startTimeController.text = _formattedTime;
        } else {
          _endTime = _formattedTime;
          _endTimeController.text = _formattedTime;
        }
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

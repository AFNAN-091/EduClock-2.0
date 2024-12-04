import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:routine_management/controllers/tast_controller.dart';
import 'dart:math';
import 'package:routine_management/ui/theme.dart';
import 'package:routine_management/ui/widget/button.dart';
import 'package:routine_management/ui/widget/input_field.dart';

import '../../db/data_base_helper.dart';
import '../../models/task.dart';


class UpdateTask extends StatefulWidget {

  final Task? task;
  const UpdateTask({super.key, required this.task});

  @override
  State<UpdateTask> createState() => _UpdateTaskState();
}

class _UpdateTaskState extends State<UpdateTask> {



  // final TaskController _taskController = Get.put(TaskController());

  final FirebaseService _firebaseService = FirebaseService();

  DateTime _selectedDate = DateTime.now();
  String _startTime = "8:00 AM";
  String _endTime = "5:00 PM";
  late TextEditingController _courseController = TextEditingController();
  late TextEditingController _roomController = TextEditingController();
  late TextEditingController _courseCodeController = TextEditingController();

  late TextEditingController _startTimeController = TextEditingController();
  late TextEditingController _endTimeController = TextEditingController();
  late TextEditingController _dateController = TextEditingController();
  late TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedDate = DateFormat.yMd().parse(widget.task!.date!);
    _startTime = widget.task?.startTime ?? "8:00 AM";
    _endTime = widget.task?.endTime ?? "5:00 PM";
    _courseController = TextEditingController(text: widget.task?.courseName);
    _roomController = TextEditingController(text: widget.task?.roomNo);
    _courseCodeController = TextEditingController(text: widget.task?.courseCode);
    _startTimeController = TextEditingController(text: _startTime);
    _endTimeController = TextEditingController(text: _endTime);
    _dateController = TextEditingController(text: widget.task?.date);
    _descriptionController = TextEditingController(text: widget.task?.description);
  }

  @override
  void dispose() {
    _courseController.dispose();
    _roomController.dispose();
    _courseCodeController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    _dateController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text('UPDATE CLASS'),
          centerTitle: true,
          backgroundColor: context.theme.primaryColorLight,
          leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: const Icon(
              Icons.arrow_back,
              size: 20,
              color: Colors.black,
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
                  MyButton(label: "UPDATE Class", onTap: (){
                    _validData();

                  }
                  ),
                ],
              )
            ])));
  }

  int getRandomInt(int min, int max) {
    final random = Random();
    return min + random.nextInt(max - min);
  }


  _validData() async {
    if (_courseController.text.isNotEmpty &&
        _dateController.text.isNotEmpty &&
        _roomController.text.isNotEmpty) {
      //add database
      Task task = Task(
        id: widget.task?.id,
        courseName: _courseController.text,
        courseCode: _courseCodeController.text,
        roomNo: _roomController.text,
        date: _dateController.text,
        startTime: _startTimeController.text,
        endTime: _endTimeController.text,
        description: _descriptionController.text,

      );

      // print("Task ID: ${widget.task?.id}");


      if (task.id != null) {
        await _firebaseService.updateTask(task.id!, task);
        print("Data Updated");
        Get.back();
        Get.snackbar("Update", "${task.courseName} Class Updated Successfully!",
            backgroundColor: Colors.white,
            icon: const Icon(
              Icons.update_outlined,
              color: Colors.green,
            ));
      } else {
        print("Error: Task ID is null");
      }


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

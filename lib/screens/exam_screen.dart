import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:routine_management/controllers/exam_controller.dart';
import 'package:routine_management/screens/exam_details.dart';
import 'package:routine_management/screens/question_screen.dart';
import 'package:routine_management/screens/resources.dart';
import 'package:routine_management/ui/add_exam.dart';
import 'package:routine_management/ui/exam_bar.dart';
import 'package:routine_management/ui/theme.dart';

import '../models/exam_model.dart';
import 'home_page.dart';
import 'login_screen.dart';
import 'notice_screen.dart';

class ExamScreen extends StatefulWidget {
  // final String department;
  ExamScreen({super.key});

  @override
  State<ExamScreen> createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  late ExamController _examController;

  @override
  void initState() {
    super.initState();
    _examController = Provider.of<ExamController>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _examController.fetchExams();
    });
    _sortExamsByDate();
  }

  void _sortExamsByDate() {
    _examController.examList.sort((a, b) {
      // DateTime dateA = DateTime.parse(a.errorDate);
      // DateTime dateB = DateTime.parse(b.errorDate);
      return a.date.compareTo(b.date);
    });
  }

  Future<void> _refreshExams() async {
    _examController = Provider.of<ExamController>(context, listen: false);
    await _examController.fetchExams();
    _sortExamsByDate();
  }

  @override
  Widget build(BuildContext context) {

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;


    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(screenHeight * 0.08),
          child: AppBar(
            title: Text(
              'Exams',
              style: subHeadingStyle.copyWith(
                fontSize: screenWidth * 0.05,
              ),
            ),
            backgroundColor: Colors.white,
            ),
          ),
        body: Consumer<ExamController>(
          builder: (context, _examController, _) {
            if (_examController.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (_examController.examList.isEmpty) {
              return  Center(
                child: Text('No upcoming exams are listed.\n \nWe\'ll update you as soon as new ones are available!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.w500,
                    color: Colors.red,
                  ),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: _refreshExams,
              child: _showExam(),
            );
          },
        ),
        floatingActionButton: SizedBox(
          height: screenHeight * 0.05, // Responsive FloatingActionButton height
          width: screenWidth * 0.23, // Responsive FloatingActionButton width
          child: FloatingActionButton(
            backgroundColor: primaryColor,
            onPressed: () async {
              var result = await Get.to(() => const AddExam());
              if (result == true) {
                await _examController.fetchExams();
                _sortExamsByDate();
              }
            },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: screenWidth * 0.01, horizontal: screenWidth * 0.01),
              child:  Row(
                children: [
                  Icon(
                    Icons.add,
                    size: screenWidth * 0.06,
                    color: Colors.white,
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  Text(
                    'New',
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  _showExam() {
    return ListView.builder(
        itemCount: _examController.examList.length,
        itemBuilder: (context, index) {
          DateTime examDate =
              DateTime.parse(_examController.examList[index].errorDate);
          // print(_examController.examList.length);
          DateTime today = DateTime.now();
          DateTime yesterday = today.subtract(const Duration(days: 1));
          if (examDate.isBefore(yesterday)) {
            // print(_examController.examList[index].courseName);
            return Container();
          }
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 1000),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: Row(
                  children: [
                    GestureDetector(
                        onTap: () {
                          Get.to(() => ExamDetails(
                              exam: _examController.examList[index]));
                        },
                        child: ExamBar(exam: _examController.examList[index])),
                  ],
                ),
              ),
            ),
          );
        });
  }


}

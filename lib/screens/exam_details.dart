import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../models/exam_model.dart';
import '../ui/theme.dart';

class ExamDetails extends StatelessWidget {
  final Exam exam;
  const ExamDetails({super.key, required this.exam});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const FaIcon(FontAwesomeIcons.angleLeft),
            onPressed: () {
              Get.back();
            },
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _info(),
            const SizedBox(height: 20),
            _description(),
          ],
        ));
  }

  Widget _description(){
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SelectableText(
            'Syllabus: ',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          SelectableText(
            exam.syllabus ?? "",
            style: subTitleStyle1,
          ),
        ],
      ),
    );
  }

  _info(){
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SelectableText(
              exam.courseName ?? "",
               style:  headingStyle,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_month_outlined,
                      color: Colors.black,
                      size: 18,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    SelectableText(
                        exam.date,
                        style: subTitleStyle1
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(
                        Icons.book_outlined,
                        color: Colors.black,
                        size: 18
                    ),
                    const SizedBox(width: 5,),
                    SelectableText(
                        exam.courseCode.toUpperCase(),
                        style: subTitleStyle1
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.schedule_outlined,
                      color: Colors.black,
                      size: 18,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    SelectableText(
                      exam.startTime ?? "",
                      style: subTitleStyle1,
                    ),
                  ],
                ),

                Row(
                  children: [
                    const Icon(
                      Icons.school_outlined,
                      color: Colors.black,
                      size: 18,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    SelectableText(
                      exam.examType ?? "",
                      style: subTitleStyle1,
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.alarm_add_outlined,
                      color: Colors.black,
                      size: 18,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    SelectableText(
                      '${exam.examHour}',
                      style: subTitleStyle1,
                    ),
                  ],
                ),

                Row(
                  children: [
                    const Icon(
                      Icons.door_front_door_outlined,
                      color: Colors.black,
                      size: 18,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    SelectableText('Room: ${exam.roomNo}',
                      style: subTitleStyle1,
                    ),
                  ],
                ),
              ],
            ),
            // const SizedBox(width: 8),
          ]),

    );
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

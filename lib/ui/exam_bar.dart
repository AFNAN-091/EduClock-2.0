import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:routine_management/ui/theme.dart';

import '../models/exam_model.dart';

class ExamBar extends StatelessWidget {
  final Exam exam;
  const ExamBar({super.key, required this.exam});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(bottom: 6, top: 6),
        child: Container(
          padding: const EdgeInsets.all(16),
          //  width: SizeConfig.screenWidth * 0.78,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: _getBGClr(exam.color ?? 0),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exam.courseName ?? "",
                      style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(exam.examType ?? "",
                            style: GoogleFonts.lato(
                              textStyle: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Row(
                          children: [
                          const Icon(Icons.calendar_month,
                          color: Colors.white,
                          size: 18,
                          ),
                          const SizedBox(width: 5,),
                          Text(exam.date,
                            style: GoogleFonts.lato(
                              textStyle: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                          ]
                        )

                      ],
                    )

                  ],
                ),
              )
            ],

          ),

        )
    );;
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
